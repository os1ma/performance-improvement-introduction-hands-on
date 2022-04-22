-- データの投入を高速にするため、外部キー制約は使用していません

use mydb;

create table `users` (
  `id` int primary key auto_increment,
  `name` varchar(255) not null
);

create table `posts` (
  `id` int primary key auto_increment,
  `user_id` int not null,
  `title` varchar(255) not null,
  `content` text not null,
  `posted_at` timestamp not null
);

alter table `posts` add index (`user_id`);

create table `tags` (
  `id` int primary key auto_increment,
  `name` varchar(255) not null
);

create table `taggings` (
  `post_id` int not null,
  `tag_id` int not null,
  primary key(`post_id`, `tag_id`)
);

create table `likes` (
  `user_id` int not null,
  `post_id` int not null,
  primary key(`user_id`, `post_id`)
);
