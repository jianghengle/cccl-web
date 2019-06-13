-- +micrate Up
ALTER TABLE blocks CHANGE `type` `category` VARCHAR(16) DEFAULT NULL;


-- +micrate Down
ALTER TABLE blocks CHANGE `category` `type` VARCHAR(16) DEFAULT NULL;
