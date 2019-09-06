cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, grompp, -nobackup, -quiet]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.topology)
        writable: true
      - entry: $(inputs.restraint_potentials)


inputs:
  parameters:
    type: File
    format: gromacs:mdp
    inputBinding:
      prefix: -f
  topology:
    type: File
    format: gromacs:top
    inputBinding:
      prefix: -p
      valueFrom: $(self.basename)
  structure:
    type: File
    format: [gromacs:pdb, gromacs:gro]
    inputBinding:
      prefix: -c
  restraints:
    type: File?
    format: [gromacs:pdb, gromacs:gro, gromacs:tpr]
    inputBinding:
      prefix: -r
  restraints_b:
    type: File?
    format: [gromacs:pdb, gromacs:gro, gromacs:tpr]
    inputBinding:
      prefix: -rb
  restraint_potentials:
    type: File?
    format: [gromacs:itp]
  out_parameters:
    type: string
    inputBinding:
      prefix: -po
    default: md.mdp
  out_runnable:
    type: string
    inputBinding:
      prefix: -o
    default: topol.tpr
  

outputs:
  parameters:
    type: File
    format: gromacs:mdp
    outputBinding:
      glob: $(inputs.out_parameters)
  runnable:
    type: File
    format: gromacs:tpr
    outputBinding:
      glob: $(inputs.out_runnable)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html