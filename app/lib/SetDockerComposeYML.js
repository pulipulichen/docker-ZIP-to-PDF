const path = require('path')
const fs = require('fs')

module.exports = function (file) {
  let filename = path.basename(file)
  let dirname = path.dirname(file)

  let template = fs.readFileSync(path.join(__dirname, '../../docker-compose-template.yml'), 'utf8')
  template = template.replace(/\[SOURCE\]/, `${dirname}`)
  template = template.replace(/\[CMD\]/, `node /app/zip-to-pdf.js "/input/${filename}"`)

  fs.writeFileSync(path.join(__dirname, '../../docker-compose.yml'), template, 'utf8')
}