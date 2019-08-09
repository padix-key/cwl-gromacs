class: Workflow
cwlVersion: v1.0
id: basic_simulation
label: Basic simulation
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: in_structure
    type: File
    'sbg:x': -255.99615478515625
    'sbg:y': -131
  - id: force_field
    type: string
    'sbg:exposed': true
  - id: water_model
    type:
      - 'null'
      - type: enum
        symbols:
          - none
          - spc
          - spce
          - tip3p
          - tip4p
          - tip5p
          - tips3p
        name: water_model
    'sbg:exposed': true
  - id: out_structure
    type: string
    'sbg:exposed': true
outputs:
  - id: out_topology
    outputSource:
      - solvate/out_topology
    type: File
    'sbg:x': 706.5
    'sbg:y': -268.5
  - id: out_structure
    outputSource:
      - solvate/out_structure
    type: File
    'sbg:x': 712.5
    'sbg:y': -57.5
steps:
  - id: pdb2gmx
    in:
      - id: force_field
        default: oplsaa
        source: force_field
      - id: in_structure
        source: in_structure
      - id: water_model
        default: spce
        source: water_model
    out:
      - id: out_structure
      - id: out_topology
    run: ./pdb2gmx.cwl
    'sbg:x': -90
    'sbg:y': -131.5
  - id: editconf
    in:
      - id: box_type
        default: cubic
      - id: center
        default: true
      - id: distance_to_box_edge
        default: 1
      - id: in_structure
        source: pdb2gmx/out_structure
    out:
      - id: out_structure
    run: ./editconf.cwl
    'sbg:x': 198
    'sbg:y': -54
  - id: solvate
    in:
      - id: in_structure
        source: editconf/out_structure
      - id: in_topology
        source: pdb2gmx/out_topology
      - id: out_structure
        source: out_structure
    out:
      - id: out_structure
      - id: out_topology
    run: ./solvate.cwl
    'sbg:x': 481.5
    'sbg:y': -153.5
requirements: []
