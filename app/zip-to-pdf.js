const ShellSpawn = require('./lib/ShellSpawn')
const GetExistedArgv = require('./lib/GetExistedArgv')

const path = require('path')
const fs = require('fs')

const UnzipFlatten = require('./lib-zip/UnzipFlatten')

let main = async function () {
  let files = GetExistedArgv()
  for (let i = 0; i < files.length; i++) {
    let file = files[i]
    if (file.endsWith('.zip') === false) {
      continue
    }

    let filename = path.basename(file)
    let filenameNoExt = filename
    if (filenameNoExt.endsWith('.zip')) {
      filenameNoExt = filenameNoExt.slice(0, -4)
    }

    let commandsUnzip = [
      `rm -rf /cache/*`,
      `cp "${file}" "/cache/${filename}"`,
      `mkdir -p /cache/img`
      // `unzip -j -d "/cache/img" "/cache/${filename}"`
    ]
    for (let j = 0; j < commandsUnzip.length; j++) {
      await ShellSpawn(commandsUnzip[j])
    }

    // -----------------

    await UnzipFlatten(`/cache/${filename}`, `/cache/img`)

    // ----------------

    // 列出檔案名稱
    let imgs = fs.readdirSync('/cache/img/')
    imgs.sort((a, b) => {
      let aMatches = a.match(/\d+/)
      let bMatches = b.match(/\d+/)
      
      if (!aMatches || !bMatches) {
        return a.localeCompare(b)
      }

      for (let i = 0; i < aMatches.length; i++) {

        if (!aMatches[i] || !bMatches[i]) {
          return 0
        }

        let aID = Number(aMatches[i])
        let bID = Number(bMatches[i])

        if (aID !== bID) {
          return (aID - bID)
        }
      }

    })

    imgs = imgs.map(filename => {
      return `"/cache/img/${filename}"`
    })

    await ShellSpawn(`img2pdf -o "/input/${filenameNoExt}.pdf" ${imgs.join(" ")}`)
  }
}

main()