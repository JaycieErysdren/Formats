meta:
  id: dvision_uvi
  file-extension: uvi
  endian: be
  bit-endian: be

seq:
  - id: empty1
    size: 3840
  - id: pixels
    type: rgb_t
    repeat: expr
    repeat-expr: (57600 - 3840) / 2
  - id: empty2
    size: 256
  - id: empty3
    size: 3840
  - id: palette
    type: rgb_t
    repeat: expr
    repeat-expr: 7424 / 2
  - id: identifier
    type: str
    encoding: ascii
    size-eos: true

types:
  rgb_t:
    seq:
      - id: r
        type: b5
      - id: g
        type: b6
      - id: b
        type: b5
  
  palette_entry_t:
    seq:
      - id: r
        type: u1
      - id: g
        type: u1
      - id: b
        type: u1