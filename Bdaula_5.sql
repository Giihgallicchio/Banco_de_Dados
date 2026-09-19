create table produto (
    id int PRIMARY KEY,
    nome VARCHAR(50) not null,
    preco decimal(10, 2) not null,
    quantidade int not null
);


INSERT into produto (id, nome, preco, quantidade) VALUES
(1, "Produto A", 10.00, 100),
(2, "Produto B", 20.00, 200),
(3, "Produto C", 30.00, 300),
(4, "Produto D", 40.00, 400),
(5, "Produto E", 50.00, 500);


select * from produto;


CREATE Table venda (
    id int PRIMARY KEY,
    produto_id int not null,
    quantidade int not null,
    data_venda DATE not null,
    Foreign Key (produto_id) REFERENCES produto(id)
)


select * from venda;    


show TRIGGERs;


create Trigger atualiza_estoque after INSERT on venda for each ROW
BEGIN
    UPDATE produto set quantidade = quantidade - new.quantidade where id = new.produto_id;
END;


INSERT into venda (id, produto_id, quantidade, data_venda) VALUES
(1, 1, 10, now());


SELECT * from venda;


SELECT * from produto;


create Trigger repoe_estoque AFTER DELETE on venda for each ROW
BEGIN
    UPDATE produto set quantidade = quantidade + old.quantidade where id = old.produto_id;
END;


INSERT into venda (id, produto_id, quantidade, data_venda) VALUES
(2, 3, 20, now());


DELETE FROM venda where id = 1;


/* Criar Trigger para atualizar o estoque quando uma venda for atualizada */


create Trigger atualiza_estoque_update after UPDATE on venda for each ROW
BEGIN
    UPDATE produto set quantidade = quantidade - (new.quantidade - old.quantidade) where id = new.produto_id;
END;


SELECT * FROM venda WHERE id = 2;
UPDATE venda SET quantidade = 30 WHERE id = 2;
SELECT * FROM produto WHERE id = 3;
UPDATE venda SET quantidade = 25 WHERE id = 2;




/*Criar uma Trigger para auditar a tabela produto, registrando as alterações em uma tabela de log*/




create table copia_produto (
    id int PRIMARY KEY,
    nome VARCHAR(50) not null,
    preco decimal(10, 2) not null,
    quantidade int not null,
    usuario VARCHAR(50) not null,
    data_alteracao DATETIME not null
);


create Trigger audita_produto after UPDATE on produto for each ROW
BEGIN
    DECLARE valor_quantidade int DEFAULT 0;
    DECLARE valor_nome VARCHAR(50) DEFAULT '';
    DECLARE valor_preco decimal(10, 2) DEFAULT 0;
    if new.nome <> old.nome then
        set valor_nome = OLD.nome;
    end if;
    if new.quantidade <> old.quantidade then
        set valor_quantidade = OLD.quantidade;
    end if;


    INSERT INTO copia_produto (id, nome, preco, quantidade, usuario, data_alteracao)
    VALUES (OLD.id, OLD.nome, OLD.preco, valor_quantidade,current_USER, NOW());
END;


drop TRIGGER audita_produto;
SELECT CURRENT_USER;


SELECT * from copia_produto;


SELECT * from produto;


UPDATE produto set quantidade = 1000 where id = 1;
UPDATE produto set preco = 40 where id = 4;


/* 1. Trigger para impedir a inserção de produtos com nomes duplicados */
CREATE Trigger impedir_nome_duplicado before INSERT on produto for each ROW
begin
    declare nome_existente int;
    select count(*) into nome_existente from produto where nome = new.nome;
    if nome_existente > 0 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nome de produto duplicado.';
    end if;
end;


SELECT * from produto;


insert into produto (id, nome, preco, quantidade) VALUES (6, "Produto A", 60.00, 600);


/* 2. Trigger para impedir a exclusão de produtos com estoque positivo */
CREATE Trigger impedir_exclusao_estoque before DELETE on produto for each ROW
begin
    declare estoque_existente int;
    select quantidade into estoque_existente from produto where id = old.id;
    if estoque_existente > 0 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir produtos com estoque positivo.';
    end if;
end;


SELECT * from produto;


DELETE FROM produto WHERE id = 5;


SELECT * from produto;




/* 3. Trigger para impedir atualização de preço para valores negativos */
CREATE Trigger impedir_preco_negativo before UPDATE on produto for each ROW
begin
    if new.preco < 0 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço não pode ser negativo.';
    end if;
end;


UPDATE produto SET preco = -10 WHERE id = 5;


SELECT * FROM produto WHERE id = 5;


 

