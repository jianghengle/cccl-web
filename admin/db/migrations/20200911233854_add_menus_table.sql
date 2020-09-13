-- +micrate Up
CREATE TABLE menus(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(256) DEFAULT NULL,
  parent_id INT DEFAULT NULL,
  menu_index INT DEFAULT 0,
  link VARCHAR(1024) DEFAULT NULL,
  block_id INT DEFAULT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (id)
);



-- +micrate Down
DROP TABLE blocks;
