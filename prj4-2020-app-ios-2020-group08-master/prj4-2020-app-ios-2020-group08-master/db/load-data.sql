alter table customer drop constraint customer_email_fkey;
alter table seller drop constraint seller_email_fkey;

copy category from '/home/pi/prj4-g8-db-scripts/mockdata/category.csv' DELIMITERS ',' CSV HEADER;
copy location from '/home/pi/prj4-g8-db-scripts/mockdata/location.csv' DELIMITERS ',' CSV HEADER;
copy customer from '/home/pi/prj4-g8-db-scripts/mockdata/customer.csv' DELIMITERS ',' CSV HEADER;
copy seller from '/home/pi/prj4-g8-db-scripts/mockdata/seller.csv' DELIMITERS ',' CSV HEADER;

insert into role values('Customer');
insert into role values('Seller');
insert into "user"(email,password) select email, '$2b$10$FdrQTVOvSN6QpPM6o8en7OqFiD4GqdZsvpjra1aXgSjlhzXbfMHVy' from customer;
insert into "user"(email,password) select email, '$2b$10$FdrQTVOvSN6QpPM6o8en7OqFiD4GqdZsvpjra1aXgSjlhzXbfMHVy' from seller;
alter table customer
	add constraint customer_email_fkey
		foreign key (email) references "user" (email);


alter table seller
        add constraint seller_email_fkey
                foreign key (email) references "user" (email);

insert into userrole(roleid,userid)  select 'Customer', email from customer;
insert into userrole(roleid,userid)  select 'Seller', email from seller;

copy product from '/home/pi/prj4-g8-db-scripts/mockdata/product.csv' DELIMITERS ',' CSV HEADER;

--copy alert from '/home/pi/prj4-g8-db-scripts/mockdata/alert.csv' DELIMITERS ',' CSV HEADER;

