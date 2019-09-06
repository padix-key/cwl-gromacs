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
  ion_replacement_group:
    type: string
    default: SOL
  minimization_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/minimization.mdp


outputs:
  topology:
    type: File
    outputSource: salt/topology
  structure:
    type: File
    outputSource: minimization/structure


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
  
  grompp_minimization:
    run: ../tools/grompp.cwl
    in:
      parameters:
        source: minimization_parameters
      structure:
        source: salt/structure
      topology:
        source: salt/topology
    out:
      - runnable
  
  minimization:
    run: ../tools/mdrun.cwl
    in:
      runnable:
        source: grompp_minimization/runnable
      out_structure:
        source: out_structure
    out:
      - structure


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html