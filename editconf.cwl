cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, editconf, -nobackup]

inputs:
  in_structure:
    type: File
    format: [gromacs:pdb, gromacs:gro]
    inputBinding:
      prefix: -f
  out_structure:
    type: string
    inputBinding:
      prefix: -o
    default: structure.gro
  distance_to_box_edge:
    type: float
    inputBinding:
      prefix: -d
  center:
    type: boolean
    inputBinding:
      prefix: -c
  box_type:
    type:
        type: enum
        symbols:
          - triclinic
          - cubic
          - dodecahedron
          - octahedron 
    inputBinding:
      prefix: -bt

outputs:
  out_structure:
    type: File
    format: gromacs:gro
    outputBinding:
      glob: $(inputs.out_structure)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html