pub mod block_reader;

use std::{borrow::Cow, collections::BTreeSet, ffi::OsStr, path::Path};

use binary_layout::binary_layout;
use tokio::io::AsyncReadExt;

pub async fn dir_chunk_numbers<P: AsRef<Path>>(path: P) -> anyhow::Result<BTreeSet<u32>> {
    let mut dir = tokio::fs::read_dir(path).await?;
    let mut chunk_numbers = BTreeSet::new();

    while let Some(e) = dir.next_entry().await? {
        let entry_path = e.path();

        if let Some("chunk") = entry_path.extension().and_then(OsStr::to_str) {
            let Some(stem) = entry_path.file_stem().and_then(OsStr::to_str) else {
                continue;
            };

            chunk_numbers.insert(stem.parse()?);
        }
    }

    Ok(chunk_numbers)
}

const CHUNK_SIZE: u32 = 21_600;

pub fn slot_chunk_number(slot_no: u64) -> u32 {
    (slot_no / (CHUNK_SIZE as u64)) as u32
}

binary_layout!(secondary_index_entry_layout, BigEndian, {
    block_offset: u64,
    header_offset: u16,
    header_size: u16,
    checksum: [u8; 4],
    header_hash: [u8; 32],
    block_or_ebb: u64,
});

const SECONDARY_INDEX_ENTRY_SIZE: usize = match secondary_index_entry_layout::SIZE {
    Some(size) => size,
    None => panic!("Expected secondary entry layout to have constant size"),
};

pub struct SecondaryIndexEntry {
    block_offset: u64,
}

pub struct SecondaryIndex {
    entries: Vec<SecondaryIndexEntry>,
}

impl SecondaryIndex {
    pub async fn from_file<P: AsRef<Path>>(path: P) -> anyhow::Result<Self> {
        let mut secondary_index_file = tokio::fs::File::open(path).await?;

        let mut entries = Vec::new();
        let mut entry_buf = [0u8; SECONDARY_INDEX_ENTRY_SIZE];

        loop {
            // Maybe this should use the sync version of sync_exact?
            if let Err(err) = secondary_index_file.read_exact(&mut entry_buf).await {
                if err.kind() == std::io::ErrorKind::UnexpectedEof {
                    break;
                }

                return Err(err.into());
            }

            let view = secondary_index_entry_layout::View::new(&entry_buf);

            entries.push(SecondaryIndexEntry {
                block_offset: view.block_offset().read(),
            });
        }

        Ok(SecondaryIndex { entries })
    }
}

pub struct ReadChunkFile<'a> {
    secondary_index: SecondaryIndex,
    chunk_file_data: &'a mut Vec<u8>,
    counter: usize,
}

impl<'a> ReadChunkFile<'a> {
    async fn next(&mut self) -> anyhow::Result<Option<(u64, &[u8])>> {
        let next_counter = self.counter + 1;

        let (from, to) = match next_counter.cmp(&self.secondary_index.entries.len()) {
            std::cmp::Ordering::Less => {
                let from = self.secondary_index.entries[self.counter].block_offset as usize;
                let to = self.secondary_index.entries[next_counter].block_offset as usize;

                (from, to)
            }
            std::cmp::Ordering::Equal => {
                let from = self.secondary_index.entries[self.counter].block_offset as usize;
                let to = self.chunk_file_data.len();

                (from, to)
            }
            std::cmp::Ordering::Greater => {
                return Ok(None);
            }
        };

        match self.chunk_file_data.get(from..to) {
            Some(block_bytes) => {
                self.counter = next_counter;
                let h: TestDecode = pallas_codec::minicbor::decode(block_bytes)?;

                Ok(Some((h.0.slot(), block_bytes)))
            }
            None => Ok(None),
        }
    }
}

#[derive(Debug)]
struct TestDecode<'b>(pallas_traverse::MultiEraHeader<'b>);

