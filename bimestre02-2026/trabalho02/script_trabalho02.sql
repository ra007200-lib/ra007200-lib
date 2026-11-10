CREATE OR REPLACE FUNCTION fn_consultar_leitor(p_leitor_id INT)
RETURNS TEXT AS $$
DECLARE
    v_nome TEXT;
    v_ativo BOOLEAN;
BEGIN
    SELECT leitor_nome, leitor_ativo
    INTO v_nome, v_ativo
    FROM leitores
    WHERE leitor_id = p_leitor_id;

    IF NOT FOUND THEN
        RETURN 'Leitor não encontrado!';
    END IF;

    IF v_ativo THEN
        RETURN v_nome || ' - Leitor Ativo';
    ELSE
        RETURN v_nome || ' - Leitor Inativo';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT fn_consultar_leitor(1);

SELECT fn_consultar_leitor(99);

CREATE OR REPLACE FUNCTION fn_total_livros_emprestimo(p_emprestimo_id INT)
RETURNS INT AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COALESCE(SUM(item_quantidade), 0)
    INTO v_total
    FROM itens_emprestimo
    WHERE emprestimo_id = p_emprestimo_id;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

SELECT fn_total_livros_emprestimo(1);

SELECT fn_total_livros_emprestimo(99);

CREATE OR REPLACE FUNCTION fn_listar_emprestimos_leitor(p_leitor_id INT)
RETURNS TABLE (
    emprestimo_id INT,
    data_emprestimo DATE,
    status_emprestimo VARCHAR(20),
    valor_multa NUMERIC(8,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.emprestimo_id,
        e.emprestimo_data,
        e.emprestimo_status,
        e.emprestimo_valor_multa
    FROM emprestimos e
    WHERE e.leitor_id = p_leitor_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fn_listar_emprestimos_leitor(1);

SELECT * FROM fn_listar_emprestimos_leitor(99);