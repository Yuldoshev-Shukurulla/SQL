drop table if exists agents;
create table agents
(
    name varchar(50),
    office varchar(50),
    isheadoffice varchar(3)
);

insert into agents
values
    ('Rich', 'UK', 'yes'),
    ('Rich', 'US', 'no'),
    ('Rich', 'NZ', 'no'),
    ('Brandy', 'US', 'yes'),
    ('Brandy', 'UK', 'no'),
    ('Brandy', 'AUS', 'no'),
    ('Karen', 'NZ', 'yes'),
    ('Karen', 'UK', 'no'),
    ('Karen', 'RUS', 'no'),
    ('Mary', 'US', 'yes'),
    ('Mary', 'UK', 'no'),
    ('Mary', 'CAN', 'no'),
    ('Charles', 'US', 'yes'),
    ('Charles', 'UZB', 'no'),
    ('Charles', 'AUS', 'no');

select * from agents;


select name from agents
where isheadoffice = 'yes' and office='US' or office = 'UK' and isheadoffice = 'no'
group by name
having count(*) = 2;

drop table if exists parent;
create table parent
(
    pname varchar(50),
    cname varchar(50),
    gender char(1)
);

insert into parent
values
    ('Karen', 'John', 'M'),
    ('Karen', 'Steve', 'M'),
    ('Karen', 'Ann', 'F'),
    ('Rich', 'Cody', 'M'),
    ('Rich', 'Stacy', 'F'),
    ('Rich', 'Mike', 'M'),
    ('Tom', 'John', 'M'),
    ('Tom', 'Ross', 'M'),
    ('Tom', 'Rob', 'M'),
    ('Roger', 'Brandy', 'F'),
    ('Roger', 'Jennifer', 'F'),
    ('Roger', 'Sara', 'F');

select * from parent;

select pname from parent
group by pname, gender
having count(gender) = 2;
