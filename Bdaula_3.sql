SELECT * FROM actor;


SELECT CONCAT(first_name, ' ', last_name) from actor WHERE actor_id = 4;
CREATE Function ator_nome(id int)
RETURNS varchar(70)
DETERMINISTIC
begin
    DECLARE wvalor VARCHAR(70);
    SELECT CONCAT(first_name, ' ', last_name) into wvalor
        from actor WHERE actor_id = id;
    RETURN wvalor;
end;


SELECT ator_nome(4);


SELECT actor_id, ator_nome(actor_id) from actor;




-- ==========================================================================




-- Crie uma funçao para calcular a comissao do staff da tabela pagemento, sendo 7%
-- para o gerente de codigo 1 e 5% para o gerente de codigo 2


--Meu codigo
CREATE FUNCTION comissao_staff(gerente_id INT, valor_pagamento DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE comissao DECIMAL(10,2);
   
    IF gerente_id = 1 THEN
        SET comissao = valor_pagamento * 0.07;
    ELSEIF gerente_id = 2 THEN
        SET comissao = valor_pagamento * 0.05;
    ELSE
        SET comissao = 0;
    END IF;
   
    RETURN comissao;
END;


SELECT comissao_staff(1, 1000.00) AS comissao_gerente_1,
       comissao_staff(2, 1000.00) AS comissao_gerente_2;




-- ==========================================================================




--Professor
create Function comissaoo(id int,valor DECIMAL(9,2))
RETURNS DECIMAL(9,2)
DETERMINISTIC
begin
    DECLARE resultado DECIMAL(9,2);
    if id = 1 then
            set resultado = valor * 0.07;
    ELSE
            set resultado = valor * 0.05;
    end if;
    RETURN resultado;
END;


SELECT payment_id,customer_id,staff_id,amount,comissaoo(staff_id,amount) from payment where customer_id = 1;




-- ==========================================================================




/*
Exercicio 1: Contar Filmes de um Ator
Objetivo: Crie uma função chamada fn_total_filmes_ator que receba o ID de um ator
(p_actor_id INT) e retorne a quantidade total de filmes em que ele atuou.


Tabela envolvida: film_actor
Campos: actor_id
Tipo de retorno: INT
*/


Create Function fn_total_filmes_ator(p_actor_id int)
RETURNS int
DETERMINISTIC
begin
    declare valor_total_filmes int;
    select COUNT(*)
    into valor_total_filmes
    from film_actor
    where actor_id = p_actor_id;


    RETURN valor_total_filmes;
END;


SELECT fn_total_filmes_ator(1);


SELECT first_name, fn_total_filmes_ator(actor_id) from actor;




-- ==========================================================================




/*
Exercicio 2: Contar Filmes de uma Categoria
Objetivo: Crie uma função chamada fn_total_filmes_categoria que receba o ID de uma
categoria (p_category_id INT) e retorne a quantidade total de filmes vinculados a essa categoria.


Tabela envolvida: film_category
Campos: category_id
Tipo de retorno: INT
*/


Create Function fn_total_filmes_categoria(p_category_id INT)
RETURNS INT
DETERMINISTIC
begin
    DECLARE valor_total_Categoria int;
    SELECT count(*)
    into valor_total_Categoria
    from film_category
    where category_id = p_category_id;


    return valor_total_Categoria;
END;


SELECT fn_total_filmes_categoria(1);


SELECT category_id,name,fn_total_filmes_categoria(category_id) from category;




-- ==========================================================================




/*
Exercicio 3: Contar Alugueis de um Cliente
Objetivo: Crie uma função chamada fn_total_alugueis_cliente que receba o ID de um cliente
(p_customer_id INT) e retorne o numero total de locações que ele realizou.


Tabela envolvida: rental
Campos: customer_id
Tipo de retorno: INT
*/


CREATE Function fn_total_alugueis_cliente(p_customer_id INT)
RETURNS INT
DETERMINISTIC
begin
    DECLARE valor_total_aluguel int;
    SELECT COUNT(*)
    into valor_total_aluguel
    from rental
    WHERE customer_id = p_customer_id;


    return valor_total_aluguel;
END;


SELECT fn_total_alugueis_cliente(1);


select rental_id,customer_id, fn_total_alugueis_cliente(customer_id) from rental;







