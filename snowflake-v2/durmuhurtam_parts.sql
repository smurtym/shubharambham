drop table if exists durmuhurtham_parts;
create table durmuhurtham_parts(week int, d1 int, d2 int);
insert into durmuhurtham_parts values(0, 13, -1);
insert into durmuhurtham_parts values(1, 8, 11);
insert into durmuhurtham_parts values(2, 3, 21);
insert into durmuhurtham_parts values(3, 7, -1);
insert into durmuhurtham_parts values(4, 5, 11);
insert into durmuhurtham_parts values(5, 3, 8);
insert into durmuhurtham_parts values(6, 0, 1);

select * from durmuhurtham_parts;