use std::future::Future;

pub struct Connection {
    client: tokio_postgres::Client,
    conn_task_handle: tokio::task::JoinHandle<()>,
}

impl Connection {
    pub async fn open(conn_string: &str) -> anyhow::Result<Self> {
        let (client, conn) = tokio_postgres::connect(conn_string, tokio_postgres::NoTls).await?;

        let conn_task_handle = tokio::spawn(async move {
            conn.await.expect("Success");
        });

        Ok(Self {
            client,
            conn_task_handle,
        })
    }

    pub fn client(&self) -> &tokio_postgres::Client {
        &self.client
    }

    pub fn client_mut(&mut self) -> &mut tokio_postgres::Client {
        &mut self.client
    }

    pub fn close(self) -> impl Future<Output = Result<(), tokio::task::JoinError>> {
        self.conn_task_handle
    }
}
