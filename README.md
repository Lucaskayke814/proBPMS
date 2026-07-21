# proBPMS - Gestao Contratual Corporativa

Sistema corporativo para gestao do contrato SEPLAG x PRODEMGE.

Importante:
- Nao e BPMS.
- Nao e sistema de abertura de processo.
- Nao e sistema do cidadao.
- Foco exclusivo em controle contratual administrativo, operacional, tecnico e financeiro.
- Modelo operacional atual: contrato corporativo unico do BPMS.

## Arquitetura

- Frontend: HTML + JavaScript (Supabase SDK)
- Persistencia: PostgreSQL no Supabase
- Seguranca: Supabase Auth + RLS
- Trilha de alteracoes: tabela de historico com triggers

## O que esta implementado

- Modelo de dados relacional corporativo em `SETUP_SUPABASE.sql`.
- Entidades de contrato, orgaos, servicos, sistemas, modulos, demandas e financeiro.
- Exclusao logica (`ativo`) em todas as entidades de negocio.
- Campos de auditoria em todas as tabelas:
	- `id`
	- `created_at`
	- `updated_at`
	- `created_by`
	- `updated_by`
	- `ativo`
- Historico de alteracoes por campo (`audit_history`) com trigger generica.
- Notificacoes automaticas para eventos principais (demanda, status, publicacao, API, documento).
- Recalculo automatico de saldos financeiros por triggers a cada movimentacao.
- Dashboard executivo baseado em view (`vw_dashboard_executivo`).
- Cadastro inicial automatico no banco para dominios e base operacional publica.
- Interface de trabalho moderna com navegacao lateral e modulos operacionais estilo backlog.
- Novas estruturas para governanca contratual:
	- `module_request` e `module_request_history`
	- `feature_request` e `feature_request_comment`
	- `timeline_event`
	- `report_export`
	- `user_role` e `app_user_role`
- Views analiticas para acompanhamento financeiro:
	- `vw_saldo_por_anuente`
	- `vw_saldo_por_empenho`
	- `vw_saldo_por_dotacao`
	- `vw_linha_do_tempo`
- CRUD de modulos centrais no frontend:
	- Contratos
	- Orgaos
	- Sistemas
	- Servicos
	- Demandas
	- Movimentacoes financeiras

## Configuracao

1. Execute `SETUP_SUPABASE.sql` no SQL Editor do Supabase.
2. Configure `SUPABASE_URL` e `SUPABASE_KEY` no arquivo `index.html`.
3. Crie usuarios em Auth e realize login na aplicacao.

## Politica de acesso

- Auto cadastro desabilitado na aplicacao.
- Somente usuarios previamente cadastrados/ativos em `app_user` conseguem acessar.
- O vinculo entre usuario autenticado e cadastro interno e feito por email no primeiro login (`fn_bind_current_user`).
- Perfis administrativos (`tipo_usuario = ADMIN` ou `ADMINISTRADOR`) podem manter cadastros publicos e de dominio.

## Deploy

```bash
git add .
git commit -m "proBPMS: base corporativa de gestao contratual"
git push -u origin main
```

GitHub Pages: `https://seu-usuario.github.io/proBPMS`
