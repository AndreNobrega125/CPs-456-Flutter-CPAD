-- Dados de exemplo realistas do PoupAI (estudante que vive de mesada/estágio e divide república).
-- Rodar no SQL Editor do Supabase DEPOIS do schema.sql.
--
-- ATENÇÃO: o bloco "limpar" apaga TODOS os dados das 5 tabelas (inclusive dados de teste).
-- Se quiser manter o que já existe, apague/comente as linhas de delete.

-- limpar
delete from pagamentos_grupo;
delete from despesas_grupo;
delete from grupos;
delete from metas;
delete from movimentos;

-- Carteira: 2 receitas + 10 despesas em 4 categorias (valores negativos = despesa)
insert into movimentos (descricao, valor, categoria, criado_em) values
  ('Estágio - setembro',            1200.00, null,          now() - interval '20 days'),
  ('Mesada',                         400.00, null,          now() - interval '18 days'),
  ('Almoço no bandejão',             -18.50, 'Alimentação', now() - interval '17 days'),
  ('Mercado do mês',                -210.90, 'Alimentação', now() - interval '15 days'),
  ('Delivery de sábado',             -42.00, 'Alimentação', now() - interval '9 days'),
  ('Recarga do bilhete único',       -60.00, 'Transporte',  now() - interval '14 days'),
  ('Uber pra faculdade',             -23.40, 'Transporte',  now() - interval '6 days'),
  ('Cinema com a turma',             -38.00, 'Lazer',       now() - interval '8 days'),
  ('Assinatura de streaming',        -29.90, 'Lazer',       now() - interval '12 days'),
  ('Show de sexta',                  -90.00, 'Lazer',       now() - interval '3 days'),
  ('Xerox e impressões',             -15.00, 'Outros',      now() - interval '5 days'),
  ('Presente de aniversário',        -55.00, 'Outros',      now() - interval '2 days');

-- Metas em estágios diferentes: começando, no meio e quase concluída
insert into metas (nome, valor_atual, valor_alvo, criado_em) values
  ('Notebook novo',           350.00, 3200.00, now() - interval '30 days'),
  ('Viagem de formatura',     780.00, 1500.00, now() - interval '25 days'),
  ('Reserva de emergência',   940.00, 1000.00, now() - interval '40 days');

-- Grupos de divisão de contas
with g as (
  insert into grupos (nome, membros, criado_em) values
    ('Apê 302',           array['Você','Marina','Lucas','Bia'],               now() - interval '28 days'),
    ('Viagem de formatura', array['Você','Pedro','Ana','Rafa','Carol'],       now() - interval '20 days'),
    ('Churrasco da turma',  array['Você','Léo','Duda'],                       now() - interval '7 days')
  returning id, nome
)
insert into despesas_grupo (grupo_id, descricao, valor, pago_por, criado_em)
select g.id, d.descricao, d.valor, d.pago_por, now() - d.dias * interval '1 day'
from g
join (values
  ('Apê 302',             'Aluguel',             2400.00, 'Marina', 12),
  ('Apê 302',             'Internet',             120.00, 'Você',   10),
  ('Apê 302',             'Mercado do mês',       320.00, 'Lucas',   8),
  ('Viagem de formatura', 'Sinal da hospedagem',  900.00, 'Você',   15),
  ('Viagem de formatura', 'Passagens de ônibus',  650.00, 'Pedro',   9),
  ('Churrasco da turma',  'Carne e bebidas',      240.00, 'Léo',     5),
  ('Churrasco da turma',  'Carvão e gelo',         45.00, 'Você',    5)
) as d(grupo, descricao, valor, pago_por, dias) on d.grupo = g.nome;
