meta:
    id: descent_hog
    file-extension: hog
    endian: le
    bit-endian: le

seq:
  - id: magic
    contents: "DHF"
  - id: chunks
    type: chunk_t
    repeat: eos

types:
  chunk_t:
    seq:
      - id: name
        type: strz
        encoding: ascii
        size: 13
      - id: len_data
        type: u4
      - id: data
        size: len_data