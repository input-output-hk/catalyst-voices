pub mod writers;

use std::{future::Future, mem, sync::Arc};

use anyhow::Result;
use catalyst_chaindata_types::{CardanoBlock, CardanoSpentTxo, CardanoTransaction, CardanoTxo};
use tokio::{
    sync::{mpsc, OwnedSemaphorePermit, Semaphore},
    task::{JoinError, JoinHandle},
};

pub struct WriteData {
    pub block: CardanoBlock,
    pub transactions: Vec<CardanoTransaction>,
    pub transaction_outputs: Vec<CardanoTxo>,
    pub spent_transaction_outputs: Vec<CardanoSpentTxo>,
}

impl WriteData {
    pub fn byte_size(&self) -> usize {
        mem::size_of_val(&self.block)
            + self
                .transactions
                .iter()
                .map(mem::size_of_val)
                .sum::<usize>()
            + self
                .transaction_outputs
                .iter()
                .map(|txo| mem::size_of_val(txo) + txo.assets_size_estimate)
                .sum::<usize>()
            + self
                .spent_transaction_outputs
                .iter()
                .map(mem::size_of_val)
                .sum::<usize>()
    }
}

pub trait Writer {
    fn batch_write(
        &mut self,
        data: Vec<WriteData>,
    ) -> impl Future<Output = anyhow::Result<()>> + Send;
}

#[derive(Clone)]
pub struct ChainDataWriterHandle {
    write_semaphore: Arc<Semaphore>,
    write_data_tx: mpsc::UnboundedSender<(OwnedSemaphorePermit, WriteData)>,
}

impl ChainDataWriterHandle {
    pub async fn write(&self, d: WriteData) -> Result<()> {
        let permit = self
            .clone()
            .write_semaphore
            .acquire_many_owned(d.byte_size() as u32)
            .await?;

        self.write_data_tx.send((permit, d))?;

        Ok(())
    }
}

pub struct ChainDataWriter {
    write_worker_task_handle: JoinHandle<()>,
}

impl ChainDataWriter {
    pub async fn new<W>(
        writer: W,
        write_buffer_byte_size: usize,
    ) -> Result<(Self, ChainDataWriterHandle)>
    where
        W: Writer + Send + 'static,
    {
        let (write_data_tx, write_data_rx) = mpsc::unbounded_channel();

        let write_worker_task_handle = tokio::spawn(write_task::run(
            writer,
            write_buffer_byte_size,
            write_data_rx,
        ));

        let this = Self {
            write_worker_task_handle,
        };

        let handle = ChainDataWriterHandle {
            // Explain
            write_semaphore: Arc::new(Semaphore::new(write_buffer_byte_size * 2)),
            write_data_tx,
        };

        Ok((this, handle))
    }
}

impl Future for ChainDataWriter {
    type Output = Result<(), JoinError>;

    fn poll(
        mut self: std::pin::Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Self::Output> {
        let mut write_worker_task_handle = std::pin::pin!(&mut self.write_worker_task_handle);
        write_worker_task_handle.as_mut().poll(cx)
    }
}

mod write_task {
    use std::time::Duration;

    use tokio::sync::{mpsc, OwnedSemaphorePermit};

    use crate::{WriteData, Writer};

    pub async fn run<W>(
        mut writer: W,
        write_buffer_byte_size: usize,
        mut write_data_rx: mpsc::UnboundedReceiver<(OwnedSemaphorePermit, WriteData)>,
    ) where
        W: Writer,
    {
        let mut merged_permits: Option<OwnedSemaphorePermit> = None;
        let mut writer_data_buffer = Vec::new();

        let mut total_byte_count = 0;

        let mut flush = false;
        let mut close = false;

        let mut ticker = tokio::time::interval(Duration::from_secs(30));

        let mut latest_block = 0;

        loop {
            tokio::select! {
                // If we did not receive data for a while, flush the buffers.
                _ = ticker.tick() => {
                    flush = true;
                }

                res = write_data_rx.recv() => {
                    // Reset the ticker since we received data.
                    ticker.reset();

                    match res {
                        None => {
                            flush = true;
                            close = true;
                        }
                        Some((permit, data)) => {
                            total_byte_count += data.byte_size();

                            match merged_permits.as_mut() {
                                Some(p) => p.merge(permit),
                                None => merged_permits = Some(permit),
                            }

                            latest_block = latest_block.max(data.block.block_no);
                            writer_data_buffer.push(data);
                        }
                    }
                }
            }

            if (flush && total_byte_count > 0) || total_byte_count >= write_buffer_byte_size {
                println!(
                    "WRITING {} | SIZE {:.2} MB",
                    latest_block,
                    (total_byte_count as f64) / (1024.0 * 1024.0),
                );

                writer
                    .batch_write(std::mem::take(&mut writer_data_buffer))
                    .await
                    .expect("Write");

                merged_permits = None;
                total_byte_count = 0;

                ticker.reset();

                flush = false;
            }

            if close {
                break;
            }
        }
    }
}
