use mydb;

create table `users` (
  `id` int primary key auto_increment,
  `name` varchar(255) not null
);

insert into `users` (`name`) values
('Alice'),
('Bob');
