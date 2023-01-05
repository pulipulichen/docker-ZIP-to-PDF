
const extract = require('extract-zip')
const fg = require('fast-glob');

const fs = require('fs')
const path = require('path')

const ShellSpawn = require('./../lib/ShellSpawn')

const tmpDir = `/tmp/unzip`

module.exports = async function(input, targetDir) {
	// console.log('gogogogo')
  if (fs.existsSync(tmpDir)) {
    await ShellSpawn([`rm`, `-rf`, tmpDir]) 
  }
	// 
  fs.mkdirSync(tmpDir, { recursive: true})

  await extract(input, { dir: tmpDir })
  // console.log('Extraction complete')

  if (targetDir.endsWith('/')) {
    targetDir = targetDir.slice(0, -1)
  }

  const entries = fg.sync([`${tmpDir}/**/*.*`], { dot: true, onlyFiles: true })
  for (let i = 0; i < entries.length; i++) {
    let entry = entries[i]
		// console.log('entry', entry)
    let name = path.basename(entry)
    // let target = `${targetDir}/${name}`
		let target = `${targetDir}/${name}`
    if (fs.existsSync(target) === false) {
      // fs.renameSync(entry, target)
			// console.log(['mv2', entry, target])
			// if (fs.statSync(target).isDirectory() === false) {
			// 	target = path.dirname(target)
			// }
			// console.log(['mv', entry, target])
      await ShellSpawn(['mv', `"${entry}"`, `"${path.dirname(target)}"`])
    }
		// else {
		// 	console.log('target is existed.', target)
		// }
  }
} 