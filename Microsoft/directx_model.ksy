meta:
  id: directx_model
  file-extension: x
  endian: le
  bit-endian: le

doc-ref: https://learn.microsoft.com/en-us/windows/win32/direct3d9/dx9-graphics-reference-x-file-format
doc: |
  The "X" model format used by various DirectX games and tools from the late 1990s,
  including Wild Ride: Surf Shack (the source of my test data). It's essentially
  a binary version of a simple tokenized text format. There's also a text
  version of the X model format, naturally, but I haven't looked into that.

  Origin of this file: https://github.com/JaycieErysdren/Formats

seq:
  - id: header
    type: header_t
  - id: tokens
    type: token_t
    repeat: eos

types:
  header_t:
    seq:
      - id: magic
        contents: [0x78, 0x6f, 0x66, 0x20]
      - id: version_major
        type: str
        encoding: ascii
        size: 2
      - id: version_minor
        type: str
        encoding: ascii
        size: 2
      - id: file_type
        type: str
        encoding: ascii
        size: 4
      - id: float_size
        type: str
        encoding: ascii
        size: 4

  token_t:
    seq:
      - id: token_type
        type: s2
      - id: token_data
        type:
          switch-on: token_type
          cases:
            1: token_name_t # TOKEN_NAME
            2: token_string_t # TOKEN_STRING
            3: token_integer_t # TOKEN_INTEGER
            5: token_guid_t # TOKEN_GUID
            6: token_integer_list_t # TOKEN_INTEGER_LIST
            7: token_float_list_t # TOKEN_FLOAT_LIST
            _: token_no_record_t

  #
  # record-bearing tokens
  #

  # TOKEN_NAME - 1
  token_name_t:
    seq:
      - id: len_name
        type: s4
      - id: name
        type: str
        encoding: ascii
        size: len_name

  # TOKEN_STRING - 2
  token_string_t:
    seq:
      - id: len_string
        type: s4
      - id: string
        type: str
        encoding: ascii
        size: len_string
      - id: terminator
        type: s2

  # TOKEN_INTEGER - 3
  token_integer_t:
    seq:
      - id: value
        type: s4

  # TOKEN_GUID - 5
  token_guid_t:
    seq:
      - id: data1
        type: s4
      - id: data2
        type: s2
      - id: data3
        type: s2
      - id: data4
        size: 8

  # TOKEN_INTEGER_LIST - 6
  token_integer_list_t:
    seq:
      - id: num_integers
        type: s4
      - id: integers
        type: s4
        repeat: expr
        repeat-expr: num_integers

  # TOKEN_FLOAT_LIST - 7
  token_float_list_t:
    seq:
      - id: num_floats
        type: s4
      - id: floats32
        type: f4
        repeat: expr
        repeat-expr: num_floats
        if: _root.header.float_size == '0032'
      - id: floats64
        type: f4
        repeat: expr
        repeat-expr: num_floats
        if: _root.header.float_size == '0064'

  #
  # non-record-bearing tokens
  #

  token_no_record_t:
    seq:
      - id: none
        size: 0
