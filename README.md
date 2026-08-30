# CPs-456-Flutter-CPAD

# PoupAI

<img src="./logoPoupAi.png" alt="Logo PoupAI" height="140">
<img src="./logoPoupAiapp.png" alt="Logo PoupAI (ícone do app)" height="140">


App de fintech estudantil — controle financeiro pessoal, split de contas entre amigos e metas de economia, pensado pro ritmo de vida de quem vive de mesada, bolsa ou estágio.

Projeto avaliativo das Checkpoints 4, 5 e 6 da disciplina *CPAD (Cross-Platform Application Development)* — FIAP, turma 2CCPG.

## Proposta de valor

Estudante universitário não tem ferramenta pensada pro seu tipo de gasto — apps de finanças existentes são feitos pra quem tem salário fixo, não pra quem vive de mesada, bolsa e divide conta de república toda semana. O *PoupAI* junta controle financeiro pessoal + split de contas em grupo + metas de economia, desenhado especificamente pro ritmo de vida universitário.

## Problema

Estudantes universitários têm dificuldade de controlar gastos pessoais e organizar despesas compartilhadas (contas de casa, saídas em grupo, rachar delivery/Uber) — normalmente resolvido de forma manual, via planilha ou "fiado" sem registro.

## Público-alvo

Estudantes universitários, moradores de república/kitnet, com renda limitada (mesada, estágio, bolsa) que dividem gastos com colegas com frequência.

## MVP (funcionalidades mínimas)

- Controle financeiro pessoal (registrar receitas/gastos, categorias)
- Split de contas entre grupo de amigos (quem deve pra quem)
- Metas de economia (definir meta, acompanhar progresso)
- Visão consolidada ("carteira") do saldo pessoal + pendências de split

## Integrantes — turma 2CCPG

| Nome | RM | Papel |
|---|---|---|
| André Nobrega | 561754 | Dev Flutter (estrutura/telas) |
| Caio Carminato | 563630 | Documentação |
| Guilherme Tamai | 563276 | Identidade visual/Design + Documentação |
| Mirella Mascarenhas | 562092 | Pitch/modelo de negócio |
| Vitor Komura | 563694 | Identidade visual/Design |

## Documentação da marca

## Naming rationale

*PoupAI* une o verbo "poupar" (economizar, guardar dinheiro — termo já familiar em português) com "AI", sinalizando o lado inteligente do app: categorização automática de gastos, sugestões de meta, alertas de split pendente. O nome funciona por duplo motivo:

- É fácil de falar, lembrar e pronunciar tanto em português quanto em inglês
- "Poup" já carrega o significado central (economizar) sem precisar de explicação
- "AI" comunica diferencial tecnológico sem soar genérico como "finanças" ou "carteira"

## Tom de voz

O PoupAI fala como um amigo que entende de dinheiro, não como um banco. Diretrizes:

- *Direto, sem jargão financeiro* — "você deve R$ 32 pro grupo", não "saldo devedor pendente de liquidação"
- *Encorajador, nunca repreensivo* — o app não julga gasto, ajuda a organizar
- *Linguagem de estudante pra estudante* — humor leve permitido, formalidade excessiva não
- *Nunca alarmista* — alertas de saldo baixo são informativos, não geram culpa

## Identidade visual
![Paleta de cores do PoupAI](./docs/paleta-cores.png)
- *Paleta*: borda/navegação #0B1428 (azul quase-preto) · fundo #223760 (azul médio) · cards #C7D8F0 (azul claro) · acento #D4A657 (dourado)
- *Logo*: "P" estilizado em dourado sobre círculo azul-marinho — arquivo final do logo ainda pendente de envio pelo grupo; app usa placeholder vetorial equivalente (lib/widgets/poupai_logo.dart)
- *Tipografia*: Roboto (padrão Material/Flutter) — não houve escolha deliberada de fonte customizada nesta fase

## Pitch

*Problema:* estudante universitário não tem ferramenta pensada pro seu tipo de gasto — apps de finanças existentes são feitos pra quem tem salário fixo, não pra quem vive de mesada, bolsa e divide conta de república toda semana.

*Solução:* o PoupAI junta controle financeiro pessoal + split de contas em grupo + metas de economia, desenhado especificamente pro ritmo de vida universitário (gasto irregular, muita divisão de conta, meta de curto prazo tipo "juntar pra viagem de formatura").

*Por que agora / por que nós:* somos o próprio público-alvo — vivemos o problema (dividir aluguel, conta de mercado, Uber em grupo) e sabemos exatamente onde as soluções atuais falham.

*Diferencial competitivo:*

| Apps genéricos (Mobills, Nubank) | PoupAI |
|---|---|
| Pensado pra salário fixo mensal | Pensado pra renda irregular (mesada/bolsa/estágio) |
| Split de conta é feature secundária ou inexistente | Split é funcionalidade central, não acessório |
| Metas genéricas | Metas de curto prazo, contexto universitário |

*Modelo de sustentação:* freemium — funcionalidades básicas (controle financeiro, split, metas) gratuitas; recursos avançados (relatórios detalhados, integração bancária) pagos. Alternativa considerada: parceria institucional com universidades/centros acadêmicos.

*Chamada final:* "PoupAI: a carteira pensada pra quem ainda não tem salário, mas já tem conta pra dividir."

### Como rodar
 
```bash

flutter pub get

flutter run -d windows # ou -d chrome

 
