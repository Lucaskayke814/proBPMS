# SETUP - proBPMS Corporativo

## 1) Banco de dados (obrigatorio antes do frontend)

1. Acesse o Supabase SQL Editor.
2. Execute integralmente o arquivo `SETUP_SUPABASE.sql`.
3. Confirme a criacao das tabelas principais, views e triggers.

Observacao importante:
- Como o schema foi evoluido com novos modulos (modulos, funcionalidades, timeline, relatorios, permissoes), reexecute o script completo em ambiente limpo ou usando migration controlada.

Observacao:
- O script ja cria dominios, entidades de negocio, auditoria, notificacoes, RLS e indices.
- O script tambem cria automaticamente o contrato corporativo unico do BPMS e seus vinculos iniciais com anuentes e servicos.

## 2) Configurar credenciais no frontend

Editar no `index.html`:

```javascript
const SUPABASE_URL = 'https://cyolmcowhfhymemmxgrn.supabase.co';
const SUPABASE_KEY = 'sb_publishable_pLhl-nX5gTgwe9p4bqdtAQ_HKJvDQUo';
```

## 3) Configuracao segura dos acessos Supabase

Use os parametros assim:

- Frontend (publico):
	- `SUPABASE_URL=https://cyolmcowhfhymemmxgrn.supabase.co`
	- `SUPABASE_PUBLISHABLE_KEY=sb_publishable_pLhl-nX5gTgwe9p4bqdtAQ_HKJvDQUo`

- Backend/servicos privados (nunca no navegador):
	- `SUPABASE_SECRET_KEY=your-secret-key`
	- `SUPABASE_JWKS_URL=https://cyolmcowhfhymemmxgrn.supabase.co/auth/v1/.well-known/jwks.json`

Regras obrigatorias de seguranca:
- Nunca expor `SUPABASE_SECRET_KEY` em `index.html`, GitHub Pages ou JS client-side.
- Use `SUPABASE_SECRET_KEY` apenas em API/backend/edge function.
- Use `SUPABASE_JWKS_URL` para validar JWT no backend quando houver API propria.
- RLS esta configurado para bloquear DELETE fisico e isolar dados por usuario criador.

## 4) Usuarios

No Supabase:
- Authentication > Users > Invite user

No banco (obrigatorio):
- Inserir o usuario em `app_user` com email correspondente e `ativo = true`.
- Definir `tipo_usuario`:
	- `ADMIN` ou `ADMINISTRADOR` para administracao do sistema
	- Demais perfis para operacao comum

Exemplo:

```sql
INSERT INTO app_user (nome, email, tipo_usuario, ativo)
VALUES ('Administrador do Sistema', 'admin@seplag.mg.gov.br', 'ADMIN', TRUE)
ON CONFLICT (email) DO UPDATE
SET ativo = TRUE,
		tipo_usuario = EXCLUDED.tipo_usuario;
```

Importante:
- A aplicacao nao permite auto cadastro.
- O usuario precisa existir em `auth.users` e em `app_user` para entrar.

## 5) Publicacao

```bash
git add .
git commit -m "setup proBPMS corporativo"
git push
```

GitHub Pages:
- Settings > Pages
- Deploy from branch (main/root)

## 6) Ordem de evolucao

Seguindo diretriz contratual:
1. Banco e relacionamentos
2. Regras de negocio
3. Servicos de acesso a dados
4. Telas
5. Dashboard
6. Relatorios
7. Validacoes de consistencia

Nenhuma tela deve ser implementada sem estrutura correspondente no banco.
