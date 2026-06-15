drop table if exists zepto;

create table zepto
(
 sku_id serial primary key,
 category varchar(120),
 name varchar(150) not null,
 mrp numeric(8,2),
 discountpercent numeric(5,2),
 availablequantity int,
 discountedsellingprice numeric(10,2),
 weightingms int,
 outofstock boolean,
 quantity int
);



copy zepto(category,name,mrp,discountpercent,availablequantity,discountedsellingprice,weightingms,outofstock,quantity)
from 'C:/Zepto data set/Zepto/zepto_v2.csv'
delimiter ','
csv header;

--data exportation

select count(*) from zepto;

select * from zepto
where name is null
or category is null
or mrp is null
or discountpercent is null
or availablequantity is null
or discountedsellingprice is null 
or weightingms is null
or outofstock is null
or quantity is null;

--different category from zepto

select category from zepto 
group by category
order by category asc;

--products in stock vs products out of stock

select outofstock,count(sku_id)
from zepto
group by outofstock;

--products name present multiple times

select name,count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--products with marp is 0

select name,mrp from zepto
where mrp=0 or discountedsellingprice=0;

delete from zepto
where mrp=0;

--contert paise to rupee
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

--finding the top 10 best-value products based on the discount percentage
select name,discountpercent from zepto
order by discountpercent desc
limit 10;

--What are the products with high mrp products but out of stock

select name,category,mrp
from zepto
where outofstock=true and mrp>300
order by mrp desc;

--calcualte estimate revenue for each category
select category,sum(discountedsellingprice*availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Find all products where mrp is greater than 500 and discount is less than 10%
select * from zepto
where mrp>500  and discountpercent<10
order by mrp desc,discountpercent desc;

--find the top 5 category offering the highest average discount percentage

select category,round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--find the price per gram for products above 100g and sort by best value

select name,weightingms,discountedsellingprice,round((discountedsellingprice/weightingms),2) as price_per_gram
from zepto
where weightingms>=100
order by price_per_gram;

--group the products into categories like low,medium,bulk
select distinct name,weightingms,
case when weightingms<1000 then 'low'
when weightingms<5000 then 'medium'
else 'bulk'
end as weight_category
from zepto;

--what is the total inventory weight per category

select category,sum(weightingms*availablequantity) as total_inventory
from zepto
group by category
order by total_inventory;







