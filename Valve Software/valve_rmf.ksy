meta:
    id: valve_rmf
    file-extension: rmf
    endian: le
    bit-endian: le

doc: Valve Software VPK (versions 1 and 2)
doc-ref: src_main/worldcraft/mapdoc.cpp

# https://developer.valvesoftware.com/wiki/Rich_Map_Format

seq:
  - id: version
    type: f4
  - id: identifier
    type: str
    size: 3
    encoding: ascii
  - id: num_visgroups
    type: u4
  - id: visgroups
    type: visgroup_t
    repeat: expr
    repeat-expr: num_visgroups
  - id: world
    type: world_t
  - id: docinfo
    type: docinfo_t

types:
  color_t:
    seq:
      - id: r
        type: u1
      - id: g
        type: u1
      - id: b
        type: u1

  visgroup_t:
    seq:
      - id: name
        type: strz
        size: 128
        encoding: ascii
      - id: color
        type: color_t
      - id: padding1
        size: 1
      - id: index
        type: u4
      - id: visibility
        type: u1
      - id: padding2
        size: 3

  docinfo_t:
    seq:
      - id: identifier
        type: str
        size: 8
        encoding: ascii
      - id: camera_version
        type: f4
      - id: active_camera_index
        type: u4
      - id: num_cameras
        type: u4
      - id: cameras
        type: camera_t
        repeat: expr
        repeat-expr: num_cameras

  camera_t:
    seq:
      - id: eye_pos
        type: f4
        repeat: expr
        repeat-expr: 3
      - id: look_pos
        type: f4
        repeat: expr
        repeat-expr: 3

  world_t:
    seq:
      - id: len_identifier
        type: u1
      - id: identifier
        type: strz
        encoding: ascii
        size: len_identifier
      - id: un1
        size: 7
      - id: num_objects
        type: u4
      - id: objects
        type: object_t
        repeat: expr
        repeat-expr: num_objects
      - id: len_classname
        type: u1
      - id: classname
        type: strz
        encoding: ascii
        size: len_classname
      - id: un2
        size: 4
      - id: flags
        type: u4
      - id: num_key_value_pairs
        type: u4
      - id: key_value_pairs
        type: c_map_key_value_pair
        repeat: expr
        repeat-expr: num_key_value_pairs
      - id: un3
        size: 12
      - id: num_paths
        type: u4
      - id: paths
        type: path_t
        repeat: expr
        repeat-expr: num_paths

  object_t:
    seq:
      - id: len_identifier
        type: u1
      - id: identifier
        type: strz
        encoding: ascii
        size: len_identifier
      - id: data
        type:
          switch-on: identifier
          cases:
            "'CMapSolid'": c_map_solid_t
            "'CMapEntity'": c_map_entity_t
            "'CMapGroup'": c_map_group_t

  path_t:
    seq:
      - id: name
        type: strz
        size: 128
        encoding: ascii
      - id: classname
        type: strz
        size: 128
        encoding: ascii
      - id: type
        type: u4
      - id: num_corners
        type: u4
      - id: corners
        type: corner_t
        repeat: expr
        repeat-expr: num_corners

  corner_t:
    seq:
      - id: coords
        type: f4
        repeat: expr
        repeat-expr: 3
      - id: index
        type: u4
      - id: name
        type: strz
        size: 128
        encoding: ascii
      - id: num_key_value_pairs
        type: u4
      - id: key_value_pairs
        type: c_map_key_value_pair
        repeat: expr
        repeat-expr: num_key_value_pairs

  c_map_key_value_pair:
    seq:
      - id: len_key
        type: u1
      - id: key
        type: strz
        encoding: ascii
        size: len_key
      - id: len_value
        type: u1
      - id: value
        type: strz
        encoding: ascii
        size: len_value

  c_map_entity_t:
    seq:
      - id: visgroup_index
        type: u4
      - id: color
        type: color_t
      - id: num_objects
        type: u4
      - id: objects
        type: object_t
        repeat: expr
        repeat-expr: num_objects
      - id: len_classname
        type: u1
      - id: classname
        type: strz
        encoding: ascii
        size: len_classname
      - id: un1
        size: 4
      - id: flags
        type: u4
      - id: num_key_value_pairs
        type: u4
      - id: key_value_pairs
        type: c_map_key_value_pair
        repeat: expr
        repeat-expr: num_key_value_pairs
      - id: un2
        size: 30

  c_map_solid_t:
    seq:
      - id: visgroup_index
        type: u4
      - id: color
        type: color_t
      - id: un1
        size: 4
      - id: num_faces
        type: u4
      - id: faces
        type: c_map_face_t
        repeat: expr
        repeat-expr: num_faces

  c_map_vertex_t:
    seq:
      - id: coords
        type: f4
        repeat: expr
        repeat-expr: 3

  c_map_texture_21_t:
    seq:
      - id: texture_name
        type: strz
        size: 256
        encoding: ascii
      - id: rotation
        type: f4
      - id: un1
        type: f4
      - id: shift
        type: f4
        repeat: expr
        repeat-expr: 2
      - id: scale
        type: f4
        repeat: expr
        repeat-expr: 2
      - id: unknown
        size: 16

  c_map_texture_33_t:
    seq:
      - id: texture_name
        type: strz
        size: 256
        encoding: ascii
      - id: un1
        type: f4
      - id: u
        type: f4
        repeat: expr
        repeat-expr: 3
      - id: shift_x
        type: f4
      - id: v
        type: f4
        repeat: expr
        repeat-expr: 3
      - id: shift_y
        type: f4
      - id: rotation
        type: f4
      - id: scale
        type: f4
        repeat: expr
        repeat-expr: 2
      - id: un2
        size: 16

  c_map_group_t:
    seq:
      - id: visgroup_index
        type: u4
      - id: color
        type: color_t
      - id: num_objects
        type: u4
      - id: objects
        type: object_t
        repeat: expr
        repeat-expr: num_objects

  c_map_face_t:
    seq:
      - id: tex_info_21
        type: c_map_texture_21_t
        if: _root.version < 2.2
      - id: tex_info_33
        type: c_map_texture_33_t
        if: _root.version > 2.1
      - id: num_vertices
        type: u4
      - id: vertices
        type: c_map_vertex_t
        repeat: expr
        repeat-expr: num_vertices
      - id: plane
        type: c_map_vertex_t
        repeat: expr
        repeat-expr: 3