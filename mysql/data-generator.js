const { faker } = require('@faker-js/faker')

// 1 つのインサート文の最大レコード数
const MAX_INSERT_STATEMENT_RECORDS = 10000

function* createRecordGenerator(generateRecord) {
  let index = 0
  while (true) {
    const record = generateRecord(index)
    index++
    yield record
  }
}

function generateRecords(generator, size) {
  const records = []
  for (let i = 0; i < size; i++) {
    const record = generator.next().value
    records.push(record)
  }
  return records
}

function generateInsertStatementPart(table, columnsClause, generator, size) {
  const records = generateRecords(generator, size)

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

  const insertStatement = `insert into \`${table}\` (${columnsClause}) values
${valuesClause};`

  console.log(insertStatement)
}

function generateInsertStatement(table, columns, generator, size) {
  const columnsClause = columns
    .map((col) => `\`${col}\``)
    .reduce((col1, col2) => `${col1}, ${col2}`)

  let remainingSize = size
  while (remainingSize > 0) {
    const generateSize =
      remainingSize > MAX_INSERT_STATEMENT_RECORDS
        ? MAX_INSERT_STATEMENT_RECORDS
        : remainingSize

    generateInsertStatementPart(table, columnsClause, generator, generateSize)

    remainingSize -= generateSize
  }
}

function randomInt(max) {
  return Math.floor(Math.random() * max)
}

function main() {
  const userSize = 10000
  const postsPerUser = 100
  const postsSize = userSize * postsPerUser

  const tagsSize = 100
  const taggingsPerPost = 5
  const taggingsSize = postsSize * taggingsPerPost

  // 1 ユーザが記事につける「いいね」の数
  const likesPerUser = 10
  const likesSize = userSize * likesPerUser

  const userGenerator = createRecordGenerator(() => [faker.name.firstName()])
  generateInsertStatement('users', ['name'], userGenerator, userSize)

  const postGenerator = createRecordGenerator((index) => {
    const userId = Math.floor(index / postsPerUser) + 1
    return [userId, faker.lorem.words(), faker.lorem.paragraphs()]
  })
  generateInsertStatement(
    'posts',
    ['user_id', 'title', 'content'],
    postGenerator,
    postsSize
  )

  const tagGenerator = createRecordGenerator((index) => [`tag${index}`])
  generateInsertStatement('tags', ['name'], tagGenerator, tagsSize)

  const taggingGenerator = createRecordGenerator((index) => {
    const postId = Math.floor(index / taggingsPerPost) + 1
    const tagId = (index % tagsSize) + 1
    return [postId, tagId]
  })
  generateInsertStatement(
    'taggings',
    ['post_id', 'tag_id'],
    taggingGenerator,
    taggingsSize
  )

  // あるユーザが同じ投稿に複数「いいね」しないようにデータ生成
  const userLikedPosts = {
    userId: null,
    postIds: []
  }
  const likesGenerator = createRecordGenerator((index) => {
    const userId = Math.floor(index / likesPerUser) + 1
    if (userLikedPosts.userId !== userId) {
      userLikedPosts.userId = userId
      userLikedPosts.postIds = []
    }
    let postId = null
    do {
      postId = randomInt(postsSize) + 1
    } while (userLikedPosts.postIds.includes(postId))
    userLikedPosts.postIds.push(postId)

    return [userId, postId]
  })
  generateInsertStatement(
    'likes',
    ['user_id', 'post_id'],
    likesGenerator,
    likesSize
  )
}

main()
