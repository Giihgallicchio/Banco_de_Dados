/*1) Clientes que mais alugaram filmes
Crie uma VIEW chamada vw_clientes_frequentes que exiba:

ID do cliente
Nome completo do cliente
E-mail
Quantidade total de locações realizadas
A view deve mostrar apenas clientes com mais de 20 locações.

Resultado esperado:
*/

select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as 'Nome Completo',
    c.email,
    count(r.rental_id) as 'Quantidade de Locações'
from customer c
inner join rental r on c.customer_id = r.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;

create View vw_clientes_frequentes as
select *
from (
    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as 'Nome Completo',
        c.email,
        count(r.rental_id) as 'Quantidade de Locações'
    from customer c
    inner join rental r on c.customer_id = r.customer_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email
) as clientes
where `Quantidade de Locações` > 20;

SELECT * from vw_clientes_frequentes;



/*- Procedure
2) Atualização automática de taxa de aluguel
Crie uma PROCEDURE chamada sp_reajustar_rental_rate.*/

SELECT film_id, title, rental_rate
FROM film
WHERE film_id = 1;

CREATE PROCEDURE sp_reajustar_rental_rate(IN percentual DECIMAL(5,2))
BEGIN
    UPDATE film
    SET rental_rate = rental_rate + (rental_rate * percentual / 100);
END;

CALL sp_reajustar_rental_rate(10);

SELECT film_id, title, rental_rate
FROM film
WHERE film_id = 1;



/*3) Crie uma procedure chamada vw_top_10_filmes_alugados que apresente os 10 filmes mais alugados contendo:

ID do filme
Título
Quantidade de aluguéis
Ordene do maior para o menor número de locações.*/

CREATE PROCEDURE vw_top_10_filmes_alugados()
BEGIN
    SELECT
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS 'Quantidade de Aluguéis'
    FROM film f
    INNER JOIN inventory i ON f.film_id = i.film_id
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY
        f.film_id,
        f.title
    ORDER BY COUNT(r.rental_id) DESC
    LIMIT 10;
END;

CALL vw_top_10_filmes_alugados();



/*Function
4) Cliente VIP por valor gasto
Crie uma FUNCTION chamada fn_classificacao_cliente.

Retorno:
Uma classificação do cliente de acordo com o valor total gasto:

Valor Gasto Classificação
Até 50  Bronze
Acima de 50 até 100 Prata
Acima de 100 até 200    Ouro
Acima de 200    Diamante
*/

Create Function fn_classificacao_cliente(p_customer_id int)
RETURNS varchar(20)
DETERMINISTIC
begin
    declare valor_total decimal(10,2);

    select SUM(amount)
    into valor_total
    from payment
    where customer_id = p_customer_id;

    IF valor_total <= 50 THEN
        RETURN 'Bronze';

    ELSEIF valor_total <= 100 THEN
        RETURN 'Prata';

    ELSEIF valor_total <= 200 THEN
        RETURN 'Ouro';

    ELSE
        RETURN 'Diamante';
    END IF;

END;

SELECT fn_classificacao_cliente(1);

SELECT customer_id, fn_classificacao_cliente(customer_id)
FROM customer;



/*5) Crie uma FUNCTION chamada fn_indice_popularidade_filme.
Retorno:
Um valor decimal representando o índice de popularidade calculado pela fórmula:

Índice = (Quantidade de Aluguéis × 0,7) + (Quantidade de Clientes Distintos × 0,3)
Onde:
Quantidade de Aluguéis = número total de vezes que o filme foi alugado.
Quantidade de Clientes Distintos = total de clientes diferentes que alugaram o filme.
*/

Create Function fn_indice_popularidade_filme(p_film_id int)
RETURNS decimal(10,2)
DETERMINISTIC
begin
    declare quantidade_alugueis int;
    declare quantidade_clientes int;
    declare indice decimal(10,2);

    select COUNT(r.rental_id)
    into quantidade_alugueis
    from inventory i
    inner join rental r on i.inventory_id = r.inventory_id
    where i.film_id = p_film_id;

    select COUNT(*)
    into quantidade_clientes
    from (
        select r.customer_id
        from inventory i
        inner join rental r on i.inventory_id = r.inventory_id
        where i.film_id = p_film_id
        group by r.customer_id
    ) as clientes;

    SET indice = (quantidade_alugueis * 0.7) +
                 (quantidade_clientes * 0.3);

    RETURN indice;
END;

SELECT fn_indice_popularidade_filme(1);

SELECT film_id, title, fn_indice_popularidade_filme(film_id)
FROM film;


