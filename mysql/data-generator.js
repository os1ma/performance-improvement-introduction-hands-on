const { faker } = require('@faker-js/faker')

function generateData(size, generator) {
  const generated = []
  for (let i = 0; i < size; i++) {
    generated.push(generator(i))
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
        .map((col) => {
          if (typeof col === 'string') {
            const escaped = col.replaceAll("'", "\\'")
            return `'${escaped}'`
          } else {
            return col
          }
        })
        .reduce((col1, col2) => `${col1}, ${col2}`)
      return `(${cols})`
    })
    .reduce((record1, record2) => `${record1},\n${record2}`)

  return `insert into \`${table}\` (${columnsClause}) values
${valuesClause};`
}

function main() {
  const userSize = 100
  const tagSize = 100
  const postsPerUser = 100
  const postsSize = userSize * postsPerUser
  const taggingsPerPost = 5
  const taggingsSize = postsSize * taggingsPerPost

  const users = generateData(userSize, () => [faker.name.firstName()])
  const usersSql = generateInsertStatement('users', ['name'], users)
  console.log(usersSql)

  const tags = generateData(tagSize, (index) => [`tag${index}`])
  const tagsSql = generateInsertStatement('tags', ['name'], tags)
  console.log(tagsSql)

  const posts = generateData(postsSize, (index) => {
    const userId = Math.floor(index / postsPerUser) + 1
    return [userId, faker.lorem.words(), faker.lorem.paragraphs()]
  })
  const postsSql = generateInsertStatement(
    'posts',
    ['user_id', 'title', 'content'],
    posts
  )
  console.log(postsSql)

  const taggings = generateData(taggingsSize, (index) => {
    const postId = Math.floor(index / taggingsPerPost) + 1
    const tagId = (index % tagSize) + 1
    return [postId, tagId]
  })
  const taggingSql = generateInsertStatement(
    'taggings',
    ['post_id', 'tag_id'],
    taggings
  )
  console.log(taggingSql)
}

main()
