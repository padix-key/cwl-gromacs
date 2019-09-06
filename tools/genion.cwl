cwlVersion: v1.0

class: Workflow


inputs:
  runnable:
    type: File
    format: gromacs:tpr
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
    type: string?
    default: NA
  anions:
    type: string?
    default: CL
  group:
    type: string


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
  echo:
    run: ./_echo.cwl
    in:
      message:
        source: group
    out:
      - message_file
  
  genion:
    run: ./_genion.cwl
    in:
      runnable:
        source: runnable
      out_structure:
        source: out_structure
      topology:
        source: topology
      concentration:
        source: concentration
        default: null
      neutral:
        source: neutral
        default: null
      cations:
        source: cations
        default: null
      anions:
        source: anions
        default: null
      group:
        source: echo/message_file
    out:
      - structure
      - topology


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html