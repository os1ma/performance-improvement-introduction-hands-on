require 'mysql2'

class OutputItem
  attr_reader :post_id, :title, :posted_at, :like_count

  def initialize(post_id, title, posted_at, like_count)
    @post_id = post_id
    @title = title
    @posted_at = posted_at
    @like_count = like_count
  end

  def to_s
    "PostWithTagNames(post_id = #{post_id}, title = #{title}, posted_at = #{posted_at}, like_count = #{like_count})"
  end
end

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
    likes.user_id as liked_user_id
  from posts
  left join likes on likes.post_id = posts.id
  where '2022-03-31 00:00:00' <= posts.posted_at
  and posts.posted_at < '2022-04-01 00:00:00'
  SQL

  posts_stmt = client.prepare(sql)
  query_result = posts_stmt.execute()

  outputs = query_result.group_by {|record| record['post_id'] }
    .map do |post_id, records|
      first_record = records[0]

      title = first_record['title']
      posted_at = first_record['posted_at']
      like_count = records.map {|r| r['liked_user_ids']}.length

      OutputItem.new(post_id, title, posted_at, like_count)
    end
    .sort_by {|e| [e.like_count, e.posted_at]}
    .reverse
    .take(10)

  client.close

  outputs
end

# main
if __FILE__ == $0
  user_id = 1
  fixed(user_id)
end
