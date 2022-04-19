require 'mysql2'

class PostWithTagNames
  attr_reader :post_id, :title, :content, :tag_names

  def initialize(post_id, title, content, tag_names)
    @post_id = post_id
    @title = title
    @content = content
    @tag_names = tag_names
  end
end

def find_post_with_tag_names_array_by_user_id(user_id)
  client = Mysql2::Client.new(
    :host => '127.0.0.1',
    :database => 'mydb',
    :username => 'myuser',
    :password => 'mypassword'
  )

  posts_stmt = client.prepare('select id, title, content from posts where user_id = ?')
  posts = posts_stmt.execute(user_id)
  post_with_tag_names_array = posts.map do |post|
    post_id = post['id']
    title = post['title']
    content = post['content']

    taggingsStmt = client.prepare('select post_id, tag_id from taggings where post_id = ?')
    taggings = taggingsStmt.execute(post_id)
    tag_names = taggings.flat_map do |tagging|
      tag_id = tagging['tag_id']

      tagsStmt = client.prepare('select id, name from tags where id = ?')
      tags = tagsStmt.execute(tag_id)
      tags.map do |tag|
        tag['name']
      end
    end

    PostWithTagNames.new(post_id, title, content, tag_names)
  end

  client.close

  return post_with_tag_names_array
end

if __FILE__ == $0
  main
end
