require 'mysql2'

def main
  user_id = 1

  client = Mysql2::Client.new(
    :host => 'mysql',
    :database => ENV['MYSQL_DATABASE'],
    :username => ENV['MYSQL_USER'],
    :password => ENV['MYSQL_PASSWORD']
  )

  posts_stmt = client.prepare('select id, title, content from posts where user_id = ? order by id')
  posts = posts_stmt.execute(user_id)
  output = posts.map do |post|
    post_id = post['id']
    title = post['title']
    content = post['content']

    taggingsStmt = client.prepare('select post_id, tag_id from taggings where post_id = ?')
    taggings = taggingsStmt.execute(post_id)
    tag_names = taggings.flat_map do |tagging|
      tag_id = tagging['tag_id']

      tagsStmt = client.prepare('select id, name from tags where id = ?')
      tags = tagsStmt.execute(tag_id)
      tags.map {|tag| tag['name']}
    end

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
