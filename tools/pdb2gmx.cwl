cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, pdb2gmx, -nobackup]

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
  topology:
    type: string
    inputBinding:
      prefix: -p
    default: topol.top
  out_position_restraints:
    type: string
    inputBinding:
      prefix: -i
    default: posre.itp
  force_field:
    type: [string, File]
    format: [gromacs:ff]
    inputBinding:
      prefix: -ff
  water_model:
    type:
      type: enum
      symbols:
        - none
        - spc
        - spce
        - tip3p
        - tip4p
        - tip5p
        - tips3p
      label: The water model
    inputBinding:
      prefix: -water

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
      glob: $(inputs.topology)
  out_position_restraints:
    type: File
    format: gromacs:itp
    outputBinding:
      glob: $(inputs.out_position_restraints)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html