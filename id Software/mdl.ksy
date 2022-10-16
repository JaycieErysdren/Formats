meta:
  id: mdl
  file-extension: mdl
  endian: le
  bit-endian: le

doc-ref: |
  http://tfc.duke.free.fr/coding/mdl-specs-en.html
  http://tfc.duke.free.fr/coding/md2-specs-en.html

doc: |
  Quake's Model format. Currently only supports QTest and Quake
  retail iterations.

  Special thanks to Spoike for helping with framegroups.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: mdl_magic
    type: u4
    enum: mdl_magics
  - id: mdl_version
    type: u4
    enum: mdl_versions
  - id: mdl_data
    type:
      switch-on: mdl_version
      cases:
        'mdl_versions::qtest': mdl_data_t
        'mdl_versions::quake': mdl_data_t
        'mdl_versions::quake2': md2_data_t

types:

  #
  # mdl versions 3-6 (qtest, quake)
  #

  # data block

  mdl_data_t:
    seq:
      - id: mdl_header
        type: mdl_header_t
      - id: mdl_skins
        type: mdl_skin_t
        repeat: expr
        repeat-expr: mdl_header.num_skins
      - id: mdl_texcoords
        type: mdl_texcoord_t
        repeat: expr
        repeat-expr: mdl_header.num_vertices
      - id: mdl_faces
        type: mdl_face_t
        repeat: expr
        repeat-expr: mdl_header.num_faces
      - id: mdl_frames
        type: mdl_frame_t
        repeat: expr
        repeat-expr: mdl_header.num_frames

  # header

  mdl_header_t:
    seq:
      - id: scale
        type: vec3f_t
      - id: translation
        type: vec3f_t
      - id: bounding_radius
        type: f4
      - id: eye_position
        type: vec3f_t
      - id: num_skins
        type: u4
      - id: skin_width
        type: u4
      - id: skin_height
        type: u4
      - id: num_vertices
        type: u4
      - id: num_faces
        type: u4
      - id: num_frames
        type: u4
      - id: sync_type
        type: u4
      - id: flags
        type: u4
        if: '_parent._parent.mdl_version != mdl_versions::qtest'
      - id: size
        type: f4
        if: '_parent._parent.mdl_version != mdl_versions::qtest'

  # skin

  mdl_skin_t:
    seq:
      - id: skin_type
        type: u4
        enum: mdl_skin_types
      - id: num_frames
        type: u4
        if: skin_type == mdl_skin_types::group
      - id: duration_frames
        type: f4
        repeat: expr
        repeat-expr: num_frames
        if: skin_type == mdl_skin_types::group
      - id: frames
        type: mdl_skin_pixels_t
        repeat: expr
        repeat-expr: 'skin_type == mdl_skin_types::group ? num_frames : 1'

  # skin pixels

  mdl_skin_pixels_t:
    seq:
      - id: pixels
        type: u1
        repeat: expr
        repeat-expr: _parent._parent.mdl_header.skin_width * _parent._parent.mdl_header.skin_height

  # texture coordinate

  mdl_texcoord_t:
    seq:
      - id: onseam
        type: s4
      - id: s
        type: s4
      - id: t
        type: s4

  # face

  mdl_face_t:
    seq:
      - id: face_type
        type: u4
        enum: mdl_face_types
      - id: vertex_indices
        type: u4
        repeat: expr
        repeat-expr: 3

  # vertex

  mdl_vertex_t:
    seq:
      - id: coordinates
        type: u1
        repeat: expr
        repeat-expr: 3
      - id: normal_index
        type: u1

  # frame data

  mdl_frame_data_t:
    seq:
      - id: min
        type: mdl_vertex_t
      - id: max
        type: mdl_vertex_t
      - id: name
        type: strz
        encoding: ascii
        size: 16
        if: '_parent._parent._parent.mdl_version == mdl_versions::quake'
      - id: vertices
        type: mdl_vertex_t
        repeat: expr
        repeat-expr: _parent._parent.mdl_header.num_vertices

  # frame container / framegroup

  mdl_frame_t:
    seq:
      - id: frame_type
        type: u4
        enum: mdl_frame_types
      - id: num_frames
        type: u4
        if: is_frame_group
      - id: min
        type: mdl_vertex_t
        if: is_frame_group
      - id: max
        type: mdl_vertex_t
        if: is_frame_group
      - id: duration_frames
        type: f4
        repeat: expr
        repeat-expr: num_frames
        if: is_frame_group
      - id: frames
        type: mdl_frame_data_t
        repeat: expr
        repeat-expr: 'is_frame_group ? num_frames : 1'
    instances:
      is_frame_group:
        value: frame_type == mdl_frame_types::group

  #
  # md2 version 8 (quake 2)
  #

  # data block

  md2_data_t:
    seq:
      - id: mdl_header
        type: md2_header_t
    instances:
      mdl_skins:
        pos: mdl_header.ofs_skins
        type: md2_skin_t
        repeat: expr
        repeat-expr: mdl_header.num_skins
      mdl_texcoords:
        pos: mdl_header.ofs_texcoords
        type: md2_texcoord_t
        repeat: expr
        repeat-expr: mdl_header.num_texcoords
      mdl_frames:
        pos: mdl_header.ofs_frames
        type: md2_frame_t
        repeat: expr
        repeat-expr: mdl_header.num_frames
      mdl_faces:
        pos: mdl_header.ofs_faces
        type: md2_face_t
        repeat: expr
        repeat-expr: mdl_header.num_faces
      mdl_opengl_commands:
        pos: mdl_header.ofs_opengl_commands
        type: u4
        repeat: expr
        repeat-expr: mdl_header.num_opengl_commands

  # header

  md2_header_t:
    seq:
      - id: skin_width
        type: u4
      - id: skin_height
        type: u4
      - id: len_frame
        type: u4
      - id: num_skins
        type: u4
      - id: num_vertices
        type: u4
      - id: num_texcoords
        type: u4
      - id: num_faces
        type: u4
      - id: num_opengl_commands
        type: u4
      - id: num_frames
        type: u4
      - id: ofs_skins
        type: u4
      - id: ofs_texcoords
        type: u4
      - id: ofs_faces
        type: u4
      - id: ofs_frames
        type: u4
      - id: ofs_opengl_commands
        type: u4
      - id: ofs_eof
        type: u4

  # skin

  md2_skin_t:
    seq:
      - id: filename
        type: strz
        encoding: ascii
        size: 64

  # texture coordinate

  md2_texcoord_t:
    seq:
      - id: s
        type: s2
      - id: t
        type: s2

  # face

  md2_face_t:
    seq:
      - id: vertex_indices
        type: u2
        repeat: expr
        repeat-expr: 3
      - id: texcoord_indices
        type: u2
        repeat: expr
        repeat-expr: 3

  # frame

  md2_frame_t:
    seq:
      - id: scale
        type: vec3f_t
      - id: translation
        type: vec3f_t
      - id: name
        type: strz
        encoding: ascii
        size: 16
      - id: vertices
        type: mdl_vertex_t
        repeat: expr
        repeat-expr: _parent.mdl_header.num_vertices

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
  # mdl enums
  #

  # magics

  mdl_magics:
    0x4f504449: quake # quake
    0x32504449: quake2 # quake 2

  # versions

  mdl_versions:
    3: qtest # qtest
    6: quake # quake
    8: quake2 # quake 2

  # skin types

  mdl_skin_types:
    0: single
    1: group

  # face types

  mdl_face_types:
    0: backface
    1: frontface

  # frame types

  mdl_frame_types:
    0: single
    1: group
