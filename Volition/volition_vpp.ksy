meta:
    id: volition_vpp
    file-extension: vpp_pc
    endian: le
    bit-endian: le

doc: Volition VPP
doc-ref: https://github.com/gibbed/Gibbed.Volition/tree/master/projects/Gibbed.Volition.FileFormats

seq:
  - id: magic
    contents: [0xce, 0x0a, 0x89, 0x51]
  - id: version
    type: u4
  - id: header
    type:
      switch-on: version
      cases:
        3: headerv3_t
  - id: directories
    size: 2048
    type: directories_t
  - id: names
    type: names_t
    size: 2048
  - id: data
    type: data_t
    size-eos: true

types:
  headerv3_t:
    seq:
      - id: name
        type: str
        size: 65
        encoding: ascii
      - id: path
        type: str
        size: 256
        encoding: ascii
      - id: padding1
        size: 3
      - id: flags
        type: u4
      - id: un1
        type: u4
      - id: num_directories
        type: u4
      - id: len_package
        type: u4
      - id: len_directories
        type: u4
      - id: len_names
        type: u4
      - id: uncompressed_size
        type: u4
      - id: compressed_size
        type: u4
      - id: ptr_directories
        type: u4
      - id: ptr_names
        type: u4
      - id: ptr_data
        type: u4
      - id: padding2
        size: 1672

  data_t:
    seq:
      - id: data
        size-eos: true

  names_t:
    seq:
      - id: data
        size: _root.header.len_names

  directories_t:
    seq:
      - id: entries
        type: directory_t
        repeat: expr
        repeat-expr: _root.header.num_directories

  directory_t:
    seq:
      - id: ofs_name
        type: u4
      - id: ofs_runtime
        type: u4
      - id: ofs_data
        type: u4
      - id: name_hash
        type: u4
      - id: uncompressed_size
        type: u4
      - id: compressed_size
        type: u4
      - id: ptr_package
        type: u4
    instances:
      data:
        pos: ofs_data
        io: _root.data._io
        size: uncompressed_size
      name:
        pos: ofs_name
        io: _root.names._io
        type: strz
        encoding: ascii