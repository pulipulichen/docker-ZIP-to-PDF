const ShellSpawn = require('./app/lib/ShellSpawn')
const GetExistedArgv = require('./app/lib/GetExistedArgv')
const path = require('path')

let main = async function () {
  let files = GetExistedArgv()

  for (let i = 0; i < files.length; i++) {
    let file = files[i]

    let filename = path.basename(file)

    await ShellSpawn([
      `cp "${file}" /cache/${filename}`
    ])
  }
}

main()