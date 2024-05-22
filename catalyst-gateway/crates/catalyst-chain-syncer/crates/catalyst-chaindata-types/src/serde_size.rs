use serde::Serialize;

struct ByteCounter(usize);

impl std::io::Write for ByteCounter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        self.0 += buf.len();
        Ok(buf.len())
    }

    fn flush(&mut self) -> std::io::Result<()> {
        Ok(())
    }
}

pub fn serde_size<T: Serialize>(data: &T) -> anyhow::Result<usize> {
    let mut byte_counter = ByteCounter(0);
    serde_json::to_writer(&mut byte_counter, data)?;

    Ok(byte_counter.0)
}
