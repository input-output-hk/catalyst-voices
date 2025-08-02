-- Manually generated Catalyst Signed Documents v0.0.3 spec version from the CBOR, using `minicbor` crate
-- Its not a fully valid Catalyst Signed Document according to the all `catalyst-gateway` enforced rules
-- Code reference
-- ```rust
--     use catalyst_signed_doc::{CatalystSignedDocument, ContentType, DocType, UuidV4, UuidV7};
--     use minicbor::{data::Tag, Encoder};

--     let mut e = Encoder::new(Vec::new());
--     e.tag(Tag::new(98))?;
--     e.array(4)?;
--
--     // protected headers (metadata fields)
--     e.bytes({
--         let mut p_headers = Encoder::new(Vec::new());
--         p_headers.map(5)?;
--         p_headers.u8(3)?.encode(ContentType::Json)?;
--         p_headers.str("id")?.encode_with(
--             UuidV7::new(),
--             &mut catalyst_types::uuid::CborContext::Tagged,
--         )?;
--         p_headers.str("ver")?.encode_with(
--             UuidV7::new(),
--             &mut catalyst_types::uuid::CborContext::Tagged,
--         )?;
--         p_headers
--             .str("type")?
--             .encode(&DocType::from(UuidV4::new()))?;
--
--         p_headers.str("ref")?;
--         p_headers.array(2)?;
--         p_headers.encode_with(
--             UuidV7::new(),
--             &mut catalyst_types::uuid::CborContext::Tagged,
--         )?;
--         p_headers.encode_with(
--             UuidV7::new(),
--             &mut catalyst_types::uuid::CborContext::Tagged,
--         )?;
--
--         p_headers.into_writer().as_slice()
--     })?;
--
--     // empty unprotected headers
--     e.map(0)?;
--     // content
--     e.bytes(serde_json::to_vec(&serde_json::json!({}))?.as_slice())?;
--     // zero signatures
--     e.array(0)?;
--
--     let doc = CatalystSignedDocument::try_from(e.into_writer().as_slice())?;
-- ```

-- cspell: words noqa

