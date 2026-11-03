CREATE DATABASE biblioteca_db;

-- Trabalho Prático 01 - Biblioteca
-- O tema foi escolhido para organizar os dados de uma biblioteca,
-- facilitando o controle de livros, leitores e empréstimos.

-- Tabela de autores
CREATE TABLE autores (
    autor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    autor_nome VARCHAR(100) NOT NULL,
    autor_nacionalidade VARCHAR(60),
    autor_data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de editoras
CREATE TABLE editoras (
    editora_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    editora_nome VARCHAR(100) NOT NULL UNIQUE,
    editora_cidade VARCHAR(60),
    editora_data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de livros
CREATE TABLE livros (
    livro_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    livro_titulo VARCHAR(150) NOT NULL,
    livro_isbn VARCHAR(20) UNIQUE,
    livro_ano_publicacao INTEGER,
    livro_quantidade INTEGER NOT NULL DEFAULT 1,
    autor_id INTEGER NOT NULL,
    editora_id INTEGER NOT NULL,
    livro_data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (livro_quantidade >= 0),
    CHECK (livro_ano_publicacao >= 1000),

    FOREIGN KEY (autor_id) REFERENCES autores (autor_id),
    FOREIGN KEY (editora_id) REFERENCES editoras (editora_id)
);

-- Tabela de leitores
CREATE TABLE leitores (
    leitor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    leitor_nome VARCHAR(100) NOT NULL,
    leitor_email VARCHAR(120) NOT NULL UNIQUE,
    leitor_telefone VARCHAR(20),
    leitor_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    leitor_data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de empréstimos
CREATE TABLE emprestimos (
    emprestimo_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    leitor_id INTEGER NOT NULL,
    emprestimo_data DATE NOT NULL DEFAULT CURRENT_DATE,
    emprestimo_data_devolucao DATE,
    emprestimo_status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    emprestimo_valor_multa NUMERIC(8,2) NOT NULL DEFAULT 0.00,

    CHECK (emprestimo_status IN ('PENDENTE', 'DEVOLVIDO', 'ATRASADO')),
    CHECK (emprestimo_valor_multa >= 0),
    CHECK (
        emprestimo_data_devolucao IS NULL
        OR emprestimo_data_devolucao >= emprestimo_data
    ),

    FOREIGN KEY (leitor_id) REFERENCES leitores (leitor_id)
);

-- Tabela de itens dos empréstimos
CREATE TABLE itens_emprestimo (
    item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emprestimo_id INTEGER NOT NULL,
    livro_id INTEGER NOT NULL,
    item_quantidade INTEGER NOT NULL DEFAULT 1,

    CHECK (item_quantidade > 0),

    FOREIGN KEY (emprestimo_id) REFERENCES emprestimos (emprestimo_id),
    FOREIGN KEY (livro_id) REFERENCES livros (livro_id),
    UNIQUE (emprestimo_id, livro_id)
);

-- Cadastro de autores
INSERT INTO autores (autor_nome, autor_nacionalidade) VALUES
('Machado de Assis', 'Brasileira'),
('Clarice Lispector', 'Ucraniana'),
('Jorge Amado', 'Brasileira'),
('J.K. Rowling', 'Britânica'),
('George Orwell', 'Britânica');

-- Cadastro de editoras
INSERT INTO editoras (editora_nome, editora_cidade) VALUES
('Companhia das Letras', 'São Paulo'),
('Rocco', 'Rio de Janeiro'),
('Record', 'Rio de Janeiro'),
('Intrínseca', 'Rio de Janeiro'),
('Martin Claret', 'São Paulo');

SELECT * FROM autores;
SELECT * FROM editoras;

-- Cadastro de livros
INSERT INTO livros (
    livro_titulo,
    livro_isbn,
    livro_ano_publicacao,
    livro_quantidade,
    autor_id,
    editora_id
) VALUES
('Dom Casmurro', '9788535902778', 1899, 5, 1, 1),
('A Hora da Estrela', '9788520925688', 1977, 4, 2, 2),
('Capitães da Areia', '9788535911695', 1937, 6, 3, 3),
('Harry Potter e a Pedra Filosofal', '9788532511010', 1997, 8, 4, 2),
('A Revolução dos Bichos', '9788535909555', 1945, 3, 5, 4);

-- Cadastro de leitores
INSERT INTO leitores (
    leitor_nome,
    leitor_email,
    leitor_telefone
) VALUES
('Pedro Almeida', 'pedro@email.com', '35999990001'),
('Mariana Souza', 'mariana@email.com', '35999990002'),
('Lucas Ferreira', 'lucas@email.com', '35999990003'),
('Ana Beatriz', 'ana@email.com', '35999990004'),
('Gabriel Santos', 'gabriel@email.com', '35999990005');

SELECT * FROM livros;
SELECT * FROM leitores;

-- Cadastro de empréstimos
INSERT INTO emprestimos (
    leitor_id,
    emprestimo_data,
    emprestimo_data_devolucao,
    emprestimo_status,
    emprestimo_valor_multa
) VALUES
(1, '2026-10-20', '2026-10-25', 'DEVOLVIDO', 0.00),
(2, '2026-10-25', NULL, 'PENDENTE', 0.00),
(3, '2026-10-15', NULL, 'ATRASADO', 5.00),
(4, '2026-10-28', NULL, 'PENDENTE', 0.00),
(5, '2026-10-18', '2026-10-22', 'DEVOLVIDO', 0.00);

-- Cadastro dos itens dos empréstimos
INSERT INTO itens_emprestimo (
    emprestimo_id,
    livro_id,
    item_quantidade
) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);

SELECT * FROM emprestimos;

SELECT * FROM itens_emprestimo;

-- 1. Listar livros com seus autores e editoras
SELECT
    l.livro_titulo,
    a.autor_nome,
    e.editora_nome
FROM livros l
JOIN autores a ON l.autor_id = a.autor_id
JOIN editoras e ON l.editora_id = e.editora_id;

-- 2. Listar empréstimos com os nomes dos leitores
SELECT
    em.emprestimo_id,
    le.leitor_nome,
    em.emprestimo_data,
    em.emprestimo_status
FROM emprestimos em
JOIN leitores le ON em.leitor_id = le.leitor_id;

-- 3. Quantidade de empréstimos por leitor
SELECT
    le.leitor_nome,
    COUNT(em.emprestimo_id) AS quantidade_emprestimos
FROM leitores le
JOIN emprestimos em ON le.leitor_id = em.leitor_id
GROUP BY le.leitor_nome;

-- 4. Consultar empréstimos pendentes
SELECT *
FROM emprestimos
WHERE emprestimo_status = 'PENDENTE';

-- 5. Listar livros com quantidade disponível
SELECT
    livro_titulo,
    livro_quantidade
FROM livros
WHERE livro_quantidade > 0;

-- 6. Quantidade de livros por autor
SELECT
    a.autor_nome,
    COUNT(l.livro_id) AS quantidade_livros
FROM autores a
JOIN livros l ON a.autor_id = l.autor_id
GROUP BY a.autor_nome;

SELECT
    (SELECT COUNT(*) FROM autores) AS autores,
    (SELECT COUNT(*) FROM editoras) AS editoras,
    (SELECT COUNT(*) FROM livros) AS livros,
    (SELECT COUNT(*) FROM leitores) AS leitores,
    (SELECT COUNT(*) FROM emprestimos) AS emprestimos,
    (SELECT COUNT(*) FROM itens_emprestimo) AS itens;