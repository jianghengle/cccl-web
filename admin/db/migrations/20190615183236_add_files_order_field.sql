-- +micrate Up
ALTER TABLE files ADD column comment VARCHAR(16) DEFAULT NULL,


-- +micrate Down
ALTER TABLE files DROP COLUMN comment;
