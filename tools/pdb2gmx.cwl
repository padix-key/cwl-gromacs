cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, pdb2gmx, -nobackup, -quiet]

inputs:
  structure:
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
  out_restraint_potentials:
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
    type: string
    label: The name of the water model
    inputBinding:
      prefix: -water

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
      glob: $(inputs.topology)
  restraint_potentials:
    type: File
    format: gromacs:itp
    outputBinding:
      glob: $(inputs.out_restraint_potentials)

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html