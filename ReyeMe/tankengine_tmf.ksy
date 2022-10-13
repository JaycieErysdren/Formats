meta:
  id: tankengine_tmf
  file-extension: tmf
  endian: be
  bit-endian: be

seq:
  - id: header
    type: header_t
  - id: textures
    type: texture_t
    repeat: expr
    repeat-expr: header.num_textures
  - id: meshes
    type: mesh_t
    repeat: expr
    repeat-expr: header.num_meshes

types:
  header_t:
    seq:
      - id: type
        type: s1
      - id: num_textures
        type: s1
      - id: num_meshes
        type: s1
      - id: reserved
        type: s1
        repeat: expr
        repeat-expr: 5

  texture_t:
    seq:
      - id: filename
        type: str
        size: 13
        encoding: ASCII
      - id: color
        type: s1
        repeat: expr
        repeat-expr: 3

  mesh_t:
    seq:
      - id: header
        type: mesh_header_t
      - id: vertices
        type: vertex_t
        repeat: expr
        repeat-expr: header.num_vertices
      - id: quads
        type: quad_t
        repeat: expr
        repeat-expr: header.num_quads

  vertex_t:
    seq:
      - id: coords
        type: s4
        repeat: expr
        repeat-expr: 3

  quad_t:
    seq:
      - id: normal
        type: s4
        repeat: expr
        repeat-expr: 3
      - id: vertex_indices
        type: u2
        repeat: expr
        repeat-expr: 4
      - id: flags
        type: u1
      - id: texture_id
        type: u1
      - id: reserved
        type: u1
        repeat: expr
        repeat-expr: 2

  mesh_header_t:
    seq:
      - id: num_vertices
        type: u2
      - id: num_quads
        type: u2
