use std::{
    collections::BTreeSet,
    ops::{Bound, RangeBounds},
    os::unix::fs::MetadataExt,
    path::Path,
    sync::Arc,
};

use tokio::sync::{mpsc, OwnedSemaphorePermit, Semaphore};
use tokio_util::sync::CancellationToken;

use crate::{dir_chunk_numbers, slot_chunk_number};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct BlockReaderConfig {
    pub worker_read_buffer_byte_size: usize,
    pub read_worker_count: usize,
    pub unprocessed_data_buffer_byte_size: usize,
}

impl Default for BlockReaderConfig {
    fn default() -> Self {
        Self {
            worker_read_buffer_byte_size: 8 * 1024 * 1024, // 8MB
            read_worker_count: 1,
            unprocessed_data_buffer_byte_size: 8 * 1024 * 1024, // 8MB
        }
    }
}

pub struct BlockReader {
    _cancellation_token: CancellationToken,
    read_data_rx: mpsc::UnboundedReceiver<(OwnedSemaphorePermit, Vec<u8>)>,
}

impl BlockReader {
    pub async fn new<P, R>(
        immutabledb_path: P,
        config: &BlockReaderConfig,
        slot_range: R,
    ) -> anyhow::Result<Self>
    where
        P: AsRef<Path>,
        R: RangeBounds<u64> + Clone + Send + 'static,
    {
        let task_chunk_numbers = {
            let min_slot_bound = match slot_range.start_bound().cloned() {
                Bound::Included(s) => s,
                Bound::Excluded(s) => s + 1,
                Bound::Unbounded => 0,
            };
            let max_slot_bound = match slot_range.end_bound().cloned() {
                Bound::Included(s) => Some(s),
                Bound::Excluded(s) => Some(s - 1),
                Bound::Unbounded => None,
            };

            let min_chunk_number = slot_chunk_number(min_slot_bound);
            let max_chunk_number = max_slot_bound.map(slot_chunk_number);

            let mut split_chunk_numbers = vec![(0u64, BTreeSet::new()); config.read_worker_count];

            let chunk_numbers = dir_chunk_numbers(immutabledb_path.as_ref()).await?;

            for chunk_number in chunk_numbers {
                if chunk_number < min_chunk_number
                    || max_chunk_number
                        .as_ref()
                        .copied()
                        .map(|s| chunk_number > s)
                        .unwrap_or(false)
                {
                    continue;
                }

                let f = tokio::fs::File::open(
                    immutabledb_path
                        .as_ref()
                        .join(format!("{chunk_number:05}.chunk")),
                )
                .await?;
                let f_metadata = f.metadata().await?;

                let min = split_chunk_numbers
                    .iter_mut()
                    .min_by_key(|(byte_count, _)| *byte_count)
                    .expect("At least one entry");

                min.0 += f_metadata.size() as u64;
                min.1.insert(chunk_number);
            }

            split_chunk_numbers
        };

        let cancellation_token = CancellationToken::new();
        let (read_data_tx, read_data_rx) = mpsc::unbounded_channel();
        let read_semaphore = Arc::new(Semaphore::new(config.unprocessed_data_buffer_byte_size));

        for (_, chunk_numbers) in task_chunk_numbers {
            // Allocate a read buffer for each reader task
            let read_buffer = vec![0u8; config.worker_read_buffer_byte_size];

            tokio::spawn(chunk_reader_task::start(
                immutabledb_path.as_ref().to_path_buf(),
                read_buffer,
                chunk_numbers,
                slot_range.clone(),
                read_semaphore.clone(),
                read_data_tx.clone(),
                cancellation_token.child_token(),
            ));
        }

        Ok(Self {
            _cancellation_token: cancellation_token,
            read_data_rx,
        })
    }

    pub async fn next(&mut self) -> Option<(OwnedSemaphorePermit, Vec<u8>)> {
        self.read_data_rx.recv().await
    }
}

