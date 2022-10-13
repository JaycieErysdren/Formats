meta:
  id: id_pak
  file-extension: pak
  endian: le
  bit-endian: le

doc-ref: https://quakewiki.org/wiki/.pak
doc: |
  id Software packfile version 1, used by Quake. A simple table
  of files, stored uncompressed.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: header
    type: header_t

types:
  header_t:
    seq:
      - id: magic
        contents: "PACK"
      - id: ofs_file_table
        type: u4
      - id: len_file_table
        type: u4

  file_table_t:
    seq:
      - id: filepath
        type: str
        terminator: 0
        encoding: ASCII
    instances:
      ofs_file_data:
        pos: 56
        type: u4
      len_file_data:
        pos: 60
        type: u4
    #instances:
    #  get_file_data:
    #    pos: ofs_file_data
    #    size: len_file_data

instances:
  get_file_table:
    pos: header.ofs_file_table
    type: file_table_t
    size: 64
    repeat: expr
    repeat-expr: header.len_file_table / 64