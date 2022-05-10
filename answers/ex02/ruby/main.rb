require 'mysql2'
require 'json'

#
# コードの変更に加えて、以下のようにしてインデックスも追加してください
# alter table `posts` add index (`posted_at`);
#
def main
  client = Mysql2::Client.new(
    :host => 'mysql',
    :database => ENV['MYSQL_DATABASE'],
    :username => ENV['MYSQL_USER'],
    :password => ENV['MYSQL_PASSWORD']
  )

  sql = <<~SQL
  select
    posts.id as post_id,
    posts.title as title,
    posts.posted_at as posted_at,
    count(likes.user_id) as like_count
  from posts
  left join likes on likes.post_id = posts.id
  where '2022-03-31 00:00:00' <= posts.posted_at
  and posts.posted_at < '2022-04-01 00:00:00'
  group by posts.id
  order by like_count desc, posted_at desc
  limit 10
  SQL

  posts_stmt = client.prepare(sql)
  query_result = posts_stmt.execute()

  output = query_result
    .map do |record|
      post_id = record['post_id']
      title = record['title']
      posted_at = record['posted_at']
      like_count = record['like_count']

      {
        postId: post_id,
        title: title,
        postedAt: posted_at.to_s,
        likeCount: like_count
      }
    end

  client.close

  output
end

if __FILE__ == $0
  output = main
  puts JSON.pretty_generate(output)
end
