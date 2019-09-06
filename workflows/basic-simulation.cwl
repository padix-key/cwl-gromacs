cwlVersion: v1.0

class: Workflow

id: basic_simulation

label: Basic simulation

requirements:
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}


inputs:
  structure:
    type: File
  force_field:
    type: string?
  water_model:
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
  out_structure:
    type: string
  out_trajectory:
    type: string
  ion_replacement_group:
    type: string
    default: SOL
  minimization_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/minimization.mdp
  nvt_equilibration_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/nvt_equilibration.mdp
  npt_equilibration_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/npt_equilibration.mdp
  production_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/production.mdp


outputs:
  topology:
    type: File
    outputSource: salt/topology
  structure:
    type: File
    outputSource: production_simulation/structure
  trajectory:
    type: File
    outputSource: production_simulation/trajectory_compressed


steps:
  pdb2gmx:
    run: ../tools/pdb2gmx.cwl
    in:
      force_field:
        default: oplsaa
        source: force_field
      structure:
        source: structure
      water_model:
        default: spce
        source: water_model
    out:
      - structure
      - topology
      - restraint_potentials
  
  editconf:
    run: ../tools/editconf.cwl
    in:
      box_type:
        default: cubic
      center:
        default: true
      distance_to_box_edge:
        default: 1
      structure:
        source: pdb2gmx/structure
    out:
      - structure
  
  solvate:
    run: ../tools/solvate.cwl
    in:
      structure:
        source: editconf/structure
      topology:
        source: pdb2gmx/topology
    out:
      - structure
      - topology
  
  salt:
    run: ../subtasks/salt.cwl
    in:
      structure:
        source: solvate/structure
      topology:
        source: solvate/topology
    out:
      - structure
      - topology
  
  minimization:
    run: ../subtasks/simulate.cwl
    in:
      parameters:
        source: minimization_parameters
      structure:
        source: salt/structure
      topology:
        source: salt/topology
    out:
      - structure
  
  nvt_equilibration:
    run: ../subtasks/simulate.cwl
    in:
      parameters:
        source: nvt_equilibration_parameters
      structure:
        source: minimization/structure
      restraints:
        source: minimization/structure
      restraint_potentials:
        source: pdb2gmx/restraint_potentials
      topology:
        source: salt/topology
      out_structure:
        source: out_structure
    out:
      - structure
  
  npt_equilibration:
    run: ../subtasks/simulate.cwl
    in:
      parameters:
        source: npt_equilibration_parameters
      structure:
        source: nvt_equilibration/structure
      restraints:
        source: nvt_equilibration/structure
      restraint_potentials:
        source: pdb2gmx/restraint_potentials
      topology:
        source: salt/topology
      out_structure:
        source: out_structure
    out:
      - structure
  
  production_simulation:
    run: ../subtasks/simulate.cwl
    in:
      parameters:
        source: production_parameters
      structure:
        source: npt_equilibration/structure
      topology:
        source: salt/topology
      out_structure:
        source: out_structure
      out_trajectory_compressed:
        source: out_trajectory
    out:
      - structure
      - trajectory_compressed
  

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html