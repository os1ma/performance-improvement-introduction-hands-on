require 'mysql2'

class OutputItem
  attr_reader :post_id, :title, :content, :tag_names

  def initialize(post_id, title, content, tag_names)
    @post_id = post_id
    @title = title
    @content = content
    @tag_names = tag_names
  end
end

def main
  user_id = 1

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
  outputs = query_result
    .group_by {|record| record['post_id'] }
    .map do |post_id, records|
      first_record = records[0]

      title = first_record['title']
      content = first_record['content']
      tag_names = records.map {|r| r['tag_name']}

      OutputItem.new(post_id, title, content, tag_names)
    end

  client.close

  outputs
end

if __FILE__ == $0
  main
end
