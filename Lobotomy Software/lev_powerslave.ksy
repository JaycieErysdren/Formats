meta:
  id: lev_powerslave
  file-extension: lev
  endian: be
  bit-endian: be

doc: |
  Level format used by Sega Saturn PowerSlave, created by Lobotomy Software.
  Contains level mesh information, entities, textures, sounds, and other game data.
  This format is not fully understood.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: sky_data
    type: sky_data_t
  - id: unknown01
    size: 1284
  - id: header
    type: header_t
  - id: sectors
    type: sector_t
    repeat: expr
    repeat-expr: header.num_sectors
  - id: planes
    type: plane_t
    repeat: expr
    repeat-expr: header.num_planes
  - id: vertices
    type: vertex_t
    repeat: expr
    repeat-expr: header.num_planes
  - id: quads
    type: quad_t
    repeat: expr
    repeat-expr: header.num_quads

types:
  sky_data_t:
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

  unknown02_t:
    seq:
      - id: num_blocks
        type: s4
      - id: blocks
        type: unknown02_block_t
        repeat: expr
        repeat-expr: num_blocks

  unknown02_block_t:
    seq:
      - id: len_data
        type: s4
      - id: data
        size: len_data

  # 56 bytes
  header_t:
    seq:
      - id: num_sectors
        type: u4
      - id: num_planes
        type: u4
      - id: num_vertices
        type: u4
      - id: num_quads
        type: u4
      - id: unknown01
        type: u4
      - id: unknown02
        type: u4
      - id: unknown03
        type: u4
      - id: unknown04
        type: u4
      - id: unknown05
        type: u4
      - id: unknown06
        type: u4
      - id: unknown07
        type: u4
      - id: unknown08
        type: u4
      - id: unknown09
        type: u4
      - id: unknown10
        type: u4

  # 28 bytes each
  sector_t:
    seq:
      - id: reserved
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: unknown01
        type: u2
        repeat: expr
        repeat-expr: 4
      - id: plane_start_index
        type: s2
      - id: plane_end_index
        type: s2
      - id: unknown02
        type: u2
      - id: flags
        type: u2
      - id: unknown03
        type: u2
      - id: unknown04
        type: u2

  # 40 bytes each
  plane_t:
    seq:
      - id: normal
        type: s4
        repeat: expr
        repeat-expr: 3
      - id: angle
        type: s4
      - id: unknown01
        type: s2
      - id: unknown02
        type: s2
      - id: flags
        type: u2
      - id: texture_index
        type: u2
      - id: quad_start_index
        type: s2
      - id: quad_end_index
        type: s2
      - id: vertex_start_index
        type: u2
      - id: vertex_end_index
        type: u2
      - id: vertex_indices
        type: u2
        repeat: expr
        repeat-expr: 4
      - id: unknown03
        type: s2
      - id: lookup
        type: u2
      - id: unknown04
        type: s2
      - id: unknown05
        type: s2

  # 44 bytes each
  tile_t:
    seq:
      - id: ofs_texture_data
        type: u2
      - id: width
        type: u1
      - id: height
        type: u1
      - id: ofs_color_data
        type: u2
      - id: unknown
        type: u2
      - id: horizontal_vector
        type: s4
        repeat: expr
        repeat-expr: 3
      - id: vertical_vector
        type: s4
        repeat: expr
        repeat-expr: 3
      - id: base_vector
        type: s4
        repeat: expr
        repeat-expr: 3

  # 8 bytes each
  vertex_t:
    seq:
      - id: coords
        type: s2
        repeat: expr
        repeat-expr: 3
      - id: color_lookup
        type: u1
      - id: reserved
        type: u1

  # 5 bytes each
  quad_t:
    seq:
      - id: vertex_indices
        type: u2
        repeat: expr
        repeat-expr: 4
      - id: unknown01
        type: b8
      - id: unknown02
        type: b8

  # 4 bytes each
  entity_t:
    seq:
      - id: ent_type
        type: u4
      - id: ofs_entity_data
        type: u4

  entity_generic_t:
    seq:
      - id: start
        type: s2
      - id: coords
        type: s2
        repeat: expr
        repeat-expr: 3

  entity_polymover_t:
    seq:
      - id: polylink_id
        type: s2
      - id: data
        type: s2
        repeat: expr
        repeat-expr: 20

  entity_polylink_data1_t:
    seq:
      - id: data
        type: u1
        repeat: eos

  entity_polylink_data2_t:
    seq:
      - id: data
        type: u1
        repeat: eos

  # 18 bytes each
  entity_polylink_t:
    seq:
      - id: lead
        type: u2
      - id: ofs_entity_polylink_data1
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: ofs_entity_polylink_data2
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: unknown
        type: u2
      - id: reserved
        type: u2
        repeat: expr
        repeat-expr: 3

  resources_t:
    seq:
      - id: prefix
        type: resources_prefix_t
      - id: num_sounds
        type: u4
      - id: sounds
        type: sound_t
        repeat: expr
        repeat-expr: num_sounds
      - id: len_unknown
        type: u4
      - id: unknown
        size: len_unknown
      - id: len_palette
        type: u4
      - id: palette
        type: palette_entry_t
        repeat: expr
        repeat-expr: len_palette / 2
      - id: num_resources
        type: u4
      - id: resources
        type: resource_t
        repeat: expr
        repeat-expr: num_resources

  resources_prefix_t:
    seq:
      - id: num_values
        type: u4
      - id: values
        type: s2
        repeat: expr
        repeat-expr: num_values

  sound_t:
    seq:
      - id: len_samples
        type: s4
      - id: maybe_pitch_adjust
        type: s4
        doc: |
          from comparing the extracted sounds with the sounds in the game
          (see https://www.youtube.com/watch?v=Wse8iFMM-jg&t=207s and E1L1.LEV
          sound 0), i think this is a speed/pitch adjust. 0x7000 seems to be
          the nominal value, with sounds with that value sounding the same. but
          notably door and elevator sound pitches sound different in game, and
          they have a different value here. however, i havent managed to find
          a consistent correlation between these values and the pitch change.
          -- vfig
      - id: bits
        type: s4
        doc: bits per sample; 8 or 16.
      - id: loop_point
        type: s4
        doc: |
          index of sample (or possibly byte offset; with 8 bit sounds its the
          same) from which to loop after reaching the end of the sound the
          first time. 0 means the entire sample loops; -1 means no loop.
      - id: samples       # signed, mono, 11025 Hz PCM
        size: len_samples

  resource_t:
    seq:
      - id: flags
        type: u1
      - id: resource_type
        type: u1
      - id: data
        type:
          switch-on: resource_type
          cases:
            0x82: texture_t # texture (130)
            0x2A: resource_0x2c_t # unknown (42)
            0x2C: resource_0x2c_t # unknown (44)

  texture_t:
    seq:
      - id: palette
        type: palette_entry_t
        repeat: expr
        repeat-expr: 16
      - id: bitmap
        type: b4
        repeat: expr
        repeat-expr: 64 * 64

  resource_0x2c_t:
    seq:
      - id: unknown
        type: u4
      - id: len_data
        type: u2
      - id: data
        size: len_data

  resource_0x34_t:
    seq:
      - id: unknown01
        type: u2
      - id: unknown02
        size: 0x400

  resource_0x6a_t:
    seq:
      - id: unknown0
        type: u2
      - id: len_data
        type: u2
      - id: data
        size: len_data

  resource_0x6c_t:
    seq:
      - id: unknown0
        type: u2
      - id: len_data
        type: u2
      - id: data
        size: len_data

  len_and_unknown_t:
    seq:
    - id: len_data
      type: u4
    - id: data
      size: len_data