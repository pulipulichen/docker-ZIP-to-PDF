const ShellSpawn = require('./app/lib/ShellSpawn')

let main = async function () {
  let commandList = [
    'git reset --hard',
    'git pull --force'
  ]

  for (let i = 0; i < commandList.length; i++) {
    console.log(commandList[i])
    await ShellSpawn(commandList[i])
  }
}

main()