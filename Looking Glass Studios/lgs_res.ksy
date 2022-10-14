meta:
  id: lgs_res
  file-extension: res
  endian: le
  bit-endian: le

doc-ref: LIBSRC/RES/RES.H
doc: |
  Looking Glass Studios resource file v2, found in Thief 2.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: header
    type: header_t

types:
  header_t:
    seq:
      - id: magic
        contents: [LG Res File v2, 0x0d, 0x0a]
      - id: comment
        type: str
        encoding: ascii
        size: 96
      - id: reserved
        size: 12
      - id: ofs_directory
        type: s4

  directory_t:
    seq:
      - id: num_entries
        type: u2
      - id: ofs_data
        type: s4
      - id: entries
        type: directory_entry_t
        repeat: expr
        repeat-expr: num_entries

  directory_entry_t:
    seq:
      - id: resource_id
        type: u2
      - id: size_uncompressed
        type: u2
      - id: resource_flags
        type: u2
      - id: size_compressed
        type: u2
      - id: resource_type
        type: s2

instances:
  get_file_directory:
    pos: _root.header.ofs_directory
    type: directory_t
