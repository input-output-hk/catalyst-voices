---
icon: material/draw
---

# Mermaid Diagrams

There is overlap between Kroki and Mermaid

Mermaid can not zoom, but it can embed links.

``` mermaid
graph LR
  A[Start] --> B{Error?};
  B -->|Yes| C[Hmm...];
  C --> D[Debug];
  D --> B;
  B ---->|No| E[Yay!];

  click A "https://www.github.com" _blank

```
