const ShellSpawn = require('./app/lib/ShellSpawn')
const GetExistedArgv = require('./app/lib/GetExistedArgv')
const SetDockerComposeYML = require('./app/lib/SetDockerComposeYML')

// const dialog = require('node-file-dialog')

// const fs = require('fs')
// const path = require('path')

let main = async function () {
  // 1. 先取得輸入檔案的列表
  let files = GetExistedArgv()

  console.log('gogogo', files)
  for (let i = 0; i < files.length; i++) {
    let file = files[i]

    if (file.endsWith('.zip') === false) {
      continue
    }
    
    SetDockerComposeYML(file)
    await ShellSpawn('docker-compose up')
  }

}

main()
