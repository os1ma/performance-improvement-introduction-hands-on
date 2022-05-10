require 'mysql2'
require 'json'

def main
  user_id = 1

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
    posts.content as content,
    tags.name as tag_name
  from posts
  inner join taggings on taggings.post_id = posts.id
  inner join tags on tags.id = taggings.tag_id
  where user_id = ?
  order by posts.id
  SQL

  posts_stmt = client.prepare(sql)
  query_result = posts_stmt.execute(user_id)
  output = query_result
    .group_by {|record| record['post_id'] }
    .map do |post_id, records|
      first_record = records[0]

      title = first_record['title']
      content = first_record['content']
      tag_names = records.map {|r| r['tag_name']}

      {
        postId: post_id,
        title: title,
        content: content,
        tagNames: tag_names
      }
    end

  client.close

  output
end

if __FILE__ == $0
  output = main
  puts JSON.pretty_generate(output)
end
