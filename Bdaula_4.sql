SELECT "Senac";


CREATE Procedure repete_mensagem(vez int)
begin
    DECLARE conta int DEFAULT 1;
    DECLARE texto VARCHAR(300) DEFAULT "";
    while conta <= vez DO
        set texto = CONCAT(texto, "Senac ");
        SET conta = conta + 1;
    end WHILE;
    SELECT texto;
END;


call repete_mensagem(10);


SELECT * from payment;


/* Crie uma procedure para gerar o total pago
por gerente de um determinado cliente.*/


--Meu código
SELECT * FROM payment WHERE customer_id = 1;


CREATE Procedure total_pago_por_gerente(cliente_id int)
begin
    DECLARE total_pago DECIMAL(10,2) DEFAULT 0;
    SELECT SUM(amount) INTO total_pago
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    JOIN staff s ON c.store_id = s.store_id
    WHERE c.customer_id = cliente_id;
   
    SELECT total_pago AS Total_Pago;
END;


call total_pago_por_gerente(5);


select staff_id,
            sum(amount)
            from payment
            where customer_id = 1
            GROUP BY staff_id;


CREATE Procedure total_pago(id int)
begin
    select payment.staff_id as "Código do Gerente",
            staff.first_name as Nome,
            sum(payment.amount)
            from payment
            inner join staff USING(staff_id)
            where payment.customer_id = id
            GROUP BY payment.staff_id;
END;


call total_pago(5);






/* Exercicio 1:Faça uma procedure para gerar o nome dos generos
dos filmes que um cliente assistiu.*/
CREATE Procedure filme_assistido(id int)
    begin
        SELECT
        category.name as categoria
        FROM customer
        INNER JOIN rental on customer.customer_id = rental.customer_id
        INNER JOIN inventory on rental.inventory_id = inventory.inventory_id
        INNER JOIN film_category on inventory. film_id = film_category. film_id
        INNER JOIN category on film_category.category_id = category.category_id
        WHERE customer. customer_id = id
        GROUP BY category.name;


    END;
CALL filme_assistido(5);


/*
Exercicio 2: Consulta com Parametro de Entrada (IN)
Objetivo: Praticar parametros simples e juncao de tabelas.
Contexto: Crie uma procedure chamada sp_filmes_por_ator que receba o primeiro e o ultimo nome de um ator e retorne todos os filmes que ele atuou
Tabelas utilizadas: actor, film_actor, film.
Requisitos:
Parametros de entrada: p_first_name VARCHAR(45) e p_last_name VARCHAR(45).
Retorno: film_id, title, release_year e rating.
*/


CREATE PROCEDURE sp_filmes_por_ator(IN p_first_name VARCHAR(45), IN p_last_name VARCHAR(45))
BEGIN
    SELECT
        f.film_id,
        f.title,
        f.release_year,
        f.rating
    FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa. actor_id
    INNER JOIN film AS f ON fa.film_id = f.film_id
    WHERE a.first_name = p_first_name AND a.last_name = p_last_name
    ORDER BY f. title;
END;


call sp_filmes_por_ator('NICK', 'WAHLBERG');






/*Exercicio 3: Logica Condicional (IF/ELSE) e Classificacão
Objetivo: Trabalhar com estruturas de controle de fluxo dentro do bloco de execucão.
Contexto: Crie uma procedure chamada sp_classificar_fidelidade que avalie um cliente pelo numero de locacoes at:
Tabelas utilizadas: rental.
Requisitos:
Parametro de entrada: p_eustomer_id INT.
Parametro de saida: p_status VARCHAR(20).
Regra de negocio:
    Acima de 30 locações: 'VIP'
    Entre 15 e 30 locações: 'REGULAR'
    Menos de 15 locações: 'NOVO'
*/


CREATE PROCEDURE sp_classificar_fidelidade(IN id_cliente INT)
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM rental
    WHERE customer_id = id_cliente;


    IF total > 30 THEN
        SELECT 'VIP' AS status;
    ELSEIF total >= 15 THEN
        SELECT 'REGULAR' AS status;
    ELSE
        SELECT 'NOVO' AS status;
    END IF;
END;


CALL sp_classificar_fidelidade(6);

