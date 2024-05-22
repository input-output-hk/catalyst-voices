use std::{
    error::Error,
    path::PathBuf,
    sync::{
        atomic::{AtomicU64, Ordering::Acquire},
        Arc,
    },
    time::{Duration, Instant},
};

use cardano_immutabledb_reader::block_reader::{BlockReader, BlockReaderConfig};
use catalyst_chaindata_types::{
    CardanoBlock, CardanoSpentTxo, CardanoTransaction, CardanoTxo, Network,
};
use catalyst_chaindata_writer::{
    writers::postgres::PostgresWriter, ChainDataWriter, ChainDataWriterHandle, WriteData,
};
use clap::Parser;
use pallas_traverse::MultiEraBlock;
use tokio::sync::{mpsc, OwnedSemaphorePermit};

fn parse_byte_size(s: &str) -> Result<u64, String> {
    parse_size::parse_size(s).map_err(|e| e.to_string())
}

#[derive(Parser)]
struct Cli {
    #[clap(long)]
    immutabledb_path: PathBuf,
    #[clap(long)]
    network: Network,

    #[clap(long)]
    database_url: String,

    #[clap(long, default_value_t = 1)]
    read_workers_count: usize,
    #[clap(long, value_parser = parse_byte_size, default_value = "128MiB")]
    read_worker_buffer_size: u64,
    #[clap(long, value_parser = parse_byte_size, default_value = "256MiB")]
    unprocessed_data_buffer_size: u64,
    #[clap(long, default_value_t = 1)]
    processing_workers_count: usize,
    #[clap(long, value_parser = parse_byte_size, default_value = "256MiB")]
    write_worker_buffer_size: u64,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let cli = Cli::parse();

    postgres_util::create_tables_if_not_present(&cli.database_url).await?;
    let pg_writer = PostgresWriter::open(&cli.database_url).await?;

    let (writer, writer_handle) =
        ChainDataWriter::new(pg_writer, cli.write_worker_buffer_size as usize).await?;

    // Stats
    let latest_block_number = Arc::new(AtomicU64::new(0));
    let latest_slot_number = Arc::new(AtomicU64::new(0));
    let read_byte_count = Arc::new(AtomicU64::new(0));
    let processed_byte_count = Arc::new(AtomicU64::new(0));

    let mut processing_workers_txs = Vec::new();

    for _ in 0..cli.processing_workers_count {
        let (block_data_tx, block_data_rx) = mpsc::unbounded_channel::<(_, Vec<_>)>();
        processing_workers_txs.push(block_data_tx);

        tokio::task::spawn(process_block_bytes(
            block_data_rx,
            cli.network,
            writer_handle.clone(),
            read_byte_count.clone(),
            processed_byte_count.clone(),
            latest_block_number.clone(),
            latest_slot_number.clone(),
        ));
    }

    // Drop extra writer handle since all workers have a reference to that now
    drop(writer_handle);

    let reader_config = BlockReaderConfig {
        worker_read_buffer_byte_size: cli.read_worker_buffer_size as usize,
        read_worker_count: cli.read_workers_count,
        unprocessed_data_buffer_byte_size: cli.unprocessed_data_buffer_size as usize,
    };

    let mut t = Instant::now();
    println!("Checking synced chain data...");

    let (missing_data_ranges, latest_slot) = {
        let conn = postgres_util::connection::Connection::open(&cli.database_url).await?;

        let rows = conn
            .client()
            .query(
                include_str!("../../../crates/postgres-util/sql/find_missing_data.sql"),
                &[],
            )
            .await?;

        let mut missing_data_ranges = Vec::new();
        for row in rows {
            let start_slot_no = row.get::<_, i64>(0) as u64;
            let end_slot_no = row.get::<_, i64>(1) as u64;

            missing_data_ranges.push((start_slot_no + 1)..end_slot_no);
        }

        let row = conn
            .client()
            .query_opt(
                include_str!("../../../crates/postgres-util/sql/latest_slot.sql"),
                &[],
            )
            .await?;

        let latest_slot = match row {
            Some(row) => row.get::<_, i64>(0) as u64,
            None => 0,
        };

        conn.close().await?;

        (missing_data_ranges, latest_slot)
    };

