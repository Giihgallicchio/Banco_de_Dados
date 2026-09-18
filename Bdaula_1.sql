select * from actor;


-- Gere uma consula dos pagamentos realizados pelo cliente de codigo = 5
-- na listagem, deve  conter o nome completo do cliente


SELECT
    customer.first_name,
    customer.last_name,
    payment.amount,
    payment.payment_date,
    payment.last_update
from customer
inner join payment
    on customer.customer_id= payment.customer_id
    WHERE payment.customer_id = 5;


--Professor
SELECT * from payment
    inner join customer USING(customer_id)
    WHERE customer_id =5;


-- Gere um relatorio com o total pago por gerente e crie uma coluna de 5%
-- de comissao para cada gerente, assim mostre o nome completo do gerente,
-- total pago e a comissao


SELECT * from staff;
select staff_id,
    CONCAT(staff.first_name, ' ', staff.last_name) as full_name,
    FORMAT(sum(amount),2) as Total,
    FORMAT((sum(amount) * 0.05),2) as Comissão
    from payment
    INNER JOIN staff USING(staff_id)
    GROUP BY staff_id;


-- Gere um relatorio com o endereço completo do cliente de codigo 4


SELECT * from city;


select
    customer.first_name,
    customer.last_name,
    address.address,
    address.district,
    city.city,
    address.postal_code
from customer
inner join address
    on customer.address_id =
address.address_id
inner join city
    on address.city_id = city.city_id
WHERE customer.customer_id = 4;

