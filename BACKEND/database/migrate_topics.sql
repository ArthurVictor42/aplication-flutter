-- Migração dos temas do Quiz Motion
-- Faça backup do banco antes de executar.
-- Este script normaliza nomes conhecidos e NÃO apaga perguntas automaticamente.

USE questionapp;

START TRANSACTION;

UPDATE question
SET tema = 'Inglês'
WHERE LOWER(TRIM(tema)) IN ('ingles', 'english', 'english (us)', 'língua inglesa', 'lingua inglesa');

UPDATE question
SET tema = 'Gerais'
WHERE LOWER(TRIM(tema)) IN ('gerais', 'geral', 'general', 'conhecimentos gerais', 'cultura geral');

UPDATE question
SET tema = 'Tecnologia'
WHERE LOWER(TRIM(tema)) IN ('tecnologia', 'tech', 'technology', 'informática', 'informatica');

COMMIT;

-- Confira os temas restantes. Revise as perguntas antes de removê-las ou reclassificá-las.
SELECT tema, COUNT(*) AS quantidade
FROM question
GROUP BY tema
ORDER BY tema;

-- Para listar perguntas que ainda não pertencem aos três temas oficiais:
SELECT id_questao, cabecalho, tema
FROM question
WHERE tema NOT IN ('Inglês', 'Gerais', 'Tecnologia')
ORDER BY tema, id_questao;
