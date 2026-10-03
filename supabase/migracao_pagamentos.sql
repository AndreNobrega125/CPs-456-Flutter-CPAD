-- Migração da CP6: registro de pagamentos do Split (botão 'Marcar como pago').
-- Rodar UMA vez no SQL Editor do Supabase, em projetos que já têm o schema.sql aplicado.

create table if not exists pagamentos_grupo (
  id uuid primary key default gen_random_uuid(),
  grupo_id uuid not null references grupos(id) on delete cascade,
  de text not null,   -- quem pagou
  para text not null, -- quem recebeu
  valor numeric not null,
  criado_em timestamptz not null default now()
);

alter table pagamentos_grupo enable row level security;
create policy "acesso geral pagamentos_grupo" on pagamentos_grupo for all using (true) with check (true);
