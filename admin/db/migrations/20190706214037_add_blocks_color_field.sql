-- +micrate Up
ALTER TABLE blocks ADD COLUMN color varchar(128) DEFAULT NULL;


-- +micrate Down
ALTER TABLE blocks DROP COLUMN color;
