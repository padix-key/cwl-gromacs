cwlVersion: v1.0

class: Workflow


inputs:
  parameters:
    type: File
    format: gromacs:mdp
  topology:
    type: File
    format: gromacs:top
  structure:
    type: File
    format: [gromacs:pdb, gromacs:gro]
  restraints:
    type: File?
    format: [gromacs:pdb, gromacs:gro, gromacs:tpr]
  restraints_b:
    type: File?
    format: [gromacs:pdb, gromacs:gro, gromacs:tpr]
  restraint_potentials:
    type: File?
    format: [gromacs:itp]
  out_parameters:
    type: string
    default: md.mdp
  out_trajectory:
    type: string
    default: traj.trr
  out_trajectory_compressed:
    type: string
    default: traj.xtc
  out_structure:
    type: string
    default: structure.gro
  out_energies:
    type: string
    default: ener.edr
  out_log:
    type: string
    default: log.log


outputs:
  parameters:
    type: File
    format: gromacs:mdp
    outputSource: grompp/parameters
  trajectory:
    type: File
    format: gromacs:trr
    outputSource: mdrun/trajectory
  trajectory_compressed:
    type: File?
    format: gromacs:xtc
    outputSource: mdrun/trajectory_compressed
  structure:
    type: File
    format: gromacs:gro
    outputSource: mdrun/structure
  energies:
    type: File?
    format: gromacs:edr
    outputSource: mdrun/energies
  log:
    type: File?
    format: gromacs:log
    outputSource: mdrun/log


steps:
  grompp:
    run: ../tools/grompp.cwl
    in:
      parameters:
        source: parameters
      topology:
        source: topology
      structure:
        source: structure
      restraints:
        source: restraints
      restraints_b:
        source: restraints_b
      restraint_potentials:
        source: restraint_potentials
      out_parameters:
        source: out_parameters
    out:
      - runnable
      - parameters
  
  mdrun:
    run: ../tools/mdrun.cwl
    in:
      runnable:
        source: grompp/runnable
      out_trajectory:
        source: out_trajectory
      out_trajectory_compressed:
        source: out_trajectory_compressed
      out_structure:
        source: out_structure
      out_energies:
        source: out_energies
      out_log:
        source: out_log
    out:
      - trajectory
      - trajectory_compressed
      - structure
      - energies
      - log


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html