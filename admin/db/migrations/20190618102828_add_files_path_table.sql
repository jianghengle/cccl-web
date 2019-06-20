-- +micrate Up
ALTER TABLE files ADD COLUMN path varchar(512) DEFAULT NULL;


-- +micrate Down
ALTER TABLE files DROP COLUMN path;
