-- +micrate Up
ALTER TABLE blocks CONVERT TO CHARACTER SET utf8;


-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
