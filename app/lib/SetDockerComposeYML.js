const path = require('path')
const fs = require('fs')

module.exports = function (file) {
  let filename = path.basename(file)
  let dirname = path.dirname(file)

  let template = fs.readFileSync(path.join(__dirname, '../../docker-compose-template.yml'), 'utf8')
  template = template.replace(/\[SOURCE\]/, `${dirname}`)
  // template = template.replace(/\[CMD\]/, `node /app/split-pdf.js "/input/${filename}"`)
  template = template.replace(/\[INPUT\]/, filename)

  // console.log(template)

  fs.writeFileSync(path.join(__dirname, '../../docker-compose.yml'), template, 'utf8')
}