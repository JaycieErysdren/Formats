meta:
  id: pic_quake
  file-extension: pic
  endian: be
  bit-endian: be

doc: |
  Simple paletted bitmap used by Sega Saturn Quake, created by Lobotomy Software.
  Contains a palette, width, height, and an array of pixels.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: palette
    type: palette_entry_t
    repeat: expr
    repeat-expr: 256
  - id: width
    type: s4
  - id: height
    type: s4
  - id: bitmap
    type: b8
    repeat: expr
    repeat-expr: width * height

types:
  palette_entry_t:
    seq:
      - id: a
        type: b1
      - id: b
        type: b5
      - id: g
        type: b5
      - id: r
        type: b5