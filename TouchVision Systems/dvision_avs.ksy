meta:
  id: dvision_avs
  file-extension: avs
  endian: le
  bit-endian: le

seq:
  - id: magic
    type: magic_t

types:
  magic_t:
    seq:
      - id: identifier
        contents: 'IVDV' #VDVI - V-DVision?
      - id: unknown1
        contents: [0xc, 0x0, 0x1, 0x0]
      - id: unknown2
        contents: [0x0, 0x0, 0x0, 0x0]
      - id: identifier2
        contents: 'SSVA' # AVSS - AVS(?)