    if !missing_data_ranges.is_empty() {
        println!("Found missing data ranges. Recovering.");

        for r in missing_data_ranges {
            println!("Recovering range {r:?}");
            let mut reader =
                BlockReader::new(cli.immutabledb_path.clone(), &reader_config, r).await?;

            let mut i = 0;
            while let Some(v) = reader.next().await {
                processing_workers_txs[i].send(v).expect("Worker");
                i = (i + 1) % cli.processing_workers_count;
            }
        }
    }

    println!("Done (took {:?})", t.elapsed());

    t = Instant::now();
    let mut reader =
        BlockReader::new(cli.immutabledb_path, &reader_config, (latest_slot + 1)..).await?;

    let mut ticker = tokio::time::interval(Duration::from_secs(1));
    let mut i = 0;
    let mut create_indexes = true;

    loop {
        tokio::select! {
            _ = tokio::signal::ctrl_c() => {
                println!("Stopping block readers and processing workers...");

                // TODO: Do this in a better way
                drop(reader);
                drop(processing_workers_txs);

                create_indexes = false;

                break;
            }

            res = reader.next() => {
                match res {
                    Some(v) => {
                        processing_workers_txs[i].send(v).expect("Worker");
                        i = (i + 1) % cli.processing_workers_count;
                    }
                    None => {
                        // TODO: Do this in a better way
                        drop(reader);
                        drop(processing_workers_txs);

                        break;
                    }
                }
            }

            _ = ticker.tick() => {
                let mem_usage = memory_stats::memory_stats().map(|s| s.physical_mem).unwrap_or(0);

                println!(
                    "BLOCK {} | SLOT {} | READ {} MB/s | PROCESSED {} MB/s | MEMORY USAGE {} MB",
                    latest_block_number.load(Acquire),
                    latest_slot_number.load(Acquire),
                    read_byte_count.swap(0, Acquire) / (1024 * 1024),
                    processed_byte_count.swap(0, Acquire) / (1024 * 1024),
                    mem_usage / (1024 * 1024),
                );
            }
        }
    }

    // Wait for the chain data writer to flush all data to postgres
    println!("Waiting writer...");
    writer.await?;
    println!("Finished syncing immutabledb data ({:?})", t.elapsed());

    if create_indexes {
        println!("Creating indexes...");
        t = Instant::now();
        tokio::select! {
            _ = tokio::signal::ctrl_c() => {
                println!("Exiting");
            }

            res = postgres_util::create_indexes(&cli.database_url) => {
                res?;
                println!("Done (took {:?})", t.elapsed());
            }
        }
    }

    Ok(())
}

async fn process_block_bytes(
    mut block_data_rx: mpsc::UnboundedReceiver<(OwnedSemaphorePermit, Vec<u8>)>,
    network: Network,
    writer_handle: ChainDataWriterHandle,
    read_byte_count: Arc<AtomicU64>,
    processed_byte_count: Arc<AtomicU64>,
    latest_block_number: Arc<AtomicU64>,
    latest_slot_number: Arc<AtomicU64>,
) {
    while let Some((_permit, block_bytes)) = block_data_rx.recv().await {
        read_byte_count.fetch_add(block_bytes.len() as u64, Acquire);

        let block = MultiEraBlock::decode(&block_bytes).expect("Decode");

        let Ok(block_data) = CardanoBlock::from_block(&block, network) else {
            eprintln!("Failed to parse block");
            continue;
        };

        let Ok(transaction_data) = CardanoTransaction::many_from_block(&block, network) else {
            eprintln!("Failed to parse transactions");
            continue;
        };

        let txs = block.txs();

        let Ok(transaction_outputs_data) = CardanoTxo::from_transactions(&txs) else {
            eprintln!("Failed to parse TXOs");
            continue;
        };

        let Ok(spent_transaction_outputs_data) = CardanoSpentTxo::from_transactions(&txs) else {
            eprintln!("Failed to parse spent TXOs");
            continue;
        };

        let write_data = WriteData {
            block: block_data,
            transactions: transaction_data,
            transaction_outputs: transaction_outputs_data,
            spent_transaction_outputs: spent_transaction_outputs_data,
        };

        // Update stats
        processed_byte_count.fetch_add(write_data.byte_size() as u64, Acquire);
        latest_block_number.fetch_max(block.number(), Acquire);
        latest_slot_number.fetch_max(block.slot(), Acquire);
        drop(block_bytes);

        writer_handle.write(write_data).await.expect("Write");
    }
}
