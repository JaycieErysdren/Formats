meta:
    id: descent_pig
    file-extension: pig
    endian: le
    bit-endian: le

seq:
  - id: num_bitmaps
    type: u4
  - id: num_sounds
    type: u4
  - id: bitmaps
    type: bitmap_header_t
    repeat: expr
    repeat-expr: num_bitmaps
  - id: sounds
    type: sound_header_t
    repeat: expr
    repeat-expr: num_sounds

types:
  bitmap_header_t:
    seq:
      - id: name
        type: strz
        size: 8
        encoding: ascii
      - id: dflags
        type: u1
      - id: width
        type: u1
      - id: height
        type: u1
      - id: flags
        type: u1
      - id: average_color
        type: u1
      - id: ofs_data
        type: u4
    instances:
      data_pos:
        value: ofs_data + (17 * _root.num_bitmaps) + (20 * _root.num_sounds) + 8
      get_linear_data:
        pos: data_pos
        size: width * height
      get_rle_data:
        pos: data_pos
        type: rle_bitmap_t

  rle_bitmap_t:
    seq:
      - id: next_ofs
        type: u4
      - id: run_lengths
        type: u1
        repeat: expr
        repeat-expr: _parent.height
      - id: pixels
        type: u1
        repeat: expr
        repeat-expr: next_ofs - _parent.height - 4

  sound_header_t:
    seq:
      - id: name
        type: strz
        size: 8
        encoding: ascii
      - id: length
        type: u4
      - id: len_data
        type: u4
      - id: ofs_data
        type: u4
    instances:
      data:
        pos: ofs_data
        size: len_data
