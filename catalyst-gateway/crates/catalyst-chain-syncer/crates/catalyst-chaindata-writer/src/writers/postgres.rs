use catalyst_chaindata_types::{CardanoBlock, CardanoSpentTxo, CardanoTransaction, CardanoTxo};
use postgres_util::{
    connection::Connection,
    tokio_postgres::{self, binary_copy::BinaryCopyInWriter, types::Type},
};

pub struct PostgresWriter {
    conn: Connection,
}

impl PostgresWriter {
    pub async fn open(conn_string: &str) -> anyhow::Result<Self> {
        let conn = Connection::open(conn_string).await?;

        Ok(Self { conn })
    }
}

impl crate::Writer for PostgresWriter {
    async fn batch_write(&mut self, data: Vec<crate::WriteData>) -> anyhow::Result<()> {
        let mut blocks = Vec::new();
        let mut transactions = Vec::new();
        let mut txos = Vec::new();
        let mut spent_txos = Vec::new();

        for d in data {
            blocks.push(d.block);
            transactions.extend(d.transactions);
            txos.extend(d.transaction_outputs);
            spent_txos.extend(d.spent_transaction_outputs);
        }

        let tx = self.conn.client_mut().transaction().await?;

        tokio::try_join!(
            copy_blocks(&tx, &blocks),
            copy_transactions(&tx, &transactions),
            copy_txos(&tx, &txos),
            copy_spent_txos(&tx, &spent_txos)
        )?;

        tx.commit().await?;

        Ok(())
    }
}

async fn copy_blocks(
    tx: &tokio_postgres::Transaction<'_>,
    data: &[CardanoBlock],
) -> anyhow::Result<()> {
    let sink = tx.copy_in("COPY cardano_blocks (block_no, slot_no, epoch_no, network_id, block_time, block_hash, previous_hash) FROM STDIN BINARY").await?;

    let writer = BinaryCopyInWriter::new(
        sink,
        &[
            Type::INT8,
            Type::INT8,
            Type::INT8,
            Type::INT2,
            Type::TIMESTAMPTZ,
            Type::BYTEA,
            Type::BYTEA,
        ],
    );
    tokio::pin!(writer);

    for cb in data {
        writer
            .as_mut()
            .write(&[
                &(cb.block_no as i64),
                &(cb.slot_no as i64),
                &(cb.epoch_no as i64),
                &(cb.network.id() as i16),
                &cb.block_time,
                &cb.block_hash.as_slice(),
                &cb.previous_hash.as_ref().map(|h| h.as_slice()),
            ])
            .await?;
    }

    writer.finish().await?;

    Ok(())
}

async fn copy_transactions(
    tx: &tokio_postgres::Transaction<'_>,
    data: &[CardanoTransaction],
) -> anyhow::Result<()> {
    let sink = tx
        .copy_in("COPY cardano_transactions (block_no, network_id, hash) FROM STDIN BINARY")
        .await?;

    let writer = BinaryCopyInWriter::new(sink, &[Type::INT8, Type::INT2, Type::BYTEA]);
    tokio::pin!(writer);

    for tx_data in data {
        writer
            .as_mut()
            .write(&[
                &(tx_data.block_no as i64),
                &(tx_data.network.id() as i16),
                &tx_data.hash.as_slice(),
            ])
            .await
            .expect("WRITE");
    }

    writer.finish().await.expect("FINISH");

    Ok(())
}

async fn copy_txos(
    tx: &tokio_postgres::Transaction<'_>,
    data: &[CardanoTxo],
) -> anyhow::Result<()> {
    let sink = tx
            .copy_in("COPY cardano_txo (transaction_hash, index, value, assets, stake_credential) FROM STDIN BINARY")
            .await
            .expect("COPY");

    let writer = BinaryCopyInWriter::new(
        sink,
        &[
            Type::BYTEA,
            Type::INT4,
            Type::INT8,
            Type::JSONB,
            Type::BYTEA,
        ],
    );
    tokio::pin!(writer);

    for txo_data in data {
        writer
            .as_mut()
            .write(&[
                &txo_data.transaction_hash.as_slice(),
                &(txo_data.index as i32),
                &(txo_data.value as i64),
                &txo_data.assets,
                &txo_data.stake_credential.as_ref().map(|a| a.as_slice()),
            ])
            .await
            .expect("WRITE");
    }

    writer.finish().await.expect("FINISH");

    Ok(())
}

async fn copy_spent_txos(
    tx: &tokio_postgres::Transaction<'_>,
    data: &[CardanoSpentTxo],
) -> anyhow::Result<()> {
    let sink = tx.
                    copy_in("COPY cardano_spent_txo (from_transaction_hash, index, to_transaction_hash) FROM STDIN BINARY")
                    .await
                    .expect("COPY");
    let writer = BinaryCopyInWriter::new(sink, &[Type::BYTEA, Type::INT4, Type::BYTEA]);
    tokio::pin!(writer);

    for spent_txo_data in data {
        writer
            .as_mut()
            .write(&[
                &spent_txo_data.from_transaction_hash.as_slice(),
                &(spent_txo_data.index as i32),
                &spent_txo_data.to_transaction_hash.as_slice(),
            ])
            .await
            .expect("WRITE");
    }

    writer.finish().await.expect("FINISH");

    Ok(())
}
