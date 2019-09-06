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
  genion_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/ions.mdp
  genion_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/ions.mdp
  out_structure:
    type: string
  ion_replacement_group:
    type: string
    default: SOL


outputs:
  topology:
    type: File
    outputSource: genion/topology
  structure:
    type: File
    outputSource: genion/structure


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
  
  grompp_genion:
    run: ../tools/grompp.cwl
    in:
      parameters:
        source: genion_parameters
      structure:
        source: solvate/structure
      topology:
        source: solvate/topology
    out:
      - runnable
  
  genion:
    run: ../tools/genion.cwl
    in:
      runnable:
        source: grompp_genion/runnable
      topology:
        source: solvate/topology
      group:
        source: ion_replacement_group
      out_structure:
        source: out_structure
    out:
      - structure
      - topology
  
#  grompp_minimitation:
#    run: ../tools/grompp.cwl
#    in:
#      parameters:
#        source: genion_parameters
#      structure:
#        source: solvate/out_structure
#      topology:
#        source: solvate/topology
#    out:
#      - out_runnable
#  
#  minimitation:
#    run: ../tools/mdrun.cwl
#    in:
#      runnable:
#        source: grompp_genion/out_runnable
#      out_structure:
#        source: out_structure
#    out:
#      - out_structure
#      - topology
#

$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html