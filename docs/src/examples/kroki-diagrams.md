---
icon: material/drawing-box
---

# Kroki Diagrams

## Kroki Mermaid

* No Links
* Stand alone SVG

```kroki-mermaid theme=forest
flowchart LR
  A[Start] --> B{Error?};
  B -->|Yes| C[Hmm...];
  C --> D[Debug];
  D --> B;
  B ---->|No| E[Yay!];
```

## Other types

```kroki-blockdiag no-transparency=false size=1000x400
blockdiag {
  blockdiag -> generates -> "block-diagrams";
  blockdiag -> is -> "very easy!!";

  blockdiag [color = "greenyellow"];
  "block-diagrams" [color = "pink"];
  "very easy!!" [color = "orange"];
}
```
