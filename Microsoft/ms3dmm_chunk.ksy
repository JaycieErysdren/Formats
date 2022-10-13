meta:
    id: ms3dmm_chunk
    file-extension: 3dmm
    endian: le
    bit-endian: le

doc: Microsoft 3D Movie Maker Chunk File.
doc-ref: https://github.com/foone/lib3dmm/blob/master/lib3dmm.py

seq:
  - id: file_header
    type: file_header_t
  - id: chunk_data
    type: chunk_data_t
    size: file_header.ofs_file_index - 128
  - id: file_index
    type: file_index_t
  - id: chunks
    type: chunks_t
    size: _root.file_index.len_chunks
  - id: chunk_index
    type: chunk_index_t
    repeat: expr
    repeat-expr: file_index.num_chunks

types:
  file_header_t:
    seq:
      - id: magic
        contents: [0x43, 0x48, 0x4e, 0x32] # "CHN2" in ASCII
      - id: author_program
        type: str
        encoding: ASCII
        size: 4
      - id: chunk_version_current
        type: u2
      - id: chunk_version_minimum
        type: u2
      - id: byte_order
        type: u2
      - id: author_system
        type: u2
      - id: len_file
        type: u4
      - id: ofs_file_index
        type: u4
      - id: len_file_index
        type: u4
      - id: ofs_free_space_map
        type: u4
      - id: len_free_space_map
        type: u4
      - id: reserved
        type: u4
        repeat: expr
        repeat-expr: 23

  file_index_t:
    seq:
      - id: byte_order
        type: u2
      - id: author_system
        type: u2
      - id: num_chunks
        type: u4
      - id: len_chunks
        type: u4
      - id: un1
        type: s4
      - id: un2
        type: s4

  chunk_data_t:
    seq:
      - id: data
        type: u1
        repeat: eos

  chunks_t:
    seq:
      - id: data
        size-eos: true

  chunk_t:
    seq:
      - id: author_program
        type: str
        encoding: ASCII
        size: 4
      - id: chunk_number
        type: u4
      - id: ofs_chunk_data
        type: u4
      - id: grfcrp
        type: b8
      - id: len_chunk_data
        type: b24
      - id: num_owned_chunks
        type: u2
      - id: num_owner_chunks
        type: u2
      - id: remaining_data
        size-eos: true
    instances:
      chunk_data:
        io: _root._io
        pos: ofs_chunk_data
        size: len_chunk_data
        type: chunk_data_t

  chunk_index_t:
    seq:
      - id: ofs_chunk
        type: u4
      - id: len_chunk
        type: u4
    instances:
      chunk:
        io: _root.chunks._io
        pos: ofs_chunk
        size: len_chunk
        type: chunk_t