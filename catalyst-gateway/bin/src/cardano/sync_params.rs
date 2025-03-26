//! Chain follower syncing parameters.

use std::{fmt::Display, sync::Arc, time::Duration};

use cardano_blockchain_types::{MultiEraBlock, Network, Point};
use duration_string::DurationString;
use rand::{Rng, SeedableRng};

/// The range we generate random backoffs within given a base backoff value.
const BACKOFF_RANGE_MULTIPLIER: u32 = 3;

/// Data we return from a sync task.
#[derive(Clone)]
pub(crate) struct SyncParams {
    /// What blockchain are we syncing.
    chain: Network,
    /// The starting point of this sync.
    start: Point,
    /// The ending point of this sync.
    end: Point,
    /// The first block we successfully synced.
    /// Includes also is immutable flag (True - is immutable, False - is volatile).
    first_indexed_block: Option<(Point, bool)>,
    /// The last block we successfully synced.
    /// Includes also is immutable flag (True - is immutable, False - is volatile).
    last_indexed_block: Option<(Point, bool)>,
    /// The number of blocks we successfully synced overall.
    total_blocks_synced: u64,
    /// The number of blocks we successfully synced, in the last attempt.
    last_blocks_synced: u64,
    /// The number of retries so far on this sync task.
    retries: u64,
    /// The number of retries so far on this sync task.
    backoff_delay: Option<Duration>,
    /// If the sync completed without error or not.
    error: Arc<Option<anyhow::Error>>,
    /// Chain follower roll forward.
    follower_roll_forward: Option<Point>,
}

impl Display for SyncParams {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if self.error.is_none() {
            write!(f, "Sync_Params {{ ")?;
        } else {
            write!(f, "Sync_Result {{ ")?;
        }

        write!(f, "start: {}, end: {}", self.start, self.end)?;

        if let Some((point, is_immutable)) = self.first_indexed_block.as_ref() {
            write!(
                f,
                ", first_indexed_block {{ point: {point}, is_immutable: {is_immutable} }}",
            )?;
        }

        if let Some((point, is_immutable)) = self.last_indexed_block.as_ref() {
            write!(
                f,
                ", last_indexed_block {{ point: {point}, is_immutable: {is_immutable} }}",
            )?;
        }

        if self.retries > 0 {
            write!(f, ", retries: {}", self.retries)?;
        }

        if self.retries > 0 || self.error.is_some() {
            write!(f, ", synced_blocks: {}", self.total_blocks_synced)?;
        }

        if self.error.is_some() {
            write!(f, ", last_sync: {}", self.last_blocks_synced)?;
        }

        if let Some(backoff) = self.backoff_delay.as_ref() {
            write!(f, ", backoff: {}", DurationString::from(*backoff))?;
        }

        match self.error.as_ref() {
            None => write!(f, ", Success")?,
            Some(error) => write!(f, ", {error}")?,
        }

        f.write_str(" }")
    }
}

impl SyncParams {
    /// Create a new `SyncParams` for the immutable chain sync task.
    pub(crate) fn new_immutable(chain: Network, start: Point, end: Point) -> Self {
        Self {
            chain,
            start,
            end,
            first_indexed_block: None,
            last_indexed_block: None,
            total_blocks_synced: 0,
            last_blocks_synced: 0,
            retries: 0,
            backoff_delay: None,
            error: Arc::new(None),
            follower_roll_forward: None,
        }
    }

    /// Create a new `SyncParams` for the live chain sync task.
    pub(crate) fn new_live(chain: Network, start: Point) -> Self {
        Self {
            chain,
            start,
            end: Point::TIP,
            first_indexed_block: None,
            last_indexed_block: None,
            total_blocks_synced: 0,
            last_blocks_synced: 0,
            retries: 0,
            backoff_delay: None,
            error: Arc::new(None),
            follower_roll_forward: None,
        }
    }

    /// Convert a result back into parameters for a retry.
    pub(crate) fn retry(&self) -> Self {
        let retry_count = self.retries.saturating_add(1);

        let mut backoff = None;

        // If we did sync any blocks last time, first retry is immediate.
        // Otherwise we backoff progressively more as we do more retries.
        if self.last_blocks_synced == 0 {
            // Calculate backoff based on number of retries so far.
            backoff = match retry_count {
                1 => Some(Duration::from_secs(1)),     // 1-3 seconds
                2..5 => Some(Duration::from_secs(10)), // 10-30 seconds
                _ => Some(Duration::from_secs(30)),    // 30-90 seconds.
            };
        }

        let mut retry = self.clone();
        retry.last_blocks_synced = 0;
        retry.retries = retry_count;
        retry.backoff_delay = backoff;
        retry.error = Arc::new(None);
        retry.follower_roll_forward = None;

        retry
    }

    /// Convert Params into the result of the sync.
    pub(crate) fn done(mut self, error: Option<anyhow::Error>) -> Self {
        self.total_blocks_synced = self
            .total_blocks_synced
            .saturating_add(self.last_blocks_synced);
        self.last_blocks_synced = 0;

        self.error = Arc::new(error);

        self
    }

    /// During indexing block updating corresponding sync parameters
    pub(crate) fn update_block_state(&mut self, block: &MultiEraBlock) {
        self.last_indexed_block = Some((block.point(), block.is_immutable()));
        if self.first_indexed_block.is_none() {
            self.first_indexed_block = Some((block.point(), block.is_immutable()));
        }
        self.last_blocks_synced = self.last_blocks_synced.saturating_add(1);
    }

    /// Returns a chain's network type
    pub(crate) fn chain(&self) -> &Network {
        &self.chain
    }

    /// Returns if the running sync task was defined as live chain sync task
    pub(crate) fn is_live(&self) -> bool {
        self.end == Point::TIP
    }

    /// Returns the last block we successfully synced.
    pub(crate) fn last_indexed_block(&self) -> Option<&Point> {
        self.last_indexed_block.as_ref().map(|(point, _)| point)
    }

    /// Returns if the sync completed without error or not.
    pub(crate) fn error(&self) -> Option<&anyhow::Error> {
        self.error.as_ref().as_ref()
    }

    /// Returns Chain follower roll forward point.
    pub(crate) fn follower_roll_forward(&self) -> Option<&Point> {
        self.follower_roll_forward.as_ref()
    }

    /// Set Chain follower roll forward point.
    pub(crate) fn set_follower_roll_forward(&mut self, point: Point) {
        self.follower_roll_forward = Some(point);
    }

    /// Get where this sync run actually needs to start from.
    pub(crate) fn actual_start(&self) -> Point {
        self.last_indexed_block
            .as_ref()
            .map_or(&self.start, |(point, _)| point)
            .clone()
    }

    /// Returns an start point of this sync
    pub(crate) fn start(&self) -> &Point {
        &self.start
    }

    /// Returns an ending point of this sync
    pub(crate) fn end(&self) -> &Point {
        &self.end
    }

    /// Do the backoff delay processing.
    ///
    /// The actual delay is a random time from the Delay itself to
    /// `BACKOFF_RANGE_MULTIPLIER` times the delay. This is to prevent hammering the
    /// service at regular intervals.
    pub(crate) async fn backoff(&self) {
        if let Some(backoff) = self.backoff_delay {
            let mut rng = rand::rngs::StdRng::from_entropy();
            let actual_backoff =
                rng.gen_range(backoff..backoff.saturating_mul(BACKOFF_RANGE_MULTIPLIER));

            tokio::time::sleep(actual_backoff).await;
        }
    }
}
