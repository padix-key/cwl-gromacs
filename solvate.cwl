cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, solvate, -nobackup]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.in_topology)
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
  in_topology:
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
  out_topology:
    type: File
    format: gromacs:top
    outputBinding:
      glob: $(inputs.in_topology.basename)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html