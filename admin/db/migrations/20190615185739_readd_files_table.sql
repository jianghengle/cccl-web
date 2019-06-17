-- +micrate Up
DROP TABLE files;
CREATE TABLE files(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(512) DEFAULT NULL,
  file_type VARCHAR(64) DEFAULT NULL,
  url TEXT,
  info VARCHAR(512) DEFAULT NULL,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (id)
);

-- +micrate Down
DROP TABLE files;
CREATE TABLE files(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(512) DEFAULT NULL,
  file_type VARCHAR(64) DEFAULT NULL,
  url TEXT,
  created_at DATETIME,
  updated_at DATETIME,
  PRIMARY KEY (id)
);