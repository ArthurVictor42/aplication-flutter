CREATE DATABASE IF NOT EXISTS quiz_motion
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE quiz_motion;

CREATE TABLE IF NOT EXISTS question (
    id_questao INT NOT NULL AUTO_INCREMENT,
    cabecalho VARCHAR(200) NOT NULL,
    tema VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_questao)
);

CREATE TABLE IF NOT EXISTS alternativa (
    id_alternativa INT NOT NULL AUTO_INCREMENT,
    id_questao INT NOT NULL,
    texto_alternativa VARCHAR(100) NOT NULL,
    correta BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id_alternativa),
    CONSTRAINT fk_alternativa_question
      FOREIGN KEY (id_questao) REFERENCES question(id_questao)
);
