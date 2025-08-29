//! Metrics related to RBAC Registration Chain Caching analytics.

use super::cache_metric_inc;
use crate::{db::index::session::CassandraSession, settings::Settings};

/// Represents a persistent session.
const PERSISTENT: bool = true;
/// Represents a volatile session.
const VOLATILE: bool = false;

/// Updates memory metrics to current values.
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();
    let network = Settings::cardano_network().to_string();

    CassandraSession::get(PERSISTENT).inspect(|session| {
        let caches = session.caches();

        reporter::PERSISTENT_PUBLIC_KEYS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_public_key().weighted_size()).unwrap_or(-1));

        reporter::PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_stake_address().weighted_size()).unwrap_or(-1));

        reporter::PERSISTENT_TRANSACTION_IDS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_transaction_id().weighted_size()).unwrap_or(-1));

        reporter::PERSISTENT_CHAINS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_persistent_chains().weighted_size()).unwrap_or(-1));

        reporter::PERSISTENT_PUBLIC_KEYS_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_public_key().entry_count()).unwrap_or(-1));

        reporter::PERSISTENT_STAKE_ADDRESSES_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_stake_address().entry_count()).unwrap_or(-1));

        reporter::PERSISTENT_TRANSACTION_IDS_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_transaction_id().entry_count()).unwrap_or(-1));

        reporter::PERSISTENT_CHAINS_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_persistent_chains().entry_count()).unwrap_or(-1));
    });

    CassandraSession::get(VOLATILE).inspect(|session| {
        let caches = session.caches();

        reporter::VOLATILE_PUBLIC_KEYS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_public_key().weighted_size()).unwrap_or(-1));

        reporter::VOLATILE_STAKE_ADDRESSES_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_stake_address().weighted_size()).unwrap_or(-1));

        reporter::VOLATILE_TRANSACTION_IDS_CACHE_SIZE
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_transaction_id().weighted_size()).unwrap_or(-1));

        reporter::VOLATILE_PUBLIC_KEYS_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_public_key().entry_count()).unwrap_or(-1));

        reporter::VOLATILE_STAKE_ADDRESSES_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_stake_address().entry_count()).unwrap_or(-1));

        reporter::VOLATILE_TRANSACTION_IDS_CACHE_ENTRY_COUNT
            .with_label_values(&[&api_host_names, service_id, &network])
            .set(i64::try_from(caches.rbac_transaction_id().entry_count()).unwrap_or(-1));
    });
}

/// Increments the `VOLATILE_STAKE_ADDRESSES_CACHE_HIT` metric.
pub(crate) fn rbac_volatile_stake_address_cache_hits_inc() {
    cache_metric_inc!(VOLATILE_STAKE_ADDRESSES_CACHE_HIT);
}

/// Increments the `VOLATILE_STAKE_ADDRESSES_CACHE_HIT` metric.
pub(crate) fn rbac_volatile_stake_address_cache_miss_inc() {
    cache_metric_inc!(VOLATILE_STAKE_ADDRESSES_CACHE_MISS);
}

/// Increments the `PERSISTENT_STAKE_ADDRESSES_CACHE_HIT` metric.
pub(crate) fn rbac_persistent_stake_address_cache_hits_inc() {
    cache_metric_inc!(PERSISTENT_STAKE_ADDRESSES_CACHE_HIT);
}

/// Increments the `PERSISTENT_STAKE_ADDRESSES_CACHE_HIT` metric.
pub(crate) fn rbac_persistent_stake_address_cache_miss_inc() {
    cache_metric_inc!(PERSISTENT_STAKE_ADDRESSES_CACHE_MISS);
}

/// Increments the `PERSISTENT_PUBLIC_KEYS_CACHE_HIT` metric.
pub(crate) fn rbac_persistent_public_key_cache_hits_inc() {
    cache_metric_inc!(PERSISTENT_PUBLIC_KEYS_CACHE_HIT);
}

/// Increments the `PERSISTENT_PUBLIC_KEY_CACHE_MISS` metric.
pub(crate) fn rbac_persistent_public_key_cache_miss_inc() {
    cache_metric_inc!(PERSISTENT_PUBLIC_KEYS_CACHE_MISS);
}

/// Increments the `VOLATILE_PUBLIC_KEYS_CACHE_HIT` metric.
pub(crate) fn rbac_volatile_public_key_cache_hits_inc() {
    cache_metric_inc!(VOLATILE_PUBLIC_KEYS_CACHE_HIT);
}

