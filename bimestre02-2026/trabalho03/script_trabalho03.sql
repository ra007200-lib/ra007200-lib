
-- QUESTÃO 1: Consultar empréstimos devolvidos ou pendentes realizados a partir de 20/10/2026.
-- Os parênteses garantem que o filtro de data seja aplicado aos dois status.
-- Sem os parênteses, todos os empréstimos devolvidos seriam incluídos,
-- mesmo aqueles anteriores à data informada.

SELECT
    emprestimo_id,
    emprestimo_data,
    emprestimo_status
FROM emprestimos
WHERE (emprestimo_status = 'DEVOLVIDO'
       OR emprestimo_status = 'PENDENTE')
  AND emprestimo_data >= DATE '2026-10-20';

  -- QUESTÃO 2: Consultar os empréstimos que não estão atrasados e que possuem data de devolução informada.
-- O NOT serve para excluir os empréstimos atrasados.
-- O IS NOT NULL garante que somente empréstimos com data de devolução preenchida sejam exibidos.

SELECT
    emprestimo_id,
    emprestimo_status,
    emprestimo_data_devolucao
FROM emprestimos
WHERE NOT (emprestimo_status = 'ATRASADO')
  AND emprestimo_data_devolucao IS NOT NULL;

  -- QUESTÃO 3: Consultar livros publicados entre 1900 e 2000 de determinadas editoras.
-- O BETWEEN define o intervalo de anos e o IN seleciona as editoras desejadas.

SELECT
    livro_id,
    livro_titulo,
    livro_ano_publicacao,
    editora_id
FROM livros
WHERE livro_ano_publicacao BETWEEN 1900 AND 2000
  AND editora_id IN (2, 3, 4);

-- QUESTÃO 4 
-- A: Buscar livros que possuem a palavra "estrela" no título.
-- O ILIKE permite procurar o texto sem diferenciar letras maiúsculas e minúsculas.

SELECT
    livro_id,
    livro_titulo
FROM livros
WHERE livro_titulo ILIKE '%estrela%';

-- QUESTÃO 4
-- B: Consultar livros cujo ISBN começa com 978 e possui 13 caracteres.
-- O underline (_) representa exatamente um caractere no LIKE.

SELECT
    livro_id,
    livro_titulo,
    livro_isbn
FROM livros
WHERE livro_isbn LIKE '978__________';

-- QUESTÃO 5: Simular um aumento de 10% na quantidade de livros.
-- O ROUND arredonda o resultado para duas casas decimais.
-- O TRUNC corta as casas decimais sem arredondar.

SELECT
    livro_titulo,
    livro_quantidade AS quantidade_atual,
    ROUND(livro_quantidade * 1.10, 2) AS quantidade_arredondada,
    TRUNC(livro_quantidade * 1.10, 2) AS quantidade_sem_arredondamento
FROM livros;

-- QUESTÃO 6
-- A: Separar os livros de acordo com o número do seu ID.
-- O MOD verifica o resto da divisão por 2 para identificar números pares e ímpares.

SELECT
    livro_id,
    livro_titulo,
    CASE
        WHEN MOD(livro_id, 2) = 0 THEN 'PAR'
        ELSE 'ÍMPAR'
    END AS classificacao
FROM livros;

-- QUESTÃO 6
-- B: Selecionar aleatoriamente um leitor ativo.
-- O RANDOM() escolhe um registro de forma aleatória e o LIMIT retorna apenas um leitor.

SELECT
    leitor_id,
    leitor_nome
FROM leitores
WHERE leitor_ativo = TRUE
ORDER BY RANDOM()
LIMIT 1;

-- QUESTÃO 7: Exibir os livros com uma descrição, título em maiúsculo e início do ISBN.
-- O CONCAT junta os textos, o UPPER transforma o título em maiúsculo
-- e o LEFT retorna os três primeiros caracteres do ISBN.

SELECT
    CONCAT(livro_titulo, ' - ISBN: ', livro_isbn) AS descricao_livro,
    UPPER(livro_titulo) AS titulo_maiusculo,
    LEFT(livro_isbn, 3) AS inicio_isbn
FROM livros;

-- QUESTÃO 8: Consultar os empréstimos realizados nos últimos 60 dias.
-- O EXTRACT permite identificar o ano da data.
-- O INTERVAL define o período utilizado no filtro.

SELECT
    emprestimo_id,
    emprestimo_data,
    EXTRACT(YEAR FROM emprestimo_data) AS ano_emprestimo
FROM emprestimos
WHERE emprestimo_data >= NOW() - INTERVAL '60 days';

-- QUESTÃO 9: Consultar há quanto tempo os empréstimos foram realizados e estimar uma data futura.
-- O AGE calcula o tempo entre a data atual e a data do empréstimo.
-- O INTERVAL permite projetar uma data 14 dias após o empréstimo.

SELECT
    emprestimo_id,
    emprestimo_data,
    AGE(NOW(), emprestimo_data) AS tempo_desde_emprestimo,
    emprestimo_data + INTERVAL '14 days' AS data_prevista
FROM emprestimos;

-- QUESTÃO 10: Gerar um relatório dos empréstimos com os dados dos leitores.
-- O INNER JOIN relaciona os empréstimos aos leitores.
-- O TO_CHAR formata as datas e os valores, enquanto o LPAD completa o código com zeros.

SELECT
    LPAD(e.emprestimo_id::TEXT, 4, '0') AS codigo_emprestimo,
    l.leitor_nome,
    TO_CHAR(e.emprestimo_data, 'DD/MM/YYYY') AS data_emprestimo,
    TO_CHAR(e.emprestimo_valor_multa, 'FM999990.00') AS valor_multa
FROM emprestimos e
INNER JOIN leitores l
    ON e.leitor_id = l.leitor_id;