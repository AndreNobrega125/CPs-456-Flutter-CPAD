# Checklist de entrega — CP5 e CP6

Legenda: `[x]` feito e verificado · `[ ]` falta (responsável entre parênteses).

## CP5 — Protótipo funcional

**Fluxo (25%)**
- [x] Navegação com 4 abas: Carteira, Split, Metas, Perfil
- [x] Registrar receita e despesa
- [x] Criar meta e depositar nela
- [x] Criar grupo, adicionar despesa e ver o saldo
- [x] Estados de carregando, vazio e erro nas telas

**Fidelidade ao design do CP4 (20%)**
- [x] Paleta e logo do CP4 mantidas
- [x] Tema claro e escuro em todo o app

**Dados / mocks (15%)**
- [x] Dados no Supabase (4 tabelas) com `supabase/schema.sql`
- [x] Dados de exemplo em `supabase/seed.sql`
- [x] Camada de serviço com interface + `Mock*` + `Supabase*`
- [x] `seed.sql` rodado e conferido no app (Metas: 52%, 11%, 94%). Rodar de novo só se alguém mexer nos dados (André)

**Ambiente sem erro na apresentação (20%)**
- [x] `flutter analyze` sem problemas
- [x] `flutter test`: 13 testes passando
- [x] Roda no Windows, no emulador Android e no APK
- [ ] Abrir o app 1 dia antes da demo (Supabase gratuito pausa após ~1 semana parado) (André)
- [ ] Testar internet/Wi-Fi do local da demo (todos)

**Documentação (20%)**
- [x] README por checkpoint (CP4, CP5, CP6)
- [x] Como rodar, decisões técnicas e estrutura do projeto
- [x] Papel de cada integrante documentado (seção Integrantes)
- [ ] Conferir se os papéis estão corretos e atuais (grupo)

**Demo em aula**
- [ ] Ensaiar roteiro: Carteira → Dividir conta → Como acertar → Metas → Perfil/tema (grupo)

## CP6 — App final

**MVP funcionando (30%)**
- [x] Carteira com saldo, gastos por categoria e pendências de split
- [x] Metas com barra de progresso e depósito
- [x] Split com "quem deve pra quem" (menor número de transferências)
- [x] Botão "Marcar como pago": registra o pagamento no banco, recalcula os saldos e lista o histórico
- [x] Regras de negócio cobertas por testes unitários

**UI/UX e identidade (20%)**
- [x] Textos legíveis e contraste revisados
- [x] Ícone do app com a logo
- [x] Perfil sem itens fictícios
- [x] Ícone conferido no app (André)

**APK instalável e funcional (20%)**
- [x] `flutter build apk --release` gerado (50,6 MB)
- [x] Permissão de internet no AndroidManifest
- [x] Instalado e testado no emulador
- [ ] Testar em celular Android físico (grupo)
- [x] APK anexado na Release v1.0.0 e link no README (André)

**Documentação (15%)**
- [x] Arquitetura descrita no README
- [x] Limitações conhecidas descritas
- [ ] Revisar e reescrever os "Aprendizados do grupo" (hoje é rascunho) (grupo)

**Organização do repositório (15%)**
- [x] `.env` fora do Git; nenhuma chave secreta no código
- [x] Imagens organizadas em `docs/`
- [x] Mudanças da CP6 commitadas em commits pequenos por área (André)
- [ ] Cada integrante commitar a sua própria parte (documentação, aprendizados, etc.) (grupo)
- [ ] Conferir `git log`: histórico com mais de um autor, mensagens claras (grupo)
- [x] `git push` feito; imagens do README respondem no GitHub (André)

## Antes de entregar (revisão final)
- [ ] Clonar o repo em outra pasta, criar o `.env` e rodar `flutter pub get` + `flutter run`
- [ ] Link do repositório e link da Release enviados ao professor no prazo
