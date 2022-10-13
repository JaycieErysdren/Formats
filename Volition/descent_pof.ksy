meta:
    id: descent_pof
    file-extension: pof
    endian: le
    bit-endian: le

seq:
  - id: magic
    contents: 'PSPO'
  - id: version
    type: u2
  - id: chunks
    type: pof_chunk_t
    repeat: eos

types:
  pof_chunk_t:
    seq:
      - id: identifier
        type: str
        size: 4
        encoding: ascii
      - id: len_data
        type: u4
      - id: data
        type:
          switch-on: identifier
          cases:
            "'TXTR'": pof_textures_t # texture filename list
            "'OHDR'": pof_object_header_t # object header
            "'SOBJ'": pof_sub_object_header_t # subobject header
            "'GUNS'": pof_guns_t # guns list
            "'ANIM'": pof_animations_t # animations index
            "'IDTA'": pof_idta_t # interpreter data

  pof_textures_t:
    seq:
      - id: num_textures
        type: u2
      - id: textures
        type: strz
        encoding: ascii
        repeat: expr
        repeat-expr: num_textures

  pof_object_header_t:
    seq:
      - id: num_models
        type: u4
      - id: radius
        type: u4
      - id: min_sizes
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: max_size
        type: u4
        repeat: expr
        repeat-expr: 3

  pof_sub_object_header_t:
    seq:
      - id: index
        type: u2
      - id: parents
        type: u2
      - id: normals
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: points
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: radius
        type: u4
      - id: ofs_data
        type: u4
    instances:
      get:
        io: _root.chunks[-1]._io
        pos: ofs_data
        size: 4

  pof_guns_t:
    seq:
      - id: num_guns
        type: u4
      - id: guns
        type: pof_gun_t
        repeat: expr
        repeat-expr: num_guns

  pof_gun_t:
    seq:
      - id: id
        type: u2
      - id: submodel
        type: u2
      - id: points
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: direction
        if: _root.version >= 7
        type: u4
        repeat: expr
        repeat-expr: 3

  pof_animations_t:
    seq:
      - id: num_frames
        type: u2
      - id: model_animations
        type: pof_model_animation_t
        repeat: expr
        repeat-expr: _root.chunks[1].data.as<pof_object_header_t>.num_models
        # ^ this probably isn't reliable in every case

  pof_model_animation_t:
    seq:
      - id: frames
        size: 6
        repeat: expr
        repeat-expr: _parent.num_frames

  pof_idta_t:
    seq:
      - id: data
        size-eos: true