cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, solvate, -nobackup]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.topology)
        writable: true


inputs:
  in_structure:
    type: File
    format: [gromacs:pdb, gromacs:gro]
    inputBinding:
      prefix: -cp
  out_structure:
    type: string
    inputBinding:
      prefix: -o
    default: structure.gro
  topology:
    type: File
    format: gromacs:top
    inputBinding:
      prefix: -p
      valueFrom: $(self.basename)
  water_structure:
    type: File?
    format: [gromacs:pdb, gromacs:gro]
    inputBinding:
      prefix: -cs
  

outputs:
  out_structure:
    type: File
    format: gromacs:gro
    outputBinding:
      glob: $(inputs.out_structure)
  topology:
    type: File
    format: gromacs:top
    outputBinding:
      glob: $(inputs.topology.basename)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html