/// Increments the `VOLATILE_PUBLIC_KEY_CACHE_MISS` metric.
pub(crate) fn rbac_volatile_public_key_cache_miss_inc() {
    cache_metric_inc!(VOLATILE_PUBLIC_KEYS_CACHE_MISS);
}

/// Increments the `PERSISTENT_TRANSACTION_IDS_CACHE_HIT` metric.
pub(crate) fn rbac_persistent_transaction_id_cache_hits_inc() {
    cache_metric_inc!(PERSISTENT_TRANSACTION_IDS_CACHE_HIT);
}

/// Increments the `PERSISTENT_TRANSACTION_IDS_CACHE_MISS` metric.
pub(crate) fn rbac_persistent_transaction_id_cache_miss_inc() {
    cache_metric_inc!(PERSISTENT_TRANSACTION_IDS_CACHE_MISS);
}

/// Increments the `VOLATILE_TRANSACTION_IDS_CACHE_HIT` metric.
pub(crate) fn rbac_volatile_transaction_id_cache_hits_inc() {
    cache_metric_inc!(VOLATILE_TRANSACTION_IDS_CACHE_HIT);
}

/// Increments the `VOLATILE_TRANSACTION_IDS_CACHE_MISS` metric.
pub(crate) fn rbac_volatile_transaction_id_cache_miss_inc() {
    cache_metric_inc!(VOLATILE_TRANSACTION_IDS_CACHE_MISS);
}

/// Increments the `PERSISTENT_CHAINS_CACHE_HIT` metric.
pub(crate) fn rbac_persistent_chains_cache_hits_inc() {
    cache_metric_inc!(PERSISTENT_CHAINS_CACHE_HIT);
}

/// Increments the `PERSISTENT_CHAINS_CACHE_MISS` metric.
pub(crate) fn rbac_persistent_chains_cache_miss_inc() {
    cache_metric_inc!(PERSISTENT_CHAINS_CACHE_MISS);
}

/// Increments the `INDEXING_SYNCHRONIZATION_COUNT` metric.
pub(crate) fn inc_index_sync() {
    cache_metric_inc!(INDEXING_SYNCHRONIZATION_COUNT);
}

/// Increments the `INVALID_RBAC_REGISTRATION_COUNT` metric.
pub(crate) fn inc_invalid_rbac_reg_count() {
    cache_metric_inc!(INVALID_RBAC_REGISTRATION_COUNT);
}

/// All the related RBAC Registration Chain Caching reporting metrics to the Prometheus
/// service are inside this module.
pub(crate) mod reporter {
    #![allow(clippy::unwrap_used)]

    use std::sync::LazyLock;

