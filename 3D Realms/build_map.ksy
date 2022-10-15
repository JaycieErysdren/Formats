meta:
  id: build_map
  file-extension: map
  endian: le
  bit-endian: le

doc-ref: BUILDINF.TXT
doc: |
  BUILD engine .MAP file. Used to store level geometry and 
  entity position data for games like Duke Nukem 3D.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: header
    type: header_t
  - id: num_sectors
    type: s2
  - id: sectors
    type: sector_t
    repeat: expr
    repeat-expr: num_sectors
  - id: num_walls
    type: s2
  - id: walls
    type: wall_t
    repeat: expr
    repeat-expr: num_walls
  - id: num_sprites
    type: s2
  - id: sprites
    type: sprite_t
    repeat: expr
    repeat-expr: num_sprites

types:
  header_t:
    seq:
      - id: version
        type: s4
      - id: start_position
        type: vec3l_t
      - id: start_angle
        type: s2
      - id: start_sector
        type: s2

  sector_t:
    seq:
      - id: wall_pointer
        type: s2
      - id: wall_num
        type: s2
      - id: ceiling_z
        type: s4
      - id: floor_z
        type: s4
      - id: ceiling_stat
        type: s2
      - id: floor_stat
        type: s2
      - id: ceiling_texture_id
        type: s2
      - id: ceiling_hei_num
        type: s2
      - id: ceiling_shade
        type: s1
      - id: ceiling_pal
        type: u1
      - id: ceiling_x_panning
        type: u1
      - id: ceiling_y_panning
        type: u1
      - id: floor_texture_id
        type: s2
      - id: floor_hei_num
        type: s2
      - id: floor_shade
        type: s1
      - id: floor_pal
        type: u1
      - id: floor_x_panning
        type: u1
      - id: floor_y_panning
        type: u1
      - id: visibility
        type: u1
      - id: filler
        type: u1
      - id: lotag
        type: s2
      - id: hitag
        type: s2
      - id: extra
        type: s2

  wall_t:
    seq:
      - id: position
        type: vec2l_t
      - id: point2
        type: s2
      - id: nextwall
        type: s2
      - id: nextsector
        type: s2
      - id: cstat
        type: s2
      - id: texture_id
        type: s2
      - id: texture_id_overlay
        type: s2
      - id: shade
        type: s1
      - id: palette_table
        type: u1
      - id: repeat
        type: vec2uc_t
      - id: panning
        type: vec2uc_t
      - id: lotag
        type: s2
      - id: hitag
        type: s2
      - id: extra
        type: s2

  sprite_t:
    seq:
      - id: position
        type: vec3l_t
      - id: cstat
        type: s2
      - id: texture_id
        type: s2
      - id: shade
        type: s1
      - id: palette_table
        type: s1
      - id: clip_dist
        type: s1
      - id: filler
        type: s1
      - id: repeat
        type: vec2uc_t
      - id: offset
        type: vec2c_t
      - id: sector_id
        type: s2
      - id: stat_id
        type: s2
      - id: angle
        type: s2
      - id: owner
        type: s2
      - id: velocity
        type: vec3s_t
      - id: lotag
        type: s2
      - id: hitag
        type: s2
      - id: extra
        type: s2

  vec2c_t:
    seq:
      - id: x
        type: s1
      - id: y
        type: s1

  vec2uc_t:
    seq:
      - id: x
        type: u1
      - id: y
        type: u1

  vec2l_t:
    seq:
      - id: x
        type: s4
      - id: y
        type: s4

  vec3l_t:
    seq:
      - id: x
        type: s4
      - id: y
        type: s4
      - id: z
        type: s4

  vec3s_t:
    seq:
      - id: x
        type: s2
      - id: y
        type: s2
      - id: z
        type: s2
