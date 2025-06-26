//! Metrics related to RBAC Registration Chain Caching analytics.

use crate::{
    db::index::queries::rbac::{
        get_catalyst_id_from_public_key::public_keys_cache_size,
        get_catalyst_id_from_stake_address::stake_addresses_cache_size,
        get_catalyst_id_from_transaction_id::transaction_ids_cache_size,
    },
    rbac::persistent_rbac_chains_cache_size,
    settings::Settings,
};

/// Updates memory metrics to current values.
pub(crate) fn update() {
    let api_host_names = Settings::api_host_names().join(",");
    let service_id = Settings::service_id();

    reporter::PERSISTENT_PUBLIC_KEYS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(public_keys_cache_size(true)).unwrap_or(-1));
    reporter::VOLATILE_PUBLIC_KEYS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(public_keys_cache_size(false)).unwrap_or(-1));
    reporter::PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(stake_addresses_cache_size(true)).unwrap_or(-1));
    reporter::VOLATILE_STAKE_ADDRESSES_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(stake_addresses_cache_size(false)).unwrap_or(-1));
    reporter::PERSISTENT_TRANSACTION_IDS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(transaction_ids_cache_size(true)).unwrap_or(-1));
    reporter::VOLATILE_TRANSACTION_IDS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(transaction_ids_cache_size(false)).unwrap_or(-1));
    reporter::PERSISTENT_CHAINS_CACHE_SIZE
        .with_label_values(&[&api_host_names, service_id])
        .set(i64::try_from(persistent_rbac_chains_cache_size()).unwrap_or(-1));
}

/// All the related RBAC Registration Chain Caching reporting metrics to the Prometheus
/// service are inside this module.
pub(crate) mod reporter {
    use std::sync::LazyLock;

    use prometheus::{register_counter_vec, register_int_gauge_vec, CounterVec, IntGaugeVec};

    /// Labels for the metrics.
    const METRIC_LABELS: [&str; 3] = ["api_host_names", "service_id", "network"];

    /// A total count of the persistent public keys cache hits.
    pub(crate) static PERSISTENT_PUBLIC_KEYS_CACHE_HIT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_public_keys_cache_hit",
                "A total count of persistent public keys cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent public keys cache misses.
    pub(crate) static PERSISTENT_PUBLIC_KEYS_CACHE_MISS: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_public_keys_cache_miss",
                "A total count of persistent public keys cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// An estimated size of the persistent public keys cache.
    pub(crate) static PERSISTENT_PUBLIC_KEYS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_public_keys_cache_size",
                "An estimated size of the persistent public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile public keys cache hits.
    pub(crate) static VOLATILE_PUBLIC_KEYS_CACHE_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "rbac_volatile_public_keys_cache_hit",
            "A total count of volatile public keys cache hits",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// A total count of the volatile public keys cache misses.
    pub(crate) static VOLATILE_PUBLIC_KEYS_CACHE_MISS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "rbac_volatile_public_keys_cache_miss",
            "A total count of volatile public keys cache misses",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// An estimated size of the volatile public keys cache.
    pub(crate) static VOLATILE_PUBLIC_KEYS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_public_keys_cache_size",
                "An estimated size of the volatile public keys cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent stake addresses cache hits.
    pub(crate) static PERSISTENT_STAKE_ADDRESSES_CACHE_HIT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_stake_addresses_cache_hit",
                "A total count of the persistent stake addresses cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent stake addresses cache misses.
    pub(crate) static PERSISTENT_STAKE_ADDRESSES_CACHE_MISS: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_stake_addresses_cache_miss",
                "A total count of the persistent stake addresses cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// An estimated size of the persistent stake addresses cache.
    pub(crate) static PERSISTENT_STAKE_ADDRESSES_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_stake_addresses_cache_size",
                "An estimated size of the persistent stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile stake addresses cache hits.
    pub(crate) static VOLATILE_STAKE_ADDRESSES_CACHE_HIT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_volatile_stake_addresses_cache_hit",
                "A total count of the volatile stake addresses cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile stake addresses cache misses.
    pub(crate) static VOLATILE_STAKE_ADDRESSES_CACHE_MISS: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_volatile_stake_addresses_cache_miss",
                "A total count of the volatile stake addresses cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// An estimated size of the volatile stake addresses cache.
    pub(crate) static VOLATILE_STAKE_ADDRESSES_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_stake_addresses_cache_size",
                "An estimated size of the volatile stake addresses cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent transaction IDs cache hits.
    pub(crate) static PERSISTENT_TRANSACTION_IDS_CACHE_HIT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_transaction_ids_cache_hit",
                "A total count of the persistent transaction IDs cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent transaction IDs cache misses.
    pub(crate) static PERSISTENT_TRANSACTION_IDS_CACHE_MISS: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_persistent_transaction_ids_cache_miss",
                "A total count of the persistent transaction IDs cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// An estimated size of the persistent transaction IDs cache.
    pub(crate) static PERSISTENT_TRANSACTION_IDS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_persistent_transaction_ids_cache_size",
                "An estimated size of the persistent transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile transaction IDs cache hits.
    pub(crate) static VOLATILE_TRANSACTION_IDS_CACHE_HIT: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_volatile_transaction_ids_cache_hit",
                "A total count of volatile transaction IDs cache hits",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the volatile transaction IDs cache misses.
    pub(crate) static VOLATILE_TRANSACTION_IDS_CACHE_MISS: LazyLock<CounterVec> =
        LazyLock::new(|| {
            register_counter_vec!(
                "rbac_volatile_transaction_ids_cache_miss",
                "A total count of the volatile transaction IDs cache misses",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// An estimated size of the volatile transaction IDs cache.
    pub(crate) static VOLATILE_TRANSACTION_IDS_CACHE_SIZE: LazyLock<IntGaugeVec> =
        LazyLock::new(|| {
            register_int_gauge_vec!(
                "rbac_volatile_transaction_ids_cache_size",
                "An estimated size of the volatile transaction IDs cache",
                &METRIC_LABELS
            )
            .unwrap()
        });

    /// A total count of the persistent RBAC chains cache hits.
    pub(crate) static PERSISTENT_CHAINS_CACHE_HIT: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "rbac_persistent_chains_cache_hit",
            "A total count of the persistent RBAC chains cache hits",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// A total count of the persistent RBAC chains cache misses.
    pub(crate) static PERSISTENT_CHAINS_CACHE_MISS: LazyLock<CounterVec> = LazyLock::new(|| {
        register_counter_vec!(
            "rbac_persistent_chains_cache_miss",
            "A total count of the persistent RBAC chains cache misses",
            &METRIC_LABELS
        )
        .unwrap()
    });

    /// An estimated size of the persistent RBAC chains cache.
    pub(crate) static PERSISTENT_CHAINS_CACHE_SIZE: LazyLock<IntGaugeVec> = LazyLock::new(|| {
        register_int_gauge_vec!(
            "rbac_persistent_chains_cache_size",
            "An estimated size of the persistent RBAC chains cache",
            &METRIC_LABELS
        )
        .unwrap()
    });
}
