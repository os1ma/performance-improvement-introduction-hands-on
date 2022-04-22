require 'mysql2'
require 'time'

class OutputItem
  attr_reader :post_id, :title, :posted_at, :like_count

  def initialize(post_id, title, posted_at, like_count)
    @post_id = post_id
    @title = title
    @posted_at = posted_at
    @like_count = like_count
  end
end

# 以下の SQL を実行した上で、コードも変更してください
# alter table `posts` add index (`posted_at`);
def main
  client = Mysql2::Client.new(
    :host => '127.0.0.1',
    :database => 'mydb',
    :username => 'myuser',
    :password => 'mypassword'
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
  order by like_count, posted_at desc
  limit 10
  SQL

  posts_stmt = client.prepare(sql)
  query_result = posts_stmt.execute()

  outputs = query_result
    .map do |record|
      post_id = record['post_id']
      title = record['title']
      posted_at = record['posted_at']
      like_count = record['like_count']

      OutputItem.new(post_id, title, posted_at, like_count)
    end

  client.close

  outputs
end

if __FILE__ == $0
  main
end
