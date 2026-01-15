import 'package:catalyst_voices/common/codecs/markdown_to_plain_codec.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(MarkdownToPlainStringEncoder, () {
    const converter = MarkdownToPlainStringEncoder();
    test('convert simple markdown into plain text', () {
      const markdown = MarkdownData('# Hello Catalyst!');

      expect(
        converter.convert(markdown),
        equals('Hello Catalyst!'),
      );
    });

    test('convert complex markdown into plain text', () {
      const markdown = MarkdownData('''
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

---

# Text Formatting

**Bold text**

__Bold text__

*Italic text*

_Italic text_

***Bold italic***

___Bold italic___

~~Strikethrough~~

`Inline code`

==Highlight (not supported)==

Line with a break  
Second line

[Link to external website](https://google.com)

---

# Blockquotes

> This is a quote.
>> This is a nested quote.

---

# Lists

## Unordered lists

- Item A
- Item B
  - Sub item B1
  - Sub item B2
* Another style
+ Another style

## Ordered lists

1. First item
2. Second item
3. Third item

Auto-numbering:
1. Item
1. Item
1. Item

---

# Task Lists (not supported)

- [ ] Not done
- [x] Done

---

# Code Blocks

## Fenced code block

```dart
void main() {
  print("Hello, world!");
}
```
''');

      expect(
        converter.convert(markdown),
        equals('''
Heading 1
Heading 2
Heading 3
Heading 4
Heading 5
Heading 6

Text Formatting
Bold text
Bold text
Italic text
Italic text
Bold italic
Bold italic
~~Strikethrough~~
Inline code
==Highlight (not supported)==
Line with a break
Second line
Link to external website

Blockquotes
This is a quote.This is a nested quote.

Lists
Unordered lists
Item A
Item B
Sub item B1
Sub item B2
Another style
Another style
Ordered lists
First item
Second item
Third item
Auto-numbering:
Item
Item
Item

Task Lists (not supported)
[ ] Not done
[x] Done

Code Blocks
Fenced code block
void main() {
  print(&quot;Hello, world!&quot;);
}'''),
      );
    });
  });
}
