use mydb;

create table `users` (
  `id` int primary key auto_increment,
  `name` varchar(255) not null
);

create table `posts` (
  `id` int primary key auto_increment,
  `user_id` int not null,
  `title` varchar(255) not null,
  `content` text not null
);

create table `tags` (
  `id` int primary key auto_increment
);

create table `taggings` (
  `post_id` int not null,
  `tag_id` int not null,
  primary key(`post_id`, `tag_id`)
);
