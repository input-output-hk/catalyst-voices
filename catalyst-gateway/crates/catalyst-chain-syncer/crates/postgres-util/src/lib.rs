use anyhow::Result;
use connection::Connection;

pub use tokio_postgres;

pub mod connection;

pub async fn create_tables_if_not_present(conn_string: &str) -> Result<()> {
    let conn = Connection::open(conn_string).await?;

    conn.client()
        .batch_execute(include_str!("../sql/create_tables.sql"))
        .await?;
    conn.close().await?;

    Ok(())
}

pub async fn create_indexes(conn_string: &str) -> Result<()> {
    let conn = Connection::open(conn_string).await?;

    conn.client()
        .batch_execute(include_str!("../sql/create_indexes.sql"))
        .await?;
    conn.close().await?;

    Ok(())
}
