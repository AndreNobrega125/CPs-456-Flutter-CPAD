-- Schema PoupAI — rodar no SQL Editor do Supabase
-- Tabelas espelham os models Dart: Movimento, Meta, Grupo, DespesaGrupo, Pagamento

create table if not exists movimentos (
  id uuid primary key default gen_random_uuid(),
  descricao text not null,
  valor numeric not null, -- positivo = receita, negativo = despesa
  categoria text, -- null quando é receita
  criado_em timestamptz not null default now()
);

create table if not exists metas (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  valor_atual numeric not null default 0,
  valor_alvo numeric not null,
  criado_em timestamptz not null default now()
);

create table if not exists grupos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  membros text[] not null, -- lista de nomes, ex: '{Você,Marina,Lucas}'
  criado_em timestamptz not null default now()
);

create table if not exists despesas_grupo (
  id uuid primary key default gen_random_uuid(),
  grupo_id uuid not null references grupos(id) on delete cascade,
  descricao text not null,
  valor numeric not null,
  pago_por text not null,
  criado_em timestamptz not null default now()
);

create table if not exists pagamentos_grupo (
  id uuid primary key default gen_random_uuid(),
  grupo_id uuid not null references grupos(id) on delete cascade,
  de text not null,   -- quem pagou
  para text not null, -- quem recebeu
  valor numeric not null,
  criado_em timestamptz not null default now()
);

-- RLS (Row Level Security) — sem login de usuário nesta fase (CP5/CP6 escolar),
-- então liberamos acesso geral. Revisar antes de qualquer uso fora do contexto
-- acadêmico (isso NÃO é seguro para produção real).
alter table movimentos enable row level security;
alter table metas enable row level security;
alter table grupos enable row level security;
alter table despesas_grupo enable row level security;
alter table pagamentos_grupo enable row level security;

create policy "acesso geral movimentos" on movimentos for all using (true) with check (true);
create policy "acesso geral metas" on metas for all using (true) with check (true);
create policy "acesso geral grupos" on grupos for all using (true) with check (true);
create policy "acesso geral despesas_grupo" on despesas_grupo for all using (true) with check (true);
create policy "acesso geral pagamentos_grupo" on pagamentos_grupo for all using (true) with check (true);