impl<'b, C> pallas_codec::minicbor::Decode<'b, C> for TestDecode<'b> {
    fn decode(
        d: &mut pallas_codec::minicbor::Decoder<'b>,
        _ctx: &mut C,
    ) -> Result<Self, pallas_codec::minicbor::decode::Error> {
        d.array()?;

        let era = d.u16()?;

        let _m = d.array()?;

        let header = match era {
            0 => {
                let header = d.decode()?;
                pallas_traverse::MultiEraHeader::EpochBoundary(Cow::Owned(header))
            }
            1 => {
                let header = d.decode()?;
                pallas_traverse::MultiEraHeader::Byron(Cow::Owned(header))
            }
            2 => {
                let header = d.decode()?;
                pallas_traverse::MultiEraHeader::AlonzoCompatible(Cow::Owned(header))
            }
            6 => {
                let header = d.decode()?;
                pallas_traverse::MultiEraHeader::Babbage(Cow::Owned(header))
            }
            3 | 4 | 5 | 7 => {
                let header = d.decode()?;
                pallas_traverse::MultiEraHeader::AlonzoCompatible(Cow::Owned(header))
            }
            _ => {
                return Err(pallas_codec::minicbor::decode::Error::message(
                    "Invalid CBOR",
                ))
            }
        };

        Ok(TestDecode(header))
    }
}

use pallas_codec::minicbor::decode::{Token, Tokenizer};

use pallas_traverse::Era;

#[derive(Debug)]
pub enum Outcome {
    Matched(Era),
    EpochBoundary,
    Inconclusive,
}

// Executes a very lightweight inspection of the initial tokens of the CBOR
// block payload to extract the tag of the block wrapper which defines the era
// of the contained bytes.
pub fn block_era(cbor: &[u8]) -> Outcome {
    let mut tokenizer = Tokenizer::new(cbor);

    if !matches!(tokenizer.next(), Some(Ok(Token::Array(2)))) {
        return Outcome::Inconclusive;
    }

    match tokenizer.next() {
        Some(Ok(Token::U8(variant))) => match variant {
            0 => Outcome::EpochBoundary,
            1 => Outcome::Matched(Era::Byron),
            2 => Outcome::Matched(Era::Shelley),
            3 => Outcome::Matched(Era::Allegra),
            4 => Outcome::Matched(Era::Mary),
            5 => Outcome::Matched(Era::Alonzo),
            6 => Outcome::Matched(Era::Babbage),
            7 => Outcome::Matched(Era::Conway),
            _ => Outcome::Inconclusive,
        },
        _ => Outcome::Inconclusive,
    }
}

pub async fn read_chunk_file(
    path: impl AsRef<Path>,
    secondary_index_path: impl AsRef<Path>,
    data_buffer: &mut Vec<u8>,
) -> anyhow::Result<ReadChunkFile> {
    let mut chunk_file = tokio::fs::File::open(path).await?;

    data_buffer.clear();
    chunk_file.read_to_end(data_buffer).await?;

    let secondary_index = SecondaryIndex::from_file(secondary_index_path).await?;

    Ok(ReadChunkFile {
        secondary_index,
        chunk_file_data: data_buffer,
        counter: 0,
    })
}

#[cfg(test)]
mod test {
    use std::collections::BTreeSet;

    use pallas_traverse::MultiEraBlock;

    use crate::{dir_chunk_numbers, read_chunk_file, SecondaryIndex};

    #[tokio::test]
    async fn test_dir_chunk_numbers() {
        let expected_chunk_numbers = (0..=12).collect::<BTreeSet<_>>();

        let chunk_numbers = dir_chunk_numbers("tests_data")
            .await
            .expect("Successfully read chunk numbers");

        assert_eq!(chunk_numbers, expected_chunk_numbers);
    }

    #[tokio::test]
    async fn test_secondary_index_from_file() {
        let index = SecondaryIndex::from_file("tests_data/00012.secondary")
            .await
            .expect("Successfully read secondary index file");

        assert_eq!(index.entries.len(), 1080);
    }

    #[tokio::test]
    async fn test_read_chunk_file() {
        let mut buffer = Vec::new();

        let mut iter = read_chunk_file(
            "tests_data/00012.chunk",
            "tests_data/00012.secondary",
            &mut buffer,
        )
        .await
        .expect("Chunk file iterator created");

        let mut last_block_no = None;
        let mut count = 0;
        while let Some((_, data)) = iter
            .next()
            .await
            .expect("Successfully ready block data from chunk file")
        {
            // Make sure we are getting valid block data
            let block = MultiEraBlock::decode(data).expect("Valid block");

            if let Some(block_no) = last_block_no {
                assert!(block.number() > block_no);
                assert_eq!(block.number() - block_no, 1u64);
            }

            last_block_no = Some(block.number());
            count += 1;
        }

        assert_eq!(count, 1080);
    }
}
