meta:
    id: descent_pal
    file-extension: pal
    endian: le
    bit-endian: le

doc-ref: 2D/PALETTE.C

seq:
  - id: palette
    type: palette_entry_t
    repeat: expr
    repeat-expr: 256
  - id: fade_table
    type: u1
    repeat: expr
    repeat-expr: 256 * 34

types:
  palette_entry_t:
    seq:
      - id: r
        type: u1
      - id: g
        type: u1
      - id: b
        type: u1

  palette_fade_entry_t:
    seq:
      - id: entry
        type: u1
        repeat: expr
        repeat-expr: 34