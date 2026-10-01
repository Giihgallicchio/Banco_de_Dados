/*
1. View
Crie uma view chamada vw_clientes_ativos que exiba:
• Nome do cliente
• Sobrenome
• E-mail
• Cidade
• Status do cliente (active)
Utilize as tabelas customer, address e city.
Pergunta: Escreva o comando SQL para criar essa view.
*/
SELECT
    customer.first_name,
    customer.last_name,
    customer.email,
    city.city,
    customer.active
FROM customer
INNER JOIN address
    ON customer.address_id = address.address_id
INNER JOIN city
    ON address.city_id = city.city_id;

CREATE VIEW vw_clientes_ativos AS
SELECT
    customer.first_name,
    customer.last_name,
    customer.email,
    city.city,
    customer.active
FROM customer
INNER JOIN address
    ON customer.address_id = address.address_id
INNER JOIN city
    ON address.city_id = city.city_id;

SELECT * FROM vw_clientes_ativos;

/*
2. Utilização de View

Considerando a view vw_clientes_ativos criada na questão anterior:
Pergunta: Escreva uma consulta SQL que liste apenas os clientes ativos
da cidade
"London", ordenados pelo sobrenome
*/
SELECT *
FROM vw_clientes_ativos
WHERE active = 1
    AND city = 'London'
ORDER BY last_name;

/*
3. Function
Crie uma function chamada fn_total_filmes_cliente que receba o ID de um
cliente e
retorne a quantidade total de filmes alugados por ele.
Tabelas envolvidas:
• customer
• rental
• inventory
• film
Pergunta: Escreva o código SQL da função.
*/
SELECT COUNT(film.film_id) AS total_filmes
FROM customer
INNER JOIN rental
    ON customer.customer_id = rental.customer_id
INNER JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
    ON inventory.film_id = film.film_id
WHERE customer.customer_id = 1;

CREATE FUNCTION fn_total_filmes_cliente(p_customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_filmes INT;

    SELECT COUNT(film.film_id)
    INTO total_filmes
    FROM customer
    INNER JOIN rental
        ON customer.customer_id = rental.customer_id
    INNER JOIN inventory
        ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film
        ON inventory.film_id = film.film_id
    WHERE customer.customer_id = p_customer_id;

    RETURN total_filmes;
END;

SELECT fn_total_filmes_cliente(1);

/*
4. Procedure
Crie uma stored procedure chamada sp_filmes_categoria que receba o nome
de uma
categoria (por exemplo, 'Action') e retorne:
• Título do filme
• Ano de lançamento
• Categoria
Utilize as tabelas:
• film
• film_category
• category
Pergunta: Desenvolva o código da procedure e mostre como ela seria
executada.
*/
SELECT
    film.title,
    film.release_year,
    category.name
FROM film
INNER JOIN film_category
    ON film.film_id = film_category.film_id
INNER JOIN category
    ON film_category.category_id = category.category_id
WHERE category.name = 'Action';

CREATE PROCEDURE sp_filmes_categoria(IN nome_categoria VARCHAR(25))
BEGIN
    SELECT
        film.title,
        film.release_year,
        category.name
    FROM film
    INNER JOIN film_category
        ON film.film_id = film_category.film_id
    INNER JOIN category
        ON film_category.category_id = category.category_id
    WHERE category.name = nome_categoria;
END;

CALL sp_filmes_categoria('Action');

/*
5. Trigger
A tabela payment registra os pagamentos realizados pelos clientes.
Crie uma tabela de auditoria chamada payment_log contendo:
SQL
payment_id
customer_id
amount
data_inclusao
``
Mostrar mais linhas
Pergunta: Desenvolva uma trigger que registre automaticamente um log
sempre que
um novo pagamento for inserido na tabela payment.
*/
CREATE TABLE payment_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    customer_id INT,
    amount DECIMAL(5,2),
    data_inclusao DATETIME
);

SELECT * FROM payment_log;

CREATE TRIGGER registra_payment_log
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    INSERT INTO payment_log (
        payment_id,
        customer_id,
        amount,
        data_inclusao
    )
    VALUES (
        NEW.payment_id,
        NEW.customer_id,
        NEW.amount,
        NOW()
    );
END;

SHOW TRIGGERS;

/*
6. GRANT e REVOKE
Foi criado um usuário chamado:
SQL
'analista'@'localhost'
Mostrar mais linhas
Pergunta:
a) Conceda permissão apenas de leitura nas tabelas customer, film e
category.
b) Revogue posteriormente o acesso à tabela film.
Escreva os comandos SQL correspondentes.
*/
GRANT SELECT ON sakila.customer
TO 'analista'@'localhost';

GRANT SELECT ON sakila.film
TO 'analista'@'localhost';

GRANT SELECT ON sakila.category
TO 'analista'@'localhost';

REVOKE SELECT ON sakila.film
FROM 'analista'@'localhost';

/*
7. Questão Integrada (View + Function + Procedure + Segurança)
Uma empresa deseja disponibilizar aos analistas apenas informações
resumidas dos
clientes.
Considere que:
• Existe uma função que retorna o total de aluguéis de um cliente.
• Deve ser criada uma view contendo:
o customer_id
o nome completo
o total de aluguéis
• Apenas o usuário analista poderá consultar essa view.
Pergunta:
Escreva:
1. A criação da view utilizando a função.
2. O comando GRANT para o usuário analista.
3. O comando REVOKE para remover posteriormente esse acesso
*/
CREATE VIEW vw_resumo_clientes AS
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS nome_completo,
    fn_total_alugueis_cliente(customer_id) AS total_alugueis
FROM customer;

SELECT * FROM vw_resumo_clientes;
SELECT * FROM vw_resumo_clientes;]

GRANT SELECT ON sakila.vw_resumo_clientes
TO 'analista'@'localhost';

REVOKE SELECT ON sakila.vw_resumo_clientes
FROM 'analista'@'localhost';