mod chunk_reader_task {
    use std::{collections::BTreeSet, ops::RangeBounds, path::PathBuf, sync::Arc};

    use tokio::sync::{mpsc, OwnedSemaphorePermit, Semaphore};
    use tokio_util::sync::CancellationToken;

    use crate::read_chunk_file;

    pub async fn start<R>(
        immutabledb_path: PathBuf,
        mut read_buffer: Vec<u8>,
        mut chunk_numbers: BTreeSet<u32>,
        slot_range: R,
        read_semaphore: Arc<Semaphore>,
        read_data_tx: mpsc::UnboundedSender<(OwnedSemaphorePermit, Vec<u8>)>,
        cancellation_token: CancellationToken,
    ) where
        R: RangeBounds<u64>,
    {
        'main_loop: while let Some(chunk_number) = chunk_numbers.pop_first() {
            let chunk_number_str = format!("{chunk_number:05}");

            let chunk_file_path = immutabledb_path.join(format!("{chunk_number_str}.chunk"));
            let secondary_file_path =
                immutabledb_path.join(format!("{chunk_number_str}.secondary"));

            let mut chunk_iter =
                read_chunk_file(chunk_file_path, secondary_file_path, &mut read_buffer)
                    .await
                    .expect("read_chunk_file");

            loop {
                tokio::select! {
                    _ = cancellation_token.cancelled() => {
                        break;
                    }

                    res = chunk_iter.next() => {
                        match res {
                            Ok(Some((slot, block_data))) => {
                                // Filter out slots outside the required range
                                if !slot_range.contains(&slot) {
                                    continue;
                                }

                                let permit = read_semaphore
                                    .clone()
                                    .acquire_many_owned(block_data.len() as u32)
                                    .await
                                    .expect("Acquire");

                                if read_data_tx.send((permit, block_data.to_vec())).is_err() {
                                    break 'main_loop;
                                }
                            }
                            Ok(None) => {
                                break;
                            }
                            Err(e) => panic!("{}", e),
                        }
                    }
                }
            }
        }
    }
}

#[cfg(test)]
mod test {
    use std::collections::BTreeSet;

    use pallas_traverse::MultiEraBlock;

    use super::{BlockReader, BlockReaderConfig};

    #[tokio::test]
    async fn test_block_reader() {
        let config = BlockReaderConfig::default();

        let mut block_reader = BlockReader::new("tests_data", &config, ..)
            .await
            .expect("Block reader started");

        let mut block_numbers = BTreeSet::new();

        while let Some((_permit, block_data)) = block_reader.next().await {
            let decoded_block_data = MultiEraBlock::decode(&block_data).expect("Decoded");
            block_numbers.insert(decoded_block_data.number());
        }

        assert_eq!(block_numbers.len(), 9766);

        let mut last_block_number = block_numbers.pop_first().expect("At least one block");
        for block_number in block_numbers {
            assert!(block_number == last_block_number + 1);
            last_block_number = block_number;
        }
    }

    #[tokio::test]
    async fn test_block_reader_range() {
        let config = BlockReaderConfig::default();

        // Read from block 1000 to block 4999
        let mut block_reader = BlockReader::new("tests_data", &config, 105480..185480)
            .await
            .expect("Block reader started");

        let mut block_numbers = BTreeSet::new();

        while let Some((_permit, block_data)) = block_reader.next().await {
            let decoded_block_data = MultiEraBlock::decode(&block_data).expect("Decoded");
            block_numbers.insert(decoded_block_data.number());
        }

        assert_eq!(block_numbers.first(), Some(&1000));
        assert_eq!(block_numbers.last(), Some(&4999));

        let mut last_block_number = block_numbers.pop_first().expect("At least one block");
        for block_number in block_numbers {
            assert!(block_number == last_block_number + 1);
            last_block_number = block_number;
        }
    }
}
