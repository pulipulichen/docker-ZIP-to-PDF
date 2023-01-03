const ShellSpawn = require('./lib/ShellSpawn')
const GetExistedArgv = require('./lib/GetExistedArgv')

const path = require('path')
const fs = require('fs')

const extract = require('extract-zip')
const fg = require('fast-glob');

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

    await extract(`/cache/${filename}`, { dir: '/cache/unzip' })
    // console.log('Extraction complete')

    const entries = fg.sync(['/cache/unzip/**/*.*'], { dot: true, onlyFiles: true })
    entries.forEach((entry) => {
      let name = path.basename(entry)
      let target = `/cache/img/${name}`
      if (fs.existsSync(target) === false) {
        fs.renameSync(entry, target)
      }
    })


    // ----------------

    // 列出檔案名稱
    let imgs = fs.readdirSync('/cache/img/')
    imgs.sort((a, b) => {
      let aID = Number(a.match(/\d+/)[0])
      let bID = Number(b.match(/\d+/)[0])

      return (aID - bID)
    })

    imgs = imgs.map(filename => {
      return `"/cache/img/${filename}"`
    })

    await ShellSpawn(`img2pdf -o "/input/${filenameNoExt}.pdf" ${imgs.join(" ")}`)
  }
}

main()