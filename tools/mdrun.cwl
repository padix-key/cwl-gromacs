cwlVersion: v1.0

class: CommandLineTool

baseCommand: [gmx, mdrun, -nobackup, -quiet]


inputs:
  runnable:
    type: File
    format: gromacs:tpr
    inputBinding:
      prefix: -s
  out_trajectory:
    type: string
    inputBinding:
      prefix: -o
    default: traj.trr
  out_trajectory_compressed:
    type: string
    inputBinding:
      prefix: -x
    default: traj.xtc
  out_structure:
    type: string
    inputBinding:
      prefix: -c
    default: structure.gro
  out_energies:
    type: string
    inputBinding:
      prefix: -e
    default: ener.edr
  out_log:
    type: string
    inputBinding:
      prefix: -g
    default: log.log


outputs:
  trajectory:
    type: File
    format: gromacs:trr
    outputBinding:
      glob: $(inputs.out_trajectory)
  trajectory_compressed:
    type: File?
    format: gromacs:xtc
    outputBinding:
      glob: $(inputs.out_trajectory_compressed)
  structure:
    type: File
    format: gromacs:gro
    outputBinding:
      glob: $(inputs.out_structure)
  energies:
    type: File?
    format: gromacs:edr
    outputBinding:
      glob: $(inputs.out_energies)
  log:
    type: File?
    format: gromacs:log
    outputBinding:
      glob: $(inputs.out_log)


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html