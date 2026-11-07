# Como rodar o PoupAI

Há dois caminhos. **O mais simples é instalar o APK** (já vem configurado, só precisa de internet). Rodar pelo código exige as credenciais de um projeto Supabase (passo 3).

### Opção A: instalar o APK (sem configuração)

Baixe o `app-release.apk` na [Release v1.0.0](https://github.com/AndreNobrega125/CPs-456-Flutter-CPAD/releases/tag/v1.0.0) e instale em um Android (permitir "fontes desconhecidas"). No emulador, basta arrastar o arquivo para a janela dele ou usar `adb install -r app-release.apk`.

### Opção B: rodar pelo código

**Pré-requisitos:** Flutter SDK (testado com **Flutter 3.44.8 / Dart 3.12**; o `pubspec.yaml` exige Dart `^3.12.2`), Chrome (opcional), Android Studio com um emulador (opcional) e um projeto no [Supabase](https://supabase.com) (gratuito). Confira o ambiente com `flutter doctor`.

**1. Instalar as dependências** (na pasta que contém o `pubspec.yaml`)

```bash
flutter pub get
```

**2. Criar o banco no Supabase**

No painel do projeto: **SQL Editor → New query**, colar o conteúdo de [`supabase/schema.sql`](../supabase/schema.sql) e clicar em **Run**. Isso cria as tabelas `movimentos`, `metas`, `grupos`, `despesas_grupo` e `pagamentos_grupo`. (O arquivo [`supabase/migracao_pagamentos.sql`](../supabase/migracao_pagamentos.sql) só é necessário em um banco que já tinha o schema da CP5.)

Opcional, para a demonstração: rodar também [`supabase/seed.sql`](../supabase/seed.sql), que preenche o app com dados de exemplo realistas (receitas e despesas em 4 categorias, 3 metas em estágios diferentes e 3 grupos com despesas). **Atenção:** o script apaga os dados existentes das 5 tabelas antes de inserir.

**3. Configurar as credenciais (obrigatório)**

Copiar o modelo [`.env.example`](../.env.example) para `.env`, na mesma pasta do `pubspec.yaml`, e preencher os dois valores:

```bash
# Windows (PowerShell ou cmd)
copy .env.example .env
# macOS / Linux
cp .env.example .env
```

```
SUPABASE_URL=https://SEU-PROJETO.supabase.co
SUPABASE_ANON_KEY=sua-chave-publishable-aqui
```

Os dois valores estão em **Project Settings → API Keys** no painel do Supabase. Use sempre a chave **publishable** (antiga `anon`). **Nunca** use a chave `secret`/`service_role` no app: ela dá acesso total ao banco e o Supabase bloqueia seu uso no navegador. O arquivo `.env` está no `.gitignore` e não deve ser commitado. Para usar o mesmo banco da demonstração do grupo, peça os dois valores ao grupo.

> **Sem o arquivo `.env` o projeto não compila e `flutter test` também falha** (`No file or variants found for asset: .env`), porque ele é carregado como asset. Com valores inválidos o app abre, mas as telas mostram "Não foi possível carregar… Verifique sua conexão". Depois de editar o `.env`, é preciso reiniciar o app (hot restart).

**4. Rodar**

*No Windows (terminal, na pasta do projeto):*

```bash
flutter run -d windows
```

No Windows, os plugins exigem o **Modo de Desenvolvedor** ativado (`start ms-settings:developers`); sem ele aparece `Building with plugins requires symlink support`.

*No Android Studio (emulador Android):*

1. **File → Open** e escolha a pasta do projeto (a que contém o `pubspec.yaml`). Espere o `pub get` terminar.
2. Crie o `.env` (passo 3) antes de rodar.
3. Em **Device Manager**, inicie um emulador (por exemplo, "Medium Phone"). Ele aparece no seletor de dispositivos da barra superior.
4. Com o emulador selecionado, abra `lib/main.dart` e clique em **Run ▶**.

O equivalente pelo terminal: `flutter emulators --launch <id-do-emulador>` e depois `flutter run`.

*No navegador:*

```bash
flutter run -d chrome --release
```

O modo debug no Chrome (`flutter run -d chrome`) pode demorar ou travar em "Waiting for connection from debug service"; nesse caso, usar `--release`.

**Testes**

```bash
flutter analyze
flutter test
```
