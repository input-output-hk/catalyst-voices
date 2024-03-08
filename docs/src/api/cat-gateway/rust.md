---
icon: material/language-rust
---

<!-- cspell: words RUSTDOC graphviz -->

# Rust docs

<!-- markdownlint-disable no-inline-html -->
<iframe src="../rust-docs/index.html" title="RUSTDOC Documentation" style="height:800px;width:100%;"></iframe>

[OPEN FULL PAGE](./rust-docs/index.html)

## Workspace Dependency Graph

```graphviz dot workspace_deps.svg
{{ include_file('src/api/cat-gateway/rust-docs/workspace.dot') }}
```

## External Dependencies Graph

```graphviz dot full_deps.png
{{ include_file('src/api/cat-gateway/rust-docs/full.dot') }}
```

## Build and Development Dependencies Graph

```graphviz dot all_deps.png
{{ include_file('src/api/cat-gateway/rust-docs/all.dot') }}
```

## Module trees

### cat-gateway crate

```rust
{{ include_file('src/api/cat-gateway/rust-docs/cat-gateway.cat-gateway.bin.modules.tree') }}
```

## Module graphs

### cat-gateway crate

```graphviz dot modules.png
{{ include_file('src/api/cat-gateway/rust-docs/cat-gateway.cat-gateway.bin.modules.dot') }}
```
