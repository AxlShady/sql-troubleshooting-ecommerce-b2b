--eu fiz para mostara  os dados do pedido, o nome da empresa e a mensagem de erro retornada
SELECT 
    p.id AS pedido_id,
    c.razao_social AS cliente_empresa,
    p.valor_total,
    p.status_pagamento,
    i.status_integracao_erp,
    i.mensagem_erro_erp,
    p.data_criacao
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN integracoes_erp i ON p.id = i.pedido_id
WHERE p.status_pagamento = 'APROVADO'
  AND (i.status_integracao_erp = 'ERRO' OR i.status_integracao_erp IS NULL)
ORDER BY p.data_criacao DESC;


-- eu fiz para listar os itens, os saldos de cada ponta e a diferença matemática entre eles
SELECT 
    prod.codigo_sku,
    prod.nome_produto,
    prod.estoque_plataforma,
    e.estoque_erp,
    (prod.estoque_plataforma - e.estoque_erp) AS divergencia_unidades
FROM produtos prod
INNER JOIN sincronizacao_estoque e ON prod.codigo_sku = e.codigo_sku
WHERE prod.estoque_plataforma <> e.estoque_erp;


-- eu fiz para agrupar e conta quais erros aconteceram mais vezes para repassar ao time N2/Dev
SELECT
SELECT 
    modulo_afetado,
    codigo_erro_http,
    COUNT(*) AS total_chamados
FROM logs_erros_api
WHERE data_evento >= CURDATE() - INTERVAL 7 DAY
GROUP BY modulo_afetado, codigo_erro_http
ORDER BY total_chamados DESC; 