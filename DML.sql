-- BD 2024/25 - etapa E2 - bd013 


-- 1.
-- Nickname e país de todos os jogadores que já obtiveram pelo menos dez pontos
-- em algum encontro realizado em Lisboa (LIS). O ano desses jogos também deverá
-- ser apresentado; e os resultados ordenados de forma ascendente por ano, e
-- descendente por país e nickname. Nota: pretende-se uma interrogação sem subinterrogações: apenas com um SELECT


SELECT DISTINCT j.nickname, j.pais, e.ano
FROM jogador j, encontro e, recinto r, joga jg
WHERE r.cidade = "LIS"
AND jg.pontos >= 9
ORDER BY e.ano ASC, j.nickname DESC, j.pais DESC


-- 2.
-- Número, nome, nickname, papel e país dos jogadores que são Senior em pelo
-- menos um dos papeis: atirador e suporte, ou que tenham um nickname de 6
-- caracteres, começado por ‘S’ e terminado por ‘r’ e tenham começado a jogar antes
-- (*) do recente Torneio League of Legends realizado na Islândia (2021). Nota:
-- pode usar construtores de conjuntos.


SELECT j.numero, j.nome, j.nickname, esp.papel, j.pais
FROM jogador j
LEFT OUTER JOIN especialista esp ON j.numero = esp.jogador
WHERE esp.tipo = 'senior'
  AND (esp.papel = 'atirador' OR esp.papel = 'suporte')
  OR (LENGTH(j.nickname) = 6 AND j.nickname LIKE 'S%' AND j.nickname LIKE '%r' AND j.activ < 2021);



-- 3.
-- Identificação dos encontros de semi-finais realizados em Paris (PAR) em que
-- jogou, pelo menos, um jogador que iniciou actividade antes de 2021 e tem um
-- nickname contendo ‘Purple’.


SELECT e.ano, e.fase, e.numero, e.equipa1, e.equipa2, e.recinto
FROM encontro e, recinto r, jogador j
WHERE e.fase = 'SF' AND r.cidade = "PAR"
  AND j.activ <= 2021
  AND j.nickname LIKE '%Purple%'

-- 4.
-- Nome, ano e país dos jogadores que nasceram antes do ano 2000, e que nunca
-- participaram como atirador, em finais com equipas da Dinamarca (DK).


SELECT j.nome, j.nasc, j.pais
FROM jogador j
LEFT OUTER JOIN joga jg ON j.numero = jg.jogador
LEFT OUTER JOIN encontro e ON jg.enc_ano = e.ano
  AND jg.enc_numero = e.numero
  AND jg.enc_fase = e.fase
WHERE j.nasc < 2000
GROUP BY j.nome, j.nasc, j.pais
HAVING SUM(
    (e.fase = 'FF' 
     AND (e.equipa1 = 'DK' OR e.equipa2 = 'DK') 
     AND jg.papel = 'atirador')
) = 0;


-- 5. Identificação dos encontros das fases finais (SF e FF) em que tenham participado
-- jogadores islandeses (IS) junior em todos os papeis que existem. Nota: o resultado
-- deve vir ordenado pelo ano de forma descendente, e pela fase e número do
-- encontro de forma ascendente


SELECT en.ano, en.fase, en.numero, en.equipa1, en.equipa2, en.recinto
FROM encontro en
LEFT OUTER JOIN joga jg ON jg.enc_ano = en.ano AND jg.enc_fase = en.fase AND jg.enc_numero = en.numero
LEFT OUTER JOIN jogador j ON j.numero = jg.jogador
LEFT OUTER JOIN especialista esp ON esp.jogador = jg.jogador AND esp.tipo = 'senior'
WHERE j.pais = 'IS'
  AND en.fase IN ('SF', 'FF')
GROUP BY en.ano, en.fase, en.numero
HAVING COUNT(jg.papel) = COUNT(DISTINCT jg.papel)
   AND COUNT(esp.tipo) = 0 
