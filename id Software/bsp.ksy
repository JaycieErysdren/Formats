meta:
  id: bsp
  file-extension: bsp
  endian: le
  bit-endian: le

doc-ref: |
  https://www.gamers.org/dEngine/quake/spec/quake-spec34/qkspec_4.htm
  https://quakewiki.org/wiki/Quake_BSP_Format
  https://quakewiki.org/wiki/BSP2
  https://www.flipcode.com/archives/Quake_2_BSP_File_Format.shtml
  http://www.mralligator.com/q3/
  https://hlbsp.sourceforge.net/index.php?content=bspdef
  https://developer.valvesoftware.com/wiki/Source_BSP_File_Format

doc: |
  Binary space partition file, used by various idTech-derived games
  and engines including Quake, Quake 2, Half-Life, Half-Life 2
  and the rest of the Source Engine.

  This is an early version of this file. It can retrieve lump data
  from most iterations of the BSP format, but does not do anything
  to aid in parsing that lump data yet.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: bsp_version
    type: u4
    enum: bsp_versions
  - id: bsp_directory
    type:
      switch-on: bsp_version
      cases:
        'bsp_versions::bsp23': bsp_directory_t # qtest
        'bsp_versions::bsp28': bsp_directory_t # quake beta 3
        'bsp_versions::bsp29': bsp_directory_t # quake
        'bsp_versions::bsp30': bsp_directory_t # half-life
        'bsp_versions::bsp2': bsp_directory_t # quake bsp2
        'bsp_versions::bsp2rmq': bsp_directory_t # quake 2psb
        'bsp_versions::q64': bsp_directory_t # quake 64
        'bsp_versions::ibsp': ibsp_directory_t # quake 2, quake 3
        'bsp_versions::vbsp': vbsp_directory_t # source engine

types:

  #
  # bsp versions 23-28-29-30 (qtest, quake beta 3, quake and half-life)
  #

  # lump directory

  bsp_directory_t:
    seq:
      - id: bsp_lumps
        type: bsp_lump_t
        repeat: expr
        repeat-expr: num_lumps
    instances:
      num_lumps:
        value: '_root.bsp_version == bsp_versions::bsp23 ? 14 : 15' 

  # lump

  bsp_lump_t:
    seq:
      - id: ofs_lump
        type: u4
      - id: len_lump
        type: u4
    instances:
      get_lump_data:
        pos: ofs_lump
        size: len_lump

  # brush model

  bsp_brush_model_t:
    seq:
      - id: origin
        type: vec3f_t
      - id: bsp_node_id
        type: u4
      - id: clip_node_ids
        type: u4
        repeat: expr
        repeat-expr: 2
      - id: unknown_node_id
        type: u4
      - id: num_leafs
        type: u4
      - id: index_faces
        type: u4
      - id: num_faces
        type: u4

  # bounding box (float)

  bsp_bbox_float_t:
    seq:
      - id: min
        type: vec3f_t
      - id: max
        type: vec3f_t

  # bounding box (short)

  bsp_bbox_short_t:
    seq:
      - id: min
        type: vec3s_t
      - id: max
        type: vec3s_t

  #
  # bspx (quake)
  #

  bspx_t:
    seq:
      - id: num_lumps
        type: u4
      - id: bspx_lumps
        type: bspx_lump_t
        repeat: expr
        repeat-expr: num_lumps

  bspx_lump_t:
    seq:
      - id: identifier
        type: str
        encoding: ascii
        size: 24
      - id: ofs_lump
        type: u4
      - id: len_lump
        type: u4
    instances:
      get_lump_data:
        pos: ofs_lump
        size: len_lump

  #
  # ibsp (quake 2, quake 3)
  #

  # lump directory

  ibsp_directory_t:
    seq:
      - id: bsp_file_version
        type: u4
        enum: ibsp_subversions
      - id: bsp_lumps
        type: bsp_lump_t
        repeat: expr
        repeat-expr: num_lumps
    instances:
      num_lumps:
        value: 'bsp_file_version == ibsp_subversions::quake2 ? 19 : 17' 

  #
  # vbsp (source engine)
  #

  # lump directory

  vbsp_directory_t:
    seq:
      - id: bsp_file_version
        type: u4
        enum: vbsp_subversions
      - id: bsp_lumps
        type: vbsp_lump_t
        repeat: expr
        repeat-expr: num_lumps
      - id: bsp_file_revision
        type: u4
    instances:
      num_lumps:
        value: 64

  # lump

  vbsp_lump_t:
    seq:
      - id: ofs_lump
        type: u4
      - id: len_lump
        type: u4
      - id: version
        type: u4
      - id: identifier
        type: str
        encoding: ascii
        size: 4
    instances:
      get_lump_data:
        pos: ofs_lump
        size: len_lump

  #
  # helpers
  #

  # 3-point vector (short)

  vec3s_t:
    seq:
      - id: x
        type: s2
      - id: y
        type: s2
      - id: z
        type: s2

  # 3-point vector (float)

  vec3f_t:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4

enums:

  #
  # bsp version enums
  #

  bsp_versions:
    23: bsp23 # qtest
    28: bsp28 # quake beta 3
    29: bsp29 # quake
    30: bsp30 # half-life 
    0x32505342: bsp2 # quake bsp2
    0x42535032: bsp2rmq # quake 2psb
    0x50534249: ibsp # quake 2, quake 3
    0x50534256: vbsp # source engine
    0x51363420: q64 # quake 64
    0x58505342: bspx # quake bspx

  ibsp_subversions:
    38: quake2 # quake 2
    46: quake3 # quake 3

  vbsp_subversions:
    17: vtmb # vampire the masquerade - bloodlines
    18: hl2leak # half-life 2 leak
    19: hl2retail # half-life 2 retail
    20: orangebox # orange box and left 4 dead 1
    21: portal2 # portal 2, left 4 dead 2, csgo
    22: dota2beta # dota 2 beta versions
    23: dota2 # dota 2 retail
    27: contagion # contagion
    29: titanfall # titanfall

  #
  # bsp lump index enums
  #

  # bsp versions 28-29-30 (quake beta 3, quake and half-life)

  bsp_lump_index:
    0: entities
    1: planes
    2: textures
    3: vertices
    4: visibility
    5: nodes
    6: texture_info
    7: faces
    8: lightmaps
    9: clipnodes
    10: leafs
    11: faces_list
    12: edges
    13: edges_list
    14: brush_models

  # ibsp version 38 (quake 2)

  ibsp_lump_index_quake2:
    0: entities
    1: planes
    2: vertices
    3: visibility
    4: nodes
    5: texture_info
    6: faces
    7: lightmaps
    8: leafs
    9: leaf_faces
    10: leaf_brushes
    11: edges
    12: edges_faces
    13: brush_models
    14: brushes
    15: brush_sides
    16: pop
    17: areas
    18: area_portals

  # ibsp version 46 (quake 3)

  ibsp_lump_index_quake3:
    0: entities
    1: texture_info
    2: planes
    3: nodes
    4: leafs
    5: leaf_faces
    6: leaf_brushes
    7: brush_models
    8: brushes
    9: brush_sides
    10: vertices
    11: vertices_list
    12: effects
    13: faces
    14: lightmaps
    15: light_volumes
    16: visibility