INSERT INTO signed_docs (
  id,
  ver,
  type,
  authors,
  metadata,
  payload,
  raw
)
VALUES (
  '019846aa-ecb7-7ce1-b7ce-c931abf47c7f',
  '019846aa-ecb7-7ce1-b7ce-c94660a040b5',
  '14ff79be-d068-49cc-8c48-a72f8ad276f1',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846aa-ecb7-7ce1-b7ce-c931abf47c7f","template":{"id":"019846aa-ecb7-7ce1-b7ce-c95cf8f078c2","ver":"019846aa-ecb8-70b2-8636-b65cb8539a87"},"type":"14ff79be-d068-49cc-8c48-a72f8ad276f1","ver":"019846aa-ecb7-7ce1-b7ce-c94660a040b5"}', -- noqa: LT05
  '{}',
  DECODE('d862845888a503706170706c69636174696f6e2f6a736f6e626964d82550019846aaecb77ce1b7cec931abf47c7f63766572d82550019846aaecb77ce1b7cec94660a040b56474797065d8255014ff79bed06849cc8c48a72f8ad276f16874656d706c61746582d82550019846aaecb77ce1b7cec95cf8f078c2d82550019846aaecb870b28636b65cb8539a87a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846ad-4676-73f3-899f-a3786eb96651',
  '019846ad-4676-73f3-899f-a381cef1bb99',
  '50aa7cf6-b35d-4a2e-92d6-03fe3b5ce9ef',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846ad-4676-73f3-899f-a3786eb96651","ref":{"id":"019846ad-4676-73f3-899f-a39cfd0df291","ver":"019846ad-4676-73f3-899f-a3a925dc1c59"},"type":"50aa7cf6-b35d-4a2e-92d6-03fe3b5ce9ef","ver":"019846ad-4676-73f3-899f-a381cef1bb99"}', -- noqa: LT05
  '{}',
  DECODE('d862845883a503706170706c69636174696f6e2f6a736f6e626964d82550019846ad467673f3899fa3786eb9665163766572d82550019846ad467673f3899fa381cef1bb996474797065d8255050aa7cf6b35d4a2e92d603fe3b5ce9ef6372656682d82550019846ad467673f3899fa39cfd0df291d82550019846ad467673f3899fa3a925dc1c59a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846ae-fad7-7cc3-9e0a-dfe6ad9ae61c',
  '019846ae-fad8-73c2-84e0-f47e0b784582',
  '82c48628-8228-422a-90ce-690e18e757d4',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846ae-fad7-7cc3-9e0a-dfe6ad9ae61c","reply":{"id":"019846ae-fad8-73c2-84e0-f482cc5d5332","ver":"019846ae-fad8-73c2-84e0-f494ac555584"},"type":"82c48628-8228-422a-90ce-690e18e757d4","ver":"019846ae-fad8-73c2-84e0-f47e0b784582"}', -- noqa: LT05
  '{}',
  DECODE('d862845885a503706170706c69636174696f6e2f6a736f6e626964d82550019846aefad77cc39e0adfe6ad9ae61c63766572d82550019846aefad873c284e0f47e0b7845826474797065d8255082c486288228422a90ce690e18e757d4657265706c7982d82550019846aefad873c284e0f482cc5d5332d82550019846aefad873c284e0f494ac555584a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846b0-09d9-7d92-befe-131b7022f17d',
  '019846b0-09d9-7d92-befe-13215cddcef8',
  '51551a19-1c92-4a25-a9b0-c58ec92c6221',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846b0-09d9-7d92-befe-131b7022f17d","parameters":{"id":"019846b0-09d9-7d92-befe-133d24cf102e","ver":"019846b0-09d9-7d92-befe-134ae513b067"},"type":"51551a19-1c92-4a25-a9b0-c58ec92c6221","ver":"019846b0-09d9-7d92-befe-13215cddcef8"}', -- noqa: LT05
  '{}',
  DECODE('d86284588aa503706170706c69636174696f6e2f6a736f6e626964d82550019846b009d97d92befe131b7022f17d63766572d82550019846b009d97d92befe13215cddcef86474797065d8255051551a191c924a25a9b0c58ec92c62216a706172616d657465727382d82550019846b009d97d92befe133d24cf102ed82550019846b009d97d92befe134ae513b067a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846b0-fa10-7f13-a1aa-579c986d6251',
  '019846b0-fa10-7f13-a1aa-57ab6817b0a6',
  '22762c34-72e8-4a5c-9a3f-080e94b46aa4',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846b0-fa10-7f13-a1aa-579c986d6251","category_id":{"id":"019846b0-fa10-7f13-a1aa-57b4529ffcd4","ver":"019846b0-fa10-7f13-a1aa-57c5e41679a5"},"type":"22762c34-72e8-4a5c-9a3f-080e94b46aa4","ver":"019846b0-fa10-7f13-a1aa-57ab6817b0a6"}', -- noqa: LT05
  '{}',
  DECODE('d86284588ba503706170706c69636174696f6e2f6a736f6e626964d82550019846b0fa107f13a1aa579c986d625163766572d82550019846b0fa107f13a1aa57ab6817b0a66474797065d8255022762c3472e84a5c9a3f080e94b46aa46b63617465676f72795f696482d82550019846b0fa107f13a1aa57b4529ffcd4d82550019846b0fa107f13a1aa57c5e41679a5a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846b1-def7-77f2-b5f4-bb757a07d683',
  '019846b1-def7-77f2-b5f4-bb8176066776',
  'a8890f3f-af93-4d8b-bf38-7c6e47422054',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846b1-def7-77f2-b5f4-bb757a07d683","brand_id":{"id":"019846b1-def7-77f2-b5f4-bb92f3e9383f","ver":"019846b1-def7-77f2-b5f4-bba83bae3e51"},"type":"a8890f3f-af93-4d8b-bf38-7c6e47422054","ver":"019846b1-def7-77f2-b5f4-bb8176066776"}', -- noqa: LT05
  '{}',
  DECODE('d862845888a503706170706c69636174696f6e2f6a736f6e626964d82550019846b1def777f2b5f4bb757a07d68363766572d82550019846b1def777f2b5f4bb81760667766474797065d82550a8890f3faf934d8bbf387c6e47422054686272616e645f696482d82550019846b1def777f2b5f4bb92f3e9383fd82550019846b1def777f2b5f4bba83bae3e51a0427b7d80', 'hex') -- noqa: LT05
),
(
  '019846b4-f0a9-7583-aa8b-5c0a991d50c0',
  '019846b4-f0a9-7583-aa8b-5c1ba4e9bbad',
  '0eee1a2d-caaf-4e7b-be4f-4aaa2e80b6e2',
  ARRAY[]::TEXT [],
  '{"content-type":"application/json","id":"019846b4-f0a9-7583-aa8b-5c0a991d50c0","campaign_id":{"id":"019846b4-f0a9-7583-aa8b-5c25d8cf2f06","ver":"019846b4-f0a9-7583-aa8b-5c36e1f4b274"},"type":"0eee1a2d-caaf-4e7b-be4f-4aaa2e80b6e2","ver":"019846b4-f0a9-7583-aa8b-5c1ba4e9bbad"}', -- noqa: LT05
  '{}',
  DECODE('d86284588ba503706170706c69636174696f6e2f6a736f6e626964d82550019846b4f0a97583aa8b5c0a991d50c063766572d82550019846b4f0a97583aa8b5c1ba4e9bbad6474797065d825500eee1a2dcaaf4e7bbe4f4aaa2e80b6e26b63616d706169676e5f696482d82550019846b4f0a97583aa8b5c25d8cf2f06d82550019846b4f0a97583aa8b5c36e1f4b274a0427b7d80', 'hex') -- noqa: LT05
);
