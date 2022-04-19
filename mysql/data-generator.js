const { faker } = require('@faker-js/faker')

function generateData(size, generator) {
  const generated = []
  for (let i = 0; i < size; i++) {
    generated.push(generator())
  }
  return generated
}

function generateInsertStatement(table, columns, records) {
  const columnsClause = columns
    .map((col) => `\`${col}\``)
    .reduce((col1, col2) => `${col1}, ${col2}`)

  const valuesClause = records
    .map((record) => {
      const cols = record
        .map((col) => `'${col}'`)
        .reduce((col1, col2) => `${col1}, ${col2}`)
      return `(${cols})`
    })
    .reduce((record1, record2) => `${record1},\n${record2}`)

  return `insert into \`${table}\` (${columnsClause}) values
${valuesClause};`
}

function main() {
  const userSize = 10

  const users = generateData(userSize, () => [faker.name.firstName()])
  const sql = generateInsertStatement('users', ['name'], users)
  console.log(sql)
}

main()
