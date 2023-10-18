//! Shared state used by all endpoints.
//!
use crate::cli::Error;
use event_db::queries::EventDbQueries;
use std::sync::Arc;

pub struct State {
    /// This can be None, or a handle to the DB.
    /// If the DB fails, it can be set to None.
    /// If its None, an attempt to get it will try and connect to the DB.
    /// This is Private, it needs to be accessed with a function.
    //event_db_handle: Arc<ArcSwap<Option<dyn EventDbQueries>>>, // Private need to get it with a function.
    pub event_db: Arc<dyn EventDbQueries>, // This needs to be obsoleted, we want the DB to be able to be down.
}

impl State {
    pub async fn new(database_url: Option<String>) -> Result<Self, Error> {
        // Get a connection to the Database.
        let event_db = match database_url.clone() {
            Some(url) => Arc::new(event_db::establish_connection(Some(url.as_str())).await?),
            None => Arc::new(event_db::establish_connection(None).await?),
        };

        let state = Self { event_db };

        // We don't care if this succeeds or not.
        // We just try our best to connect to the event DB.
        //let _ = state.event_db().await;

        Ok(state)
    }

    /*
    pub async fn event_db(&self) -> Option<Arc<dyn EventDbQueries>> {


    }
    */
}
