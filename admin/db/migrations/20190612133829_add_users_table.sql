-- +micrate Up
CREATE TABLE users(
  id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(256) DEFAULT NULL,
  encrypted_password VARCHAR(1024) DEFAULT NULL,
  auth_token VARCHAR(1024) DEFAULT NULL,
  role VARCHAR(16) DEFAULT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (id)
);


-- +micrate Down
DROP TABLE users;