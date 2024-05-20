use minicbor::Encoder;

#[allow(unused)]
pub(crate) fn cbor_encode_integer_as_bytestring(integer: u64, encoder: &mut Encoder<&mut Vec<u8>>) {
    // Convert the integer to bytes
    let bytes = integer.to_be_bytes();
    // Trim leading zeros
    let significant_bytes = bytes
        .iter()
        .skip_while(|&&b| b == 0)
        .cloned()
        .collect::<Vec<u8>>();

    // Encode the significant bytes as a byte string in CBOR format
    encoder.bytes(&significant_bytes).unwrap();
}