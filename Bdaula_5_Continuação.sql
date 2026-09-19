show TRIGGERS;


SELECT * from actor;


CREATE TABLE copiar_actor AS SELECT * FROM actor where actor_id = 1;


SELECT * from actor where actor_id = 1;


SELECT * from copiar_actor;


delete from copiar_actor where actor_id = 1;


TRUNCATE TABLE copiar_actor;


DESCRIBE copiar_actor;


ALTER Table copiar_actor add COLUMN usuario VARCHAR(50) not null;
alter table copiar_actor add COLUMN data_alteracao DATE not null;


CREATE TRIGGER atualiza_copia_actor AFTER UPDATE ON actor FOR EACH ROW
BEGIN
    INSERT INTO copiar_actor (actor_id,first_name,last_name,last_update,usuario,data_alteracao)
    VALUES (OLD.actor_id,OLD.first_name,OLD.last_name,OLD.last_update,'Giovanna',NOW());
END;


SELECT * from copiar_actor;


UPDATE actor set first_name = "Giovanna" where actor_id = 2;





