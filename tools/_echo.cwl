cwlVersion: v1.0

class: CommandLineTool

baseCommand: [echo]


inputs:
  message:
    type: string
    inputBinding:
      position: 0
  message_file:
    type: string
    default: message


outputs:
  message_file:
    type: stdout


stdout:
  $(inputs.message_file)


$namespaces:
  gromacs: http://manual.gromacs.org/documentation/2018/user-guide/file-formats.html