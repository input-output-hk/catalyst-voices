use std::{
    path::PathBuf,
    sync::{
        atomic::{AtomicU64, Ordering::Acquire},
        Arc,
    },
    time::Duration,
};

use cardano_immutabledb_reader::block_reader::{BlockReader, BlockReaderConfig};
use clap::Parser;
use pallas_traverse::MultiEraBlock;
use tokio::sync::mpsc;

fn parse_byte_size(s: &str) -> Result<u64, String> {
    parse_size::parse_size(s).map_err(|e| e.to_string())
}

#[derive(Parser)]
struct Cli {
    #[clap(short, long)]
    immutabledb_path: PathBuf,
    #[clap(long, default_value_t = 1)]
    read_worker_count: usize,
    #[clap(long, value_parser = parse_byte_size, default_value = "128MiB")]
    read_worker_buffer_size: u64,
    #[clap(long, value_parser = parse_byte_size, default_value = "16MiB")]
    unprocessed_data_buffer_size: u64,
    #[clap(long, default_value_t = 1)]
    processing_worker_count: usize,
}

#[tokio::main]
async fn main() {
    let cli_args = Cli::parse();

    let config = BlockReaderConfig {
        worker_read_buffer_byte_size: cli_args.read_worker_buffer_size as usize,
        read_worker_count: cli_args.read_worker_count,
        unprocessed_data_buffer_byte_size: cli_args.unprocessed_data_buffer_size as usize,
    };

    let mut block_reader = BlockReader::new(cli_args.immutabledb_path, &config, ..)
        .await
        .expect("Block reader started");

    let byte_count = Arc::new(AtomicU64::new(0));
    let block_number = Arc::new(AtomicU64::new(0));
    let mut processing_workers_txs = Vec::new();

    for _ in 0..cli_args.processing_worker_count {
        let (worker_tx, mut worker_rx) = mpsc::unbounded_channel::<(_, Vec<_>)>();

        tokio::spawn({
            let worker_byte_count = byte_count.clone();
            let worker_block_number = block_number.clone();

            async move {
                while let Some((_permit, block_data)) = worker_rx.recv().await {
                    let decoded_block_data = MultiEraBlock::decode(&block_data).expect("Decoded");

                    worker_byte_count.fetch_add(block_data.len() as u64, Acquire);
                    worker_block_number.fetch_max(decoded_block_data.number(), Acquire);
                }
            }
        });

        processing_workers_txs.push(worker_tx);
    }

    let mut ticker = tokio::time::interval(Duration::from_secs(1));
    let mut i = 0;

    loop {
        tokio::select! {
            res = block_reader.next() => {
                match res {
                    Some(v) => {
                        processing_workers_txs[i].send(v).expect("Worker");
                        i = (i + 1) % cli_args.processing_worker_count;
                    }
                    None => {
                        break;
                    }
                }
            }

            _ = ticker.tick() => {
                println!("BLOCK NUMBER {} | {} MB/s", block_number.load(Acquire), byte_count.swap(0, std::sync::atomic::Ordering::Acquire) / 1024 / 1024);
            }
        }
    }
}
