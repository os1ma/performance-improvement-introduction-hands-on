require 'mysql2'

def sum(a, b)
  a + b
end

def main
  client = Mysql2::Client.new(
    :host => '127.0.0.1',
    :database => 'mydb',
    :username => 'myuser',
    :password => 'mypassword'
  )

  results = client.query('select * from users')
  results.each do |row|
    puts row
  end

  client.close
end

if __FILE__ == $0
  main
end
