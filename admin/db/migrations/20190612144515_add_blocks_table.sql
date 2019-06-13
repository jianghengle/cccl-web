-- +micrate Up
CREATE TABLE blocks(
  id INT NOT NULL AUTO_INCREMENT,
  type VARCHAR(16) DEFAULT NULL,
  name VARCHAR(256) DEFAULT NULL,
  time DATETIME,
  content MEDIUMTEXT,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (id)
);


-- +micrate Down
DROP TABLE blocks;
