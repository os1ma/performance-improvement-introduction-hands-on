const axios = require('axios').default

const MIN_POST_ID = 1
const MAX_POST_ID = 100

async function main() {
  let totalLikeCount = 0

  for (let i = MIN_POST_ID; i <= MAX_POST_ID; i++) {
    const response = await axios.get(`http://external-api:3000/api/posts/${i}`)
    const responseBody = response.data
    totalLikeCount += responseBody.likeCount
  }

  return totalLikeCount
}

exports.main = main

if (require.main === module) {
  main()
}
