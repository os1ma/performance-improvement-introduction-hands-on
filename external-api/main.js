// このファイルを修正するのは NG です

const express = require('express')

const port = 3000

const app = express()
app.use(express.json())

app.get('/api/posts/:postId', (req, res) => {
  const postId = parseInt(req.params.postId)
  // 自動テスト可能なよう、0 ~ 10 の範囲の値をルールに従って生成
  const likeCount = postId ** 3 % 11

  setTimeout(() => {
    res.send({
      postId,
      likeCount
    })
  }, 100)
})

app.listen(port, () => {
  console.log(`Start application on port ${port}`)
})
