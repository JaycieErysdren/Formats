meta:
  id: build_grp
  file-extension: grp
  endian: le
  bit-endian: le

doc-ref: https://moddingwiki.shikadi.net/wiki/GRP_Format
doc: |
  BUILD engine GRP file. A basic uncompressed storage format
  that can store any kind of file with an 8.3 filename or less.
  Needs information on how to access files at specific offsets.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: grp_header
    type: grp_header_t
  - id: grp_file_index
    type: grp_file_index_entry_t
    repeat: expr
    repeat-expr: grp_header.num_files

types:
  grp_header_t:
    seq:
      - id: signature
        contents: "KenSilverman"
      - id: num_files
        type: u4

  grp_file_index_entry_t:
    seq:
      - id: filename
        type: strz
        encoding: ascii
        size: 12
      - id: len_file
        type: u4
