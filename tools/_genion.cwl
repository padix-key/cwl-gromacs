cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, genion, -nobackup, -quiet]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.topology)
        writable: true


inputs:
  runnable:
    type: File
    format: gromacs:tpr
    inputBinding:
      prefix: -s
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
  concentration:
    type: float?
    inputBinding:
      prefix: -conc
  neutral:
    type: boolean
    inputBinding:
      prefix: -neutral
    default: true
  cations:
    type: string
    inputBinding:
        prefix: -pname
    default: NA
  anions:
    type: string
    inputBinding:
      prefix: -nname
    default: CL
  group:
    type: File


outputs:
  structure:
    type: File
    format: gromacs:gro
    outputBinding:
      glob: $(inputs.out_structure)
  topology:
    type: File
    format: gromacs:top
    outputBinding:
      glob: $(inputs.topology.basename)


stdin:
  $(inputs.group.path)


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html