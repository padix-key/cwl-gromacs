cwlVersion: v1.0

class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}


inputs:
  structure:
    type: File
    format: [gromacs:gro, gromacs:gro]
  out_structure:
    type: string
    default: structure.gro
  topology:
    type: File
    format: gromacs:top
  concentration:
    type: float?
  neutral:
    type: boolean
    default: true
  cations:
    type: string
    default: NA
  anions:
    type: string
    default: CL
  genion_parameters:
    type: File
    default:
      class: File
      format: gromacs:mdp
      location: ../mdp/ions.mdp


outputs:
  structure:
    type: File
    format: gromacs:gro
    outputSource: genion/structure
  topology:
    type: File
    format: gromacs:top
    outputSource: genion/topology


steps:
  grompp:
    run: ../tools/grompp.cwl
    in:
      parameters:
        source: genion_parameters
      structure:
        source: structure
      topology:
        source: topology
    out:
      - runnable
  
  genion:
    run: ../tools/genion.cwl
    in:
      runnable:
        source: grompp/runnable
      topology:
        source: topology
    out:
      - structure
      - topology


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html