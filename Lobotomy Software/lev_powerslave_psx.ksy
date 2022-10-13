meta:
  id: lev_powerslave_psx
  file-extension: zed
  endian: le
  bit-endian: le

doc-ref: https://github.com/svkaiser/PowerslaveEX/blob/master/scratchcode/scratch.cpp
doc: |
  Level format used by PSX PowerSlave, created by Lobotomy Software.
  Contains level mesh information, entities, textures, sounds, and other game data.
  This format is not fully understood.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: header
    type: header_t
  - id: texture_data
    size: texdata_padded
  - id: audio_data
    size: auddata_padded
  - id: sectors
    type: sector_t
    repeat: expr
    repeat-expr: header.num_sectors
  - id: planes
    type: plane_t
    repeat: expr
    repeat-expr: header.num_planes
  - id: quads
    type: quad_t
    repeat: expr
    repeat-expr: header.num_quads
  - id: vertices
    type: vertex_t
    repeat: expr
    repeat-expr: header.num_vertices
  - id: uv_maps
    type: uv_map_t
    repeat: expr
    repeat-expr: header.num_uv_maps
  - id: entities
    type: entity_t
    repeat: expr
    repeat-expr: header.num_entities
  - id: events
    type: event_t
    repeat: expr
    repeat-expr: header.num_events

instances:
  texdata_padded:
    value: (texdata_size + ((0x800 - (texdata_size & 0x7FF)) & 0x7FF))

  auddata_padded:
    value: (auddata_size + ((0x800 - (auddata_size & 0x7FF)) & 0x7FF))

  auddata_size:
    value: header.len_audio_data

  texdata_size:
    value: header.len_texture_data2 << 16 | header.len_texture_data1

types:
  header_t:
    seq:
      - id: unknown01
        type: u2
      - id: len_texture_data1
        type: u2
      - id: len_texture_data2
        type: u2
      - id: num_audio
        type: u2
      - id: len_audio_data
        type: s4
      - id: len_level_data
        type: s4
      - id: unknown02
        type: u2
      - id: num_sectors
        type: u2
      - id: num_planes
        type: u2
      - id: num_quads
        type: u2
      - id: num_vertices
        type: u2
      - id: num_uv_maps
        type: u2
      - id: num_entities
        type: u2
      - id: num_events
        type: u2
      - id: num_sprites
        type: u2
      - id: num_sprite_frames
        type: u2
      - id: num_sprite_info
        type: u2
      - id: num_sprite_offsets
        type: u2
      - id: table_sprite_actors
        type: s2
        repeat: expr
        repeat-expr: 182 # hardcoded?
      - id: table_hud_sprites
        type: s2
        repeat: expr
        repeat-expr: 10
      - id: mipmap_translation
        type: s2
        repeat: expr
        repeat-expr: 16
      - id: glob
        size: 0x7E38

  sector_t:
    seq:
      - id: plane_indexes
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: light_level
        type: u2
      - id: ceiling_height
        type: s2
      - id: floor_height
        type: s2
      - id: unknown_indexes
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: ceiling_slope
        type: s2
      - id: floor_slope
        type: s2
      - id: unknown_vector01
        type: s2
        repeat: expr
        repeat-expr: 6
      - id: flags
        type: u2
      - id: unknown_vector02
        type: s2
        repeat: expr
        repeat-expr: 26

  plane_t:
    seq:
      - id: vertex_indices
        type: s2
        repeat: expr
        repeat-expr: 2
      - id: vertex_start_index
        type: u2
      - id: sector_index
        type: s2
      - id: angle
        type: s2
      - id: normal
        type: s2
        repeat: expr
        repeat-expr: 3
      - id: flags
        type: s2
      - id: un1
        type: s2
      - id: quad_start_index
        type: u2
      - id: quad_end_index
        type: u2
      - id: reserved
        type: s2
        repeat: expr
        repeat-expr: 6

  quad_t:
    seq:
      - id: vertex_indices
        type: u1
        repeat: expr
        repeat-expr: 4
      - id: texture_index
        type: s2
      - id: uv_index
        type: u2
      - id: flipped
        type: s2
      - id: reserved
        type: s2

  vertex_t:
    seq:
      - id: coords
        type: s2
        repeat: expr
        repeat-expr: 3
      - id: light_value
        type: u2

  uv_map_t:
    seq:
      - id: top_left
        type: u1
        repeat: expr
        repeat-expr: 2
      - id: top_right
        type: u1
        repeat: expr
        repeat-expr: 2
      - id: bottom_right
        type: u1
        repeat: expr
        repeat-expr: 2
      - id: bottom_left
        type: u1
        repeat: expr
        repeat-expr: 2

  entity_t:
    seq:
      - id: un1
        type: s2
      - id: x
        type: s2
      - id: params
        type: s2
      - id: y
        type: s2
      - id: tag
        type: s2
      - id: z
        type: s2
      - id: sector_index
        type: s2
      - id: type
        type: s2
      - id: un2
        type: s2
      - id: un3
        type: s2

  event_t:
    seq:
      - id: type
        type: s2
      - id: sector_index
        type: s2
      - id: tag
        type: s2
      - id: un1
        type: s2

