SELECT * from actor;    


SELECT actor_id as codigo,
    CONCAT(first_name, ' ', last_name) as 'Nome Completo'
    from actor
    ORDER BY 2;


--Comando para criar uma cópia da tabela actor
CREATE Table ator_copia as select * from actor;


SELECT * from ator_copia;


--Comando para atualizar o nome do ator com id 1
UPDATE ator_copia set first_name = 'PEnelope SILva' WHERE actor_id = 1;


UPDATE actor set first_name = 'Penelope2' WHERE actor_id = 1;


create View ator_lista as
SELECT actor_id as codigo,
    CONCAT(first_name, ' ', last_name) as 'Nome Completo'
    from actor
    ORDER BY 2;


--Comando para selecionar o ator com id 1 da view ator_lista
SELECT * from ator_lista WHERE codigo = 1;




UPDATE actor set first_name = 'Penelope3' WHERE actor_id = 1;


UPDATE ator_lista set `Nome Completo` = 'Penelope4' WHERE codigo = 1;


-- Crie uma view para gerar o total de pagamentos por gerente, acrescente uma coluna comissao de 5%
-- Meu Código
SELECT * from staff;
select * from payment;


select total_pagamentos_gerente, comissao from (
    select staff_id, format(sum(amount),2) as total_pagamentos_gerente, format(sum(amount)*0.05,2) as comissao
    from payment
    group by staff_id
) as pagamentos_por_gerente;


create VIEW total_pagamentos_gerente as
    select staff_id, format(sum(amount),2) as total_pagamentos_gerente, format(sum(amount)*0.05,2) as comissao
    from payment
    group by staff_id


SELECT * from total_pagamentos_gerente;








-- Professor Código
SELECT payment.staff_id,
    staff.first_name as Gerente,
    FORMAT(sum(payment.amount),2) as total_pagamentos_gerente,
    FORMAT(sum(payment.amount) * 0.05,2) as comissao
    from payment
    INNER JOIN staff USING(staff_id)
    group by payment.staff_id;


create View pag_comissao as
SELECT payment.staff_id,
    FORMAT(sum(payment.amount),2) as total_pagamentos_gerente,
    FORMAT(sum(payment.amount) * 0.05,2) as comissao
    from payment
    INNER JOIN staff USING(staff_id)
    group by payment.staff_id;


SELECT * from pag_comissao;


update pag_comissao set comissao = 2000 where staff_id = 1;




-- Exercício 1
-- Crie uma view chamada vw_clientes_endereco que apresente
-- customer_id, Nome Completo, email, Cidade e País.
-- utilizar as tabelas customer, address, city e country.


-- Meu Código
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as 'Nome Completo',
    c.email,
    ci.city as Cidade,
    co.country as País
from customer c
inner join address a on c.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id


create View vw_clientes_endereco as
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as 'Nome Completo',
    c.email,
    ci.city as Cidade,
    co.country as País
from customer c
inner join address a on c.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country co on ci.country_id = co.country_id


SELECT * from vw_clientes_endereco;
