meta:
  id: pak
  file-extension: pak
  endian: le
  bit-endian: le

doc-ref: https://quakewiki.org/wiki/.pak
doc: |
  id Software packfile version 1, used by Quake. A simple table
  of files, stored uncompressed.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: pak_header
    type: pak_header_t

types:
  pak_header_t:
    seq:
      - id: magic
        contents: "PACK"
      - id: ofs_file_table
        type: u4
      - id: len_file_table
        type: u4

  pak_file_table_entry_t:
    seq:
      - id: filepath
        type: strz
        size: 56
        encoding: ascii
      - id: ofs_file_data
        type: u4
      - id: len_file_data
        type: u4
    instances:
      get_file_data:
        io: _root._io
        pos: ofs_file_data
        size: len_file_data

instances:
  pak_file_table_entry_size:
    value: 64

  pak_file_table:
    pos: pak_header.ofs_file_table
    type: pak_file_table_entry_t
    size: pak_file_table_entry_size
    repeat: expr
    repeat-expr: pak_header.len_file_table / pak_file_table_entry_size