ORDER BY en.ano DESC, en.fase ASC, en.numero ASC;



-- 6. Número de encontros em que jogou cada jogador, em cada papel. Nota: os
-- resultados devem ser ordenados, de forma ascendente, pelo nome e número do
-- jogador, e de forma descendente pelo papel.


SELECT j.numero, j.nome, jo.papel, COUNT(*) AS total_encontros
FROM jogador j
LEFT OUTER JOIN joga jo ON jo.jogador = j.numero
GROUP BY j.numero, j.nome, jo.papel
ORDER BY j.nome ASC, j.numero ASC, jo.papel DESC;


-- 7. Nome, número e país dos jogadores que participaram em mais finais (FF), em
-- cada papel. Notas: em caso de empate, devem ser mostrados todos os jogadores
-- em causa


SELECT j.nome, j.numero, j.pais, esp.papel
FROM jogador j
LEFT OUTER JOIN joga jg ON j.numero = jg.jogador
LEFT OUTER JOIN encontro e ON jg.enc_ano = e.ano
  AND jg.enc_fase = e.fase
  AND jg.enc_numero = e.numero
LEFT OUTER JOIN especialista esp ON j.numero = esp.jogador
GROUP BY j.nome, j.numero, esp.papel, j.activ
HAVING COUNT(*) = (
    SELECT COUNT(j2.numero)
    FROM jogador j2
    LEFT OUTER JOIN joga jg2 ON j2.numero = jg2.jogador
    LEFT OUTER JOIN encontro e2 ON jg2.enc_ano = e2.ano     AND jg2.enc_fase = e2.fase     AND jg2.enc_numero = e2.numero
    LEFT OUTER JOIN especialista esp2 ON j2.numero = esp2.jogador
    WHERE e2.fase = 'FF'
      AND esp2.papel = esp.papel 
    GROUP BY j2.numero
    ORDER BY COUNT(jg2.jogador) DESC, j2.numero
    LIMIT 1
  )
ORDER BY esp.papel;

-- 8. Para cada ano de início de actividade, o número e nome do jogador que jogou em
-- mais encontros. Apresentar também o número total de encontros em que jogou, e
-- a maior e menor pontuação que obteve nesses encontros. Nota: em caso de empate
-- do total de encontros, mostrar todos os jogadores em causa.


SELECT j.activ, j.numero, j.nome, COUNT(*) AS totalEnc, MAX(jg.pontos) AS maxPont, MIN(jg.pontos) AS minPont
FROM jogador j
LEFT OUTER JOIN joga jg ON j.numero = jg.jogador
LEFT OUTER JOIN encontro e ON jg.enc_ano = e.ano
  AND jg.enc_fase = e.fase
  AND jg.enc_numero = e.numero
GROUP BY j.activ, j.numero, j.nome
HAVING totalEnc = (
    SELECT COUNT(j1.numero)
    FROM jogador j1
    LEFT OUTER JOIN joga jg1 ON j1.numero = jg1.jogador
    WHERE j1.activ = j.activ
    GROUP BY j1.numero
    ORDER BY COUNT(jg1.jogador) DESC, j1.numero
    LIMIT 1
);

-- 9.Nickname, ano de nascimento e país dos jogadores que nasceram depois do mítico
-- campeão de League of Legends, Faker (o coreano Lee Sang-hyeok, nasc: 1996),
-- e que jogaram em menos de 4 encontros destes torneios de League of Legends,
-- mesmo que não tenham jogado em nenhum. Pretende-se uma interrogação sem
-- sub-interrogações: apenas com um SELECT.


SELECT j.nickname, j.nasc, j.pais
FROM jogador j
LEFT OUTER JOIN joga jg ON j.numero = jg.jogador
GROUP BY j.numero, j.nickname, j.nasc, j.pais
HAVING COUNT(jg.enc_ano) < 4 AND j.nasc > 1996;