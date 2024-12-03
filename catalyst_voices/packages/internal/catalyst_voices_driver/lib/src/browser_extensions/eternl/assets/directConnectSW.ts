// increase version to force a browser to reload the file
const version                 = '0.1.0'

import {
  NetworkId,
  networkIdList
}                             from '@eternl/core/NetworkId'

import {
  IWorkerRequestEvent,
  PeerConnectRequestTypes,
  PeerConnectResponseTypes,
  PeerConnectWorkerResponse
}                             from '@eternl/dapp/types/IWorkerEvent'

import { log as stLogger }    from '@eternl/lib/logHelper'

// @ts-ignore
declare let self: ServiceWorkerGlobalScope

const peerConnectionMapKey    = 'peerConnectMap_'
const activeTabsKey           = 'activeTabMap_'

const doLog                   = false
const log                     = (...entries: any[]) => {

  if (doLog)   {

    try {

      stLogger(...entries)

    } catch (e: any) {

      console.log('error in log', e)
    }
  }
}

/**
 *  This is kind of a pseudo broadcast channel to all open tab.
 *  They all register on startup, we save that callback event and add it in here so we can later call back to them.
 */
const tabEventMap = new Map<NetworkId, Map<string, IWorkerRequestEvent<'REGISTER_TAB'>>>()

/**
 * After the service worker is registered, the browser downloads and installs the service worker script file.
 * During the installation stage, the service worker sets up its initial state, such as caching resources,
 * and fires an install event.
 */
// @ts-ignore
self.addEventListener('install', (event: ExtendableEvent) => {

  log('Install service worker')

  self.skipWaiting();
});

/**
 * Once the installation is complete, the service worker goes through an activation stage.
 * During the activation stage, the service worker becomes active and starts handling events.
 * The activation stage also fires an activate event.
 *
 * In this we can also preform shutdown operations that will be done when the worker is shutting down.
 */
// @ts-ignore
self.addEventListener('activate', (event: ExtendableEvent) => {

  log('Active service worker')

  event.waitUntil(
    self.clients
        .claim()
        .then(() => {

          log('Performing cleanup before termination...');

          // Add your cleanup code here
          return new Promise<void>(async (resolve) => {

            // log('CLEAR WORKER MAP')

            // if worker is closing, clear the owner map by creating a new empty one.
            await recreateAllOwnerMaps()

            resolve()
            //ToDo: CORE: broadcast to all clients that worker is shutting down!

            log('server shutdown complete ?')
        });
      })
  )
})

/**
 * Create new empty 'browser tab' to 'dapp connection' mappings for all networks.
 */
const recreateAllOwnerMaps    = async () => {

  // log('Calling: recreateAllOwnerMaps')

  for (const n of networkIdList) {

    await createOwnerMap(n)
  }
}

/**
 * Initializes a new Event Map for a given network id.
 *
 * @param networkId
 */
const createTabEventMap       = (networkId: NetworkId) => {

  if (!tabEventMap.get(networkId)) {

    tabEventMap.set(networkId, new Map())
  }
}

/**
 * Add a register tab event to list so we can later call a message on it.
 *
 * @param networkId
 * @param tabUuid
 * @param event
 */
const addToTabEventMap        = (networkId: NetworkId, tabUuid: string, event: IWorkerRequestEvent<"REGISTER_TAB"> ) => {

  createTabEventMap(networkId)

  const networkEventMap       = tabEventMap.get(networkId)

  if (!networkEventMap!.get(tabUuid)) {

    networkEventMap!.set(tabUuid, event)
  }
}

/**
 * Remove a tab uuid that is no longer active.
 * @param networkId
 * @param tabUuid
 */
const deleteFromTabEventMap   = (networkId: NetworkId, tabUuid: string) => {

  const networkEventMap       = tabEventMap.get(networkId)

  if (networkEventMap && networkEventMap.get(tabUuid)) {

    networkEventMap.delete(tabUuid)
  }
}

/**
 * Checks if a request is of a given request type to provide better type script annotation support.
 * @param type
 * @param obj
 */
function isOfRequestType<K extends keyof PeerConnectRequestTypes>(type: K, obj: IWorkerRequestEvent<keyof PeerConnectRequestTypes>): obj is IWorkerRequestEvent<K> {

  return obj.data.type === type;
}

/**
 * Return the map for which dapp is owned by wich tab uuid.
 */
const getOwnershipMap         = async (networkId: NetworkId,): Promise<Map<string, string> | undefined> => {

  const key = peerConnectionMapKey + networkId

  const ownerMap = await self.caches.match(key)

  if (!ownerMap) {

    return undefined
  }

  const text                  = await ownerMap.text()

  log(key, text)

  return deserializeMap(text)
}

/**
 * Creates a new empty dapp id to uuid map and saves it.
 */
const createOwnerMap          = async (network: NetworkId) => {

  const map                   = new Map<string, string>()

  // log('Map is not existing, create new new map')

  await saveOwnerMap(network, map)

  return map
}

/**
 * Set the owner for a dapp id.
 * @param uuid
 * @param dappId
 */
const setOwnerForDapp         = async (network: NetworkId, uuid: string, dappId: string) => {

  log(network, uuid, dappId)

  let map                     = await getOwnershipMap(network)

  if (!map) {

    map                       = await createOwnerMap(network)

  }

  map.set(dappId, uuid)

  await saveOwnerMap(network, map)
}

/**
 * Save the owner map.
 * @param map
 */
const saveOwnerMap            = async (networkId: NetworkId, map: Map<string, string>) => {

  const key                   = peerConnectionMapKey + networkId

  // log('save map', key, networkId, map)

  const cache                 = await self.caches.open(key);

  const mapString = serializeMap(map)

  // log('Adding to map: ', mapString)

  // TODO: check, error on bex
  // await cache.put(key, new Response(mapString));
}

/**
 * Create tab list to store which tabs currently exists.
 * @param network
 */
const createTabList           = async (network: NetworkId) => {

  const list: string[]        = []

  await saveTabList(network, list)

  return list
}

/**
 * Save tab list to storage.
 *
 * @param networkId
 * @param map
 */
const saveTabList             = async (networkId: NetworkId, map: string[]) => {

  const key                   = activeTabsKey + networkId

  const cache                 = await self.caches.open(key);

  await cache.put(key, new Response(JSON.stringify(map)));
}

/**
 * Returns list of current tabs.
 * @param networkId
 */
const getTabList              = async (networkId: NetworkId): Promise<string[]> => {

  const key                   = activeTabsKey + networkId

  const tabsList              = await self.caches.match(key)

  if (!tabsList) {

    return createTabList(networkId)
  }

  const text                  = await tabsList.text()

  return JSON.parse(text)
}

/**
 * Checks if a dapp id is handled by any worker and return a reference to the worker if it is.
 *
 * @param data
 * @param event
 */
const handleOwnerCheckMessageRequest = async (data: PeerConnectRequestTypes['OWNER_CHECK'], event: IWorkerRequestEvent<any>) => {

  log('handleOwnerCheckMessageRequest: Got owner check rq', data)

  const dappId                = data.targetId
  const from                  = data.fromUuid

  const ownerMap              = await getOwnershipMap(data.networkId)

  if (!ownerMap) {

    log('No owner map found')

    sendResponse(
      event,
      createResponse('OWNER_CHECK', {
        networkId:            data.networkId,
        toUuid:               from,
        targetId:             dappId,
        workerUUID:           null
      }
    ))

    await createOwnerMap(data.networkId)

  } else {

    if (ownerMap.size === 0) {

      log('Map is empty', ownerMap)

      sendResponse(
        event,
        createResponse('OWNER_CHECK', {
          networkId:          data.networkId,
          toUuid:             from,
          targetId:           dappId,
          workerUUID:         null
        })
      )

    } else {

      log('current owner map', ownerMap)

      const owner = ownerMap.get(dappId)

      if (!owner) {
        sendResponse(
          event,
          createResponse('OWNER_CHECK', {
            networkId:        data.networkId,
            toUuid:           from,
            targetId:         dappId,
            workerUUID:       null!
          })
        )
      } else {

        sendResponse(
          event,
          createResponse('OWNER_CHECK', {
            networkId:        data.networkId,
            toUuid:           from,
            targetId:         dappId,
            workerUUID:       owner
          })
        )
      }
    }
  }
}

