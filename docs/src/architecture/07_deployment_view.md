---
icon: material/server-network
---

# Deployment View

<!-- See: https://docs.arc42.org/section-7/ -->

## Infrastructure Level 1

High level deployment uses containerized services for the gateway and data stores with public HTTPS endpoints.

```mermaid
flowchart LR
  subgraph K8s Cluster
    GW[cat-gateway Deployment]
    MET[Metrics Exporter]
  end
  subgraph Data Layer
    PG[(PostgreSQL Event DB)]
    CAS[(Scylla Clusters)]
  end
  CDN[(CDN/Web Hosting)]
  BROWSER[Browsers and Mobile]
  CN[Cardano Network]

  BROWSER --> CDN
  BROWSER --> GW
  GW <--> PG
  GW <--> CAS
  GW <--> CN
  MET -.-> GW
```

Motivation:

Kubernetes enables rolling updates, horizontal scaling, and isolation of concerns across services.

Quality and performance features:

* Separate read heavy workloads to Scylla backed endpoints.
* Keep API stateless behind load balancers with sticky free scaling.
* Expose Prometheus metrics and health probes for automated rollouts.

Mapping of building blocks to infrastructure:

* Gateway binary runs as a container exposing HTTP API and metrics ports.
* PostgreSQL hosts event data with backups and PITR configured by SRE.
* Scylla clusters, which are Cassandra compatible, provide persistent and volatile keyspaces for chain caches.
* Flutter Web builds are served via CDN and app stores deliver mobile builds.

## Infrastructure Level 2

### Networking

* Public HTTPS for API with restrictive CORS and rate limits per route group.
* Private networking between gateway pods and data stores with TLS.
* Separate metrics endpoint scraped by Prometheus and dashboards in Grafana.
* Gateway peers with the Cardano network using the Node-to-Node (N2N) protocol and does not use HTTP or gRPC bridges.

### Build and Release

* Earthly pipelines produce Docker images and OpenAPI artifacts.
* Canary deployments test new versions before rolling fleet upgrades.

## Frontend Deployment

### Web Deployment

Flutter web builds are deployed to CDN with the following process:

1. **Build**: `flutter build web --wasm` (or `--no-wasm` for JS-only)
2. **Asset Versioning**: Content-based MD5 hashing for cache busting
3. **CDN Deployment**: Assets served via CDN with proper headers
4. **Headers**: COOP and COEP headers required for WASM support

**Web Build Requirements**:

* `Cross-Origin-Opener-Policy: same-origin`
* `Cross-Origin-Embedder-Policy: require-corp`
* `Content-Type: application/wasm` for WASM files
* Asset versioning for cache busting

**Build Artifacts**:

* HTML files with versioned asset references
* JavaScript bundles (potentially split into parts)
* WASM files (canvaskit, sqlite3, etc.)
* Asset manifest (`asset_versions.json`)

### Build Pipeline

**Frontend Build Steps**:

1. Dependency installation (`melos bootstrap`)
2. Code generation (`melos build-runner`)
3. SVG compilation (`melos compile_svg`)
4. Localization generation (`flutter gen-l10n`)
5. Flutter build (web)
6. Asset versioning (web only)
7. Artifact packaging
8. Deployment to target platform

**CI/CD Integration**:

* Automated builds on commits
* Automated testing (unit, widget, integration)
* Automated deployment to staging/production
* Version tagging and release notes
