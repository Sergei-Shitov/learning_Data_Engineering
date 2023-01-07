--***!!! DON'T APPLY CODE BELOW. IT DOSEN'T GIVE THE RESULT!!!***--

--*** YOU CAN TRY TO READ IT AND LEAVE A COMMENT ***--

--*********insert data*********

--insert to categories

insert into categories
select 100 + row_number() over (), 
	   category 
from (select distinct category 
	  from orders) a;

--insert to sub-categories

insert into sub_categories
select 200 + row_number() over (), 
	   subcategory, 
	   cat_id 
from (select distinct subcategory, 
	  		 cat_id 
	  from orders
	  inner join categories
	  on categories.cat_name = orders.category) a;
	   
--insert to products
			
insert into products
select sub_cat_id * 100000 + row_number() over (), 
	   product_name, 
	   sub_cat_id, 
	   product_id
from (select distinct  product_name, 
			 sub_cat_id, 
	   		 product_id  
	  from orders
	  inner join sub_categories 
	  on sub_categories.sub_cat_name = orders.subcategory) a;

-- insert to ship mode
			
insert into ship_mode 
select 300 + row_number() over (), 
	   ship_mode 
from (select distinct ship_mode 
	  from orders) a;

-- insert to customers 

insert into customers 
select customer_id, 
	   customer_name
from (select distinct customer_id, 
			 customer_name 
	  from orders) a;

-- insert to segment

insert into segment 
select 400 + row_number() over (), 
	   segment 
from (select distinct segment 
	  from orders) a;

-- insert to managers

insert into managers  
select 2000 + row_number() over (), 
	   person 
from (select distinct person 
	  from people) a;

-- insert to countries

insert into countries 
select 800 + row_number() over (), 
	   country 
from (select distinct country 
	  from orders) a;

--insert regions

insert into regions  
select 700 + row_number() over (), 
	   region, 
	   country_id 
from (select distinct region,
			 country_id 
	  from orders
	  join countries 
	  on countries.country_name = orders.country 
) a;

--insert to resposibility

insert into resposibilities 
select region_id,
	   manager_id 
from (select distinct region_id,
			 manager_id 
	  from people
	  join managers 
	  on managers.manager_name = people.person 
	  join regions 
	  on regions.region_name = people.region 
	  ) a;

--insert to states

insert into states 
select 500 + row_number() over (), 
	   state, 
	   region_id 
from (select distinct state, 
			 region_id 
	  from orders
	  join regions 
	  on orders.region = regions.region_name 
) a;

--insert to cities

insert into cities  
select 1000 + row_number() over (), 
	   city, 
	   region_id 
from (select distinct city, 
			 region_id
	  from orders
	  join regions  
	  on regions.region_name = orders.region 
) a;

--insert to postal code

insert into postal_codes  
select 1000 + row_number() over (), 
	   postal_code, 
	   city_id 
from (select distinct postal_code, 
			 city, 
			 state, 
			 city_id 
	  from orders
	  join cities  
	  on cities.city_name  = orders.city
	  join states 
	  on orders.state = states.state_name
) a;

--insert to sales

insert into sales  
select row_id,
	   order_id, 
	   order_date, 
	   ship_id ,
	   ship_date,
	   product_id,
	   segment_id,
	   customer_id,
	   postal_code_id,
	   sales,
	   profit,
	   quantity,
	   discount 
from (select distinct orders.row_id,
			 orders.order_id, 
	   		 orders.order_date, 
	   		 ship_mode.ship_id ,
	   		 orders.ship_date,
	   		 products.product_id,
	   		 segment.segment_id,
	   		 customers.customer_id,
	   		 postal_codes.postal_code_id,
	   		 orders.sales,
	   		 orders.profit,
	   		 orders.quantity,
	   		 orders.discount 
	  from orders
	  join ship_mode  
	  on orders.ship_mode = ship_mode.ship_name
	  join products  
	  on orders.product_id = products.product_id_old 
	  and orders.product_name = products.product_name 
	  join segment
	  on orders.segment = segment.segment_name 
	  join customers 
	  on orders.customer_id = customers.customer_id 
	  join postal_codes 
	  on orders.postal_code = postal_codes.postal_code
	  join cities 
	  on orders.city = cities.city_name 
) a;

