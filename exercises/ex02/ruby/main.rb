require 'mysql2'
require 'time'
require 'json'

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
    likes.user_id as liked_user_id
  from posts
  left join likes on likes.post_id = posts.id
  SQL

  posts_stmt = client.prepare(sql)
  query_result = posts_stmt.execute()

  output = query_result.group_by {|record| record['post_id'] }
    .map do |post_id, records|
      first_record = records[0]

      title = first_record['title']
      posted_at = first_record['posted_at']
      like_count = records.map {|r| r['liked_user_ids']}.length

      {
        postId: post_id,
        title: title,
        postedAt: posted_at.to_s,
        likeCount: like_count
      }
    end
    .filter do |outputItem|
      posted_at = Time.parse(outputItem[:postedAt])
      Time.parse('2022-03-31 00:00:00') <= posted_at && posted_at < Time.parse('2022-04-01 00:00:00')
    end
    .sort_by {|e| [e[:likeCount], e[:postedAt]]}
    .reverse
    .take(10)

  client.close

  output
end

if __FILE__ == $0
  output = main
  puts JSON.pretty_generate(output)
end
