const { spawn } = require("child_process");

module.exports = function (cmdArray, stderrHandler, errorHandler) {
  if (typeof(cmdArray) === "string") {
    cmdArray = cmdArray.split(' ')
  }

  if (typeof(stderrHandler) !== 'function') {
    stderrHandler = function (stderr) {
      //console.log(`[STDERR] ${stderr}`);
	  console.log(`${stderr}`);
    }
  }

  if (typeof(errorHandler) !== 'function') {
    errorHandler = function (error, reject) {
      console.log(`[ERROR]\n${error.message}`)
      reject(error)
      return
    }
  }

  return new Promise(function (resolve, reject) {
    
    let job = spawn(cmdArray[0], cmdArray.slice(1), { shell: true })

    job.stdout.on("data", data => {
        console.log(`${data}`);
    });
    
    job.stderr.on("data", data => {
      stderrHandler(`${data}`, reject);
    });
    
    job.on('error', (error) => {
      stderrHandler(`error: ${error.message}`, reject);
    });
    
    job.on("close", code => {
      // console.log(`child process exited with code ${code}`);
      if (code !== 0) {
        return reject(code)
      }
      resolve()
    });
      
  })
}