/**
 * Called when a frontend tab wants to claim ownership of a dapp connection. So it will call this before it is creating
 * the connection. If this is successful, the connection is marked as being created by him. So he is responsible for
 * creating the connection.
 *
 * @param data
 * @param event
 */
const handleClaimOwnerMessageRequest = async (data: PeerConnectRequestTypes['CLAIM_OWNER'], event: IWorkerRequestEvent<any>) => {

  log('handleClaimOwnerMessageRequest', data, event)

  // Check that map exists
  let ownerMap                = await getOwnershipMap(data.networkId)

  if (!ownerMap) {
    await createOwnerMap(data.networkId)

    ownerMap                  = await getOwnershipMap(data.networkId)
  }

  const currentOwner          = ownerMap?.get(data.targetId)

  // Check that no other one has claimed the ownership yet
  if (currentOwner && currentOwner !== data.fromUuid) {

    sendResponse(
      event,
      createResponse('CLAIM_OWNER', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.targetId,
          success:            false,
            owner:            currentOwner
        }
      )
    )

    return
  }

  // add new owner to map
  await setOwnerForDapp(data.networkId, data.fromUuid, data.targetId)

  sendResponse(
    event,
    createResponse('CLAIM_OWNER', {
      networkId:              data.networkId,
         toUuid:              data.fromUuid,
       targetId:              data.targetId,
        success:              true,
          owner:              data.fromUuid
    })
  )
}

/**
 * Called when a tab is registering itself, so basically when it has opened and the PeerConnectManager calls its
 * init function.
 *
 * @param data
 * @param event
 */
const handleRegisterTabMessageRequest = async (data: PeerConnectRequestTypes['REGISTER_TAB'], event: IWorkerRequestEvent<any>) => {

  try {

    let uuid                  = data.fromUuid

    await addToTabEventMap(data.networkId, uuid, event)

    const list                = await getTabList(data.networkId)

    if (!list.includes(uuid)) {

      list.push(uuid)

      await saveTabList(data.networkId, list)

    }

    sendResponse(
      event,
      createResponse('REGISTER_TAB', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.fromUuid,
          success:            true,
      })
    )

  } catch (error: any) {

    sendResponse(
      event,
      createResponse('REGISTER_TAB', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.fromUuid,
          success:            false,
      })
    )
  }
}

/**
 * Called when a tab is releasing the ownership of a connection. Normally when it is closing.
 *
 * In here we will then remove that tab from the tab list, look up what DApp connections it manages and tell other
 * tabs to take over the ownership of those.
 *
 * @param data
 * @param event
 */
