meta:
  id: build_art
  file-extension: art
  endian: le
  bit-endian: le

doc-ref: BUILDINF.TXT
doc: |
  BUILD engine ART file. Contains textures and texture attribute
  information for the engine. This file still needs information
  on how to directly access textures at specific offsets.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: art_header
    type: art_header_t

types:
  art_header_t:
    seq:
      - id: version
        type: u4
      - id: num_tiles
        type: u4
      - id: tile_id_start
        type: u4
      - id: tile_id_end
        type: u4
      - id: tile_sizes_x
        type: u2
        repeat: expr
        repeat-expr: tile_id_start + tile_id_end + 1
      - id: tile_sizes_y
        type: u2
        repeat: expr
        repeat-expr: tile_id_start + tile_id_end + 1
      - id: tile_attributes
        type: art_tile_attribute_t
        repeat: expr
        repeat-expr: tile_id_start + tile_id_end + 1

  art_tile_attribute_t:
    seq:
      - id: unused
        type: b4
      - id: animation_speed
        type: b4
      - id: offset_y
        type: b8
      - id: offset_x
        type: b8
      - id: animation_type
        type: b2
      - id: num_frames
        type: b6
