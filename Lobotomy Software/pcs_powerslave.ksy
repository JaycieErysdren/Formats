meta:
  id: pcs_powerslave
  file-extension: pcs
  endian: be
  bit-endian: be

seq:
  - id: len_bitmaps
    type: u4
  - id: bitmaps
    type: bitmap_t
    repeat: expr
    repeat-expr: len_bitmaps / 77328

types:
  bitmap_t:
    seq:
      - id: num_bitmap
        type: u4
      - id: width
        type: u4
      - id: height
        type: u4
      - id: bitmap
        type: b8
        repeat: expr
        repeat-expr: num_bitmap
      - id: padding_bottom
        type: u4
      - id: palette
        type: palette_entry_t
        repeat: expr
        repeat-expr: 256

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