const handleReleaseOwnerMessageRequest = async (data: PeerConnectRequestTypes['RELEASE_OWNER'], event: IWorkerRequestEvent<any>) => {

  let ownerMap                = await getOwnershipMap(data.networkId)

  if (!ownerMap) {

    sendResponse(
      event,
      createResponse('RELEASE_OWNER', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.targetId,
          success:            false,
            error:            'No owner map was found.'
      })
    )

    return
  }

  const releasingTab          = data.targetId
  let released                = false
  const releasedDapps         = []

  for (let dappId of ownerMap!.keys()) {

    if (ownerMap.get(dappId) === releasingTab) {

      ownerMap.delete(dappId)

      released                = true

      releasedDapps.push(dappId)

    }
  }

  if (released) {

    await saveOwnerMap(data.networkId, ownerMap)

    sendResponse(
      event,
      createResponse('RELEASE_OWNER', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.targetId,
          success:            true
      })
    )

  } else {

    sendResponse(
      event,
      createResponse('RELEASE_OWNER', {
        networkId:            data.networkId,
           toUuid:            data.fromUuid,
         targetId:            data.targetId,
          success:            false,
            error:            'No owned dapp found.'
      })
    )
  }

  const tabList               = await getTabList(data.networkId)

  log('current tab list', tabList)

  if (tabList) {

    const index               = tabList.indexOf(data.fromUuid)

    tabList.splice(index, 1)

    await saveTabList(data.networkId, tabList)

  }

  log('delete from event map')

  deleteFromTabEventMap(data.networkId, data.fromUuid)

  const otherTabs             = tabEventMap.get(data.networkId)

  log('other tabs are', otherTabs)

  if (otherTabs) {

    releasedDapps.forEach((dappId: string) => {

      log('Try to send message to register tab callbacks')

      otherTabs.forEach((event: IWorkerRequestEvent<'REGISTER_TAB'>, uuid: string) => {

        if (uuid === data.fromUuid) return

        log('sending to callback', data.networkId, data.fromUuid, dappId)

        sendResponse(
          event,
          createResponse('REGISTER_TAB', {
            networkId: data.networkId,
            toUuid:    uuid,
            targetId:  uuid,
            dappId:    dappId,
            success:   true,
          })
        )
      })
    })
  }
}

/**
 * Helper for serializing a map object.
 *
 * @param map
 */
const serializeMap            = (map: Map<string, string>): string => {

  const keyValueArray         = Array.from(map.entries());
  return JSON.stringify(keyValueArray);
}

/**
 * Helper for deserializing.
 * @param json
 */
const deserializeMap          = (json: string): Map<string, string> => {

  const keyValueArray: [string, string][] = JSON.parse(json);

  if (Array.isArray(keyValueArray)) {

    return new Map(keyValueArray);

  } else {

    // Return an empty Map if the input is not an array
    return new Map();

  }
}

/**
 * Creates a response object of a specific PeerConnectResponseTypes, helps with type hinting and object building.
 * @param type
 * @param data
 */
const  createResponse         = <T extends keyof PeerConnectResponseTypes>(type: T, data: PeerConnectResponseTypes[T]): PeerConnectWorkerResponse<T> => {

  // log('creating response', data, type)

  return {
    type,
    value: data,
  };
}

/**
 * Send a response object to a specific event source.
 *
 * @param event
 * @param response
 */
const sendResponse            = <T extends keyof PeerConnectResponseTypes>(event: IWorkerRequestEvent<any>, response: PeerConnectWorkerResponse<T>) => {
  // log('Send response:', event, response)

  // @ts-ignore
  event.source?.postMessage(response);
}

try {
  /**
   * Main logic for handling different messages types.
   */
  self.addEventListener('message', async (event: IWorkerRequestEvent<any>) => {

    const obj = event as IWorkerRequestEvent<keyof PeerConnectRequestTypes>;

    log('got message', event.data)

    if (isOfRequestType('OWNER_CHECK', obj)) {

      await handleOwnerCheckMessageRequest(obj.data.value, event)

    } else if (isOfRequestType('CLAIM_OWNER', obj)) {

      await handleClaimOwnerMessageRequest(obj.data.value, event)

    } else if (isOfRequestType('RELEASE_OWNER', obj)) {

      await handleReleaseOwnerMessageRequest(obj.data.value, event)

    } else if (isOfRequestType("REGISTER_TAB", obj)) {

      await handleRegisterTabMessageRequest(obj.data.value, event)

    }

  });

  log('added message event listener')

} catch (error: any) {

  log('Error in adding event listener', error)

}
