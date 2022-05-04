const axios = require('axios').default

const MIN_POST_ID = 1
const MAX_POST_ID = 100

async function main() {
  const promiseResponses = []
  for (let i = MIN_POST_ID; i <= MAX_POST_ID; i++) {
    const promiseResponse = axios.get(`http://external-api:3000/api/posts/${i}`)
    promiseResponses.push(promiseResponse)
  }

  const responses = await Promise.all(promiseResponses)
  return responses.map((r) => r.data.likeCount).reduce((a, b) => a + b, 0)
}

exports.main = main

if (require.main === module) {
  main()
}
