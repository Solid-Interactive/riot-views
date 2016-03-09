# Riot Views

This is a collection of reusable riot views. They can be used as components to build up functionality.

Each view is prefixed with `rv-`.

## Guide

### `rv-clamp`

A Clamp can be used to limit the number of lines displayed and ellipsize the last line i fthere is overflow. Internally
it uses a `<yield />`.

Attributes:
* lines: number of lines to clamp to - default: 1

Content:
* Text you want clamped.

```html
<rv-clamp lines="2">
    The following text will be clamped to
    two lines even if the text is longer
    than two lines.
</rv-clamp>
```