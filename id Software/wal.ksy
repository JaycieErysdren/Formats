meta:
  id: wal
  file-extension: wal
  endian: le
  bit-endian: le

doc-ref: |
  https://www.flipcode.com/archives/Quake_2_BSP_File_Format.shtml

doc: |
  Quake 2's texture format. Stores an array of indexes into the
  global game palette, as well as some basic information about
  width, height and game information (i.e. flags and surface contents).

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: name
    type: str
    encoding: ascii
    terminator: 0
    size: 32
  - id: width
    type: u4
  - id: height
    type: u4
  - id: mipmap_offsets
    type: s4
    repeat: expr
    repeat-expr: 4
  - id: next_name
    type: str
    encoding: ascii
    size: 32
  - id: flags
    type: u4
  - id: contents
    type: u4
  - id: value
    type: u4

instances:
  pixels_mip_0:
    pos: mipmap_offsets[0]
    type: u1
    repeat: expr
    repeat-expr: mipmap_offsets[1] - mipmap_offsets[0]

  pixels_mip_1:
    pos: mipmap_offsets[1]
    type: u1
    repeat: expr
    repeat-expr: mipmap_offsets[2] - mipmap_offsets[1]

  pixels_mip_2:
    pos: mipmap_offsets[2]
    type: u1
    repeat: expr
    repeat-expr: mipmap_offsets[3] - mipmap_offsets[2]

  pixels_mip_3:
    pos: mipmap_offsets[3]
    type: u1
    repeat: eos
