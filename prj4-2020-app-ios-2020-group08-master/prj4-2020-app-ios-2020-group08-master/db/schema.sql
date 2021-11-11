drop table if exists category cascade;
drop table if exists location cascade;
drop table if exists customer cascade;
drop table if exists seller cascade;
drop table if exists product cascade;
drop table if exists alert cascade;
drop table if exists "user" cascade;
drop table if exists role cascade;
drop table if exists userRole cascade;
drop table if exists device cascade;


create table "user"
(
    email    text primary key,
    password text not null
);

create table role
(
    name    text primary key
);

create table userRole
(
    id     serial primary key,
    userId text references "user"(email) not null,
    roleId text references role(name) not null
);


create table category(
    name    varchar(250) primary key
);

create table location(
	id      serial primary key,
	street  varchar(50) not null,
	city    varchar(50) not null,
	sNumber varchar(50) not null,
	postalCode  varchar(10) not null,
	country varchar(50) not null,
	longitude varchar(50) not null,
	latitude varchar(50) not null
);

create table customer(
	email       varchar(50) primary key references "user"(email),
	firstName   varchar(50) not null,
	lastName    varchar(50) not null,
	locationId  integer references location(id),
	image       varchar not null
);

create table seller(
	id          serial primary key,
	name        varchar(50) not null,
	locationId  integer references location(id) not null,
	logo        varchar not null,
	email       varchar not null references "user"(email)
);

create table product(
	id              serial primary key,
	name            varchar(100) not null,
	categoryName    varchar(50) references category(name) not null,
	image           varchar not null,
	price           integer not null,
	sellerId        integer references seller(id) not null,
	amount          integer not null,
	description     varchar(355) not null,
	numberOfViews   integer not null
);

create table alert(
	id              serial primary key,
	customerEmail   varchar(50) references customer(email) not null,
	productId       integer references product(id) not null,
	maxPrice        integer not null
);

create table device(
    customerEmail   varchar primary key references customer(email),
    token           varchar
);


select setval(pg_get_serial_sequence('alert', 'id'), 500);
select setval(pg_get_serial_sequence('location', 'id'), 500);
select setval(pg_get_serial_sequence('product', 'id'), 500);
select setval(pg_get_serial_sequence('seller', 'id'), 500);
select setval(pg_get_serial_sequence('userRole', 'id'), 500);

-- trigger for detecting when an alert notification has to be sent because of a price change

CREATE OR REPLACE  FUNCTION check_alerts()
    RETURNS trigger AS $$
DECLARE
    product_j json;
    alert_j json;
    payload json;
    tokenVar text;
    triggered_alerts CURSOR FOR
        select * from alert
        where alert.productid = new.id
          and new.price <= alert.maxprice and old.price > alert.maxprice;
BEGIN
    FOR alert IN triggered_alerts LOOP
            select token into tokenVar from device where customerEmail = alert.customerEmail;
            raise notice 'notified relay';
            alert_j := json_object_agg('alert',row_to_json(alert));
            payload := alert_j ::jsonb ||  json_object_agg('token',tokenVar) ::jsonb;
            perform pg_notify(CAST ('alerts' as text), CAST (payload as text));

        END LOOP;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

drop trigger if exists check_update on product;
CREATE TRIGGER check_update
    AFTER UPDATE ON product
    FOR EACH ROW
EXECUTE PROCEDURE check_alerts();

-- testing alert trigger
--
-- insert into alert(customerEmail,productid,maxprice) values ('ojacqueminet0@deliciousdays.com', 35,100);
--
update product
set price = 1000
where id =1;

update product
set price = 1
where id =1;
