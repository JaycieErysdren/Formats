meta:
  id: portal2d_map
  file-extension: map
  endian: le
  bit-endian: le

doc-ref: https://sourceforge.net/p/portal2d/code/HEAD/tree/Source/level.c
doc: |
  This is the basic level format used by the Portal2D engine, created by Derek John Evans
  over the summer of 1999.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: chunks
    type: chunk_t
    repeat: eos

types:
  chunk_t:
    seq:
      - id: type
        type: str
        encoding: ascii
        size: 4
      - id: id
        type: s4
      - id: flags
        type: s4
      - id: len_data
        type: s4
      - id: data
        type:
          switch-on: type
          cases:
            "'LLAW'": wall_t
            "'TCES'": sector_t
            _: unknown_chunk_t

  surface_t:
    seq:
      - id: texture_id
        type: u1
      - id: overlay_id
        type: u1
      - id: flags
        type: u2
      - id: light_level
        type: u1
      - id: color_r
        type: u1
      - id: color_g
        type: u1
      - id: color_b
        type: u1
      - id: slope_x
        type: s4
      - id: slope_y
        type: s4
      - id: slope_z
        type: s4
      - id: repeat_x
        type: u1
      - id: padding_1
        size: 3
      - id: repeat_y
        type: u1
      - id: padding_2
        size: 3
      - id: uv_x
        type: s4
      - id: uv_y
        type: s4
      - id: reserved
        size: 4

  wall_t:
    seq:
      - id: side_id
        type: u2
      - id: padding_1
        type: u2
      - id: next_wall_id
        type: u2
      - id: padding_2
        type: u2
      - id: portal_id
        type: u2
      - id: padding_3
        type: u2
      - id: x
        type: s4
      - id: y
        type: s4
      - id: surface
        type: surface_t

  sector_t:
    seq:
      - id: lid
        type: u2
      - id: padding
        type: u2
      - id: first_wall_id
        type: u2
      - id: flags
        type: u2
      - id: top_surface
        type: surface_t
      - id: bottom_surface
        type: surface_t
      - id: middle_surface
        type: surface_t

  unknown_chunk_t:
    seq:
      - id: data
        size: _parent.len_data