    use prometheus::{
        register_int_counter_vec, register_int_gauge_vec, IntCounterVec, IntGaugeVec,
    };

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// A total count of the persistent public keys cache hits.
    pub(super) static PERSISTENT_PUBLIC_KEYS_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_public_keys_cache_hit",
                "A total count of persistent public keys cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent public keys cache misses.
    pub(super) static PERSISTENT_PUBLIC_KEYS_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_public_keys_cache_miss",
                "A total count of persistent public keys cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the persistent public keys cache.
    pub(super) static PERSISTENT_PUBLIC_KEYS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_public_keys_cache_size",
                "Size in memory allocated bytes of the persistent public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the persistent public keys cache.
    pub(super) static PERSISTENT_PUBLIC_KEYS_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_public_keys_cache_entry_count",
                "Number of entries in the persistent public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile public keys cache hits.
    pub(super) static VOLATILE_PUBLIC_KEYS_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_public_keys_cache_hit",
                "A total count of volatile public keys cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile public keys cache misses.
    pub(super) static VOLATILE_PUBLIC_KEYS_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_public_keys_cache_miss",
                "A total count of volatile public keys cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the volatile public keys cache.
    pub(super) static VOLATILE_PUBLIC_KEYS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_public_keys_cache_size",
                "Size in memory allocated bytes of the volatile public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the volatile public keys cache.
    pub(super) static VOLATILE_PUBLIC_KEYS_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_public_keys_cache_entry_count",
                "Number of entries in the volatile public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent stake addresses cache hits.
    pub(super) static PERSISTENT_STAKE_ADDRESSES_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_stake_addresses_cache_hit",
                "A total count of the persistent stake addresses cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent stake addresses cache misses.
    pub(super) static PERSISTENT_STAKE_ADDRESSES_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_stake_addresses_cache_miss",
                "A total count of the persistent stake addresses cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the persistent stake addresses cache.
    pub(super) static PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_stake_addresses_cache_size",
                "Size in memory allocated bytes of the persistent stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the persistent stake addresses cache.
    pub(super) static PERSISTENT_STAKE_ADDRESSES_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_stake_addresses_cache_entry_count",
                "Number of entries in the persistent stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile stake addresses cache hits.
    pub(super) static VOLATILE_STAKE_ADDRESSES_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_stake_addresses_cache_hit",
                "A total count of the volatile stake addresses cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile stake addresses cache misses.
    pub(super) static VOLATILE_STAKE_ADDRESSES_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_stake_addresses_cache_miss",
                "A total count of the volatile stake addresses cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the volatile stake addresses cache.
    pub(super) static VOLATILE_STAKE_ADDRESSES_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_stake_addresses_cache_size",
                "Size in memory allocated bytes of the volatile stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the volatile stake addresses cache.
    pub(super) static VOLATILE_STAKE_ADDRESSES_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_stake_addresses_cache_entry_count",
                "Number of entries in the volatile stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent transaction IDs cache hits.
    pub(super) static PERSISTENT_TRANSACTION_IDS_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_transaction_ids_cache_hit",
                "A total count of the persistent transaction IDs cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent transaction IDs cache misses.
    pub(super) static PERSISTENT_TRANSACTION_IDS_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_persistent_transaction_ids_cache_miss",
                "A total count of the persistent transaction IDs cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the persistent transaction IDs cache.
    pub(super) static PERSISTENT_TRANSACTION_IDS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_transaction_ids_cache_size",
                "Size in memory allocated bytes of the persistent transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the persistent transaction IDs cache.
    pub(super) static PERSISTENT_TRANSACTION_IDS_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_transaction_ids_cache_entry_count",
                "Number of entries in the persistent transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile transaction IDs cache hits.
    pub(super) static VOLATILE_TRANSACTION_IDS_CACHE_HIT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_transaction_ids_cache_hit",
                "A total count of volatile transaction IDs cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile transaction IDs cache misses.
    pub(super) static VOLATILE_TRANSACTION_IDS_CACHE_MISS: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "rbac_volatile_transaction_ids_cache_miss",
                "A total count of the volatile transaction IDs cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Size in memory allocated bytes of the volatile transaction IDs cache.
    pub(super) static VOLATILE_TRANSACTION_IDS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_transaction_ids_cache_size",
                "Size in memory allocated bytes of the volatile transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// Number of entries in the volatile transaction IDs cache.
    pub(super) static VOLATILE_TRANSACTION_IDS_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_transaction_ids_cache_entry_count",
                "Number of entries in the volatile transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent RBAC chains cache hits.
    pub(super) static PERSISTENT_CHAINS_CACHE_HIT: LazyLock<IntCounterVec> = LazyLock::new(|| {
        register_int_counter_vec!(
            "rbac_persistent_chains_cache_hit",
            "A total count of the persistent RBAC chains cache hits",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// A total count of the persistent RBAC chains cache misses.
    pub(crate) static PERSISTENT_CHAINS_CACHE_MISS: LazyLock<IntCounterVec> = LazyLock::new(|| {
        register_int_counter_vec!(
            "rbac_persistent_chains_cache_miss",
            "A total count of the persistent RBAC chains cache misses",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Size in memory allocated bytes of the persistent RBAC chains cache.
    pub(super) static PERSISTENT_CHAINS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "rbac_persistent_chains_cache_size",
            "Size in memory allocated bytes of the persistent RBAC chains cache",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// Number of entries in the persistent RBAC chains cache.
    pub(super) static PERSISTENT_CHAINS_CACHE_ENTRY_COUNT: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_transaction_ids_cache_entry_count",
                "Number of entries in the persistent RBAC chains cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// This counter increases every time we need to synchronize RBAC indexing by waiting
    /// for other tasks to finish before processing a new registration.
    pub(super) static INDEXING_SYNCHRONIZATION_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "indexing_synchronization_count",
                "Number of RBAC indexing synchronizations",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// This counter increases every when we found invalid RBAC registration during
    /// indexing.
    pub(super) static INVALID_RBAC_REGISTRATION_COUNT: LazyLock<IntCounterVec> =
        LazyLock::new(|| {
            register_int_counter_vec!(
                "invalid_rbac_registration_count",
                "Number of Invalid RBAC registrations found during indexing",
                &METRIC_LABELS
            )
            .unwrap()
        });
}
