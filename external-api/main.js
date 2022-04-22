// このファイルを修正するのは NG です

const express = require('express')

const port = 3000

const app = express()
app.use(express.json())

function logInfo(message) {
  console.log(`[${new Date().toISOString()}] [INFO] ${message}`)
}

app.get('/api/posts/:postId', (req, res) => {
  const postId = parseInt(req.params.postId)
  logInfo(`[request] postId = ${postId}`)

  // 自動テスト可能なよう、0 ~ 10 の範囲の値をルールに従って生成
  const likeCount = postId ** 3 % 11

  setTimeout(() => {
    logInfo(`[response] postId = ${postId}, likeCount = ${likeCount}`)
    res.send({
      postId,
      likeCount
    })
  }, 100)
})

app.listen(port, () => {
  console.log(`Start application on port ${port}`)
})
