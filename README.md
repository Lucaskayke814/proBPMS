# proBPMS

Base do sistema de gestão do Contrato Corporativo PRODEMGE com autenticação integrada ao **Supabase**.

## 🚀 Setup Rápido

### Variáveis de Ambiente

As credenciais do Supabase já estão pré-configuradas em `.env.example`:

```bash
SUPABASE_URL=https://cyolmcowhfhymemmxgrn.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_pLhl-nX5gTgwe9p4bqdtAQ_HKJvDQUo
SUPABASE_SECRET_KEY=sb_secret_IkxGFMeYY2GMSVQemViUEA_fzfIPykE
SUPABASE_JWKS_URL=https://cyolmcowhfhymemmxgrn.supabase.co/auth/v1/.well-known/jwks.json
```

### Iniciar

```bash
# PostgreSQL local (opcional)
docker-compose up -d

# Backend
cd backend && mvn spring-boot:run

# Acesse http://localhost:8080
```

---

## Arquitetura alvo

| Camada | Tecnologia | Responsabilidade |
| --- | --- | --- |
| Web | React, TypeScript, Material UI | Interface, formulários e dashboards |
| API | Java 21, Spring Boot | Regras de negócio, RBAC e API REST |
| Dados | PostgreSQL + Flyway | Persistência versionada e auditável |
| Autenticação | Supabase Auth + JWT | OAuth/Email, JWKS validation |
| Arquivos | MinIO (S3) | Anexos de demandas e documentos |

O protótipo está disponível em `/index.html` após iniciar o backend.

## Domínios prioritários

1. Contrato, órgão anuente, dotação e movimentação financeira.
2. Demanda, comentário, anexo e histórico de alterações.
3. Publicação, API, erro e notificação.
4. Usuário, perfil e permissões por módulo.

## Estado atual da base

- Dashboard executivo: protótipo navegável em `index.html`.
- Demandas: contrato REST inicial (`GET` paginado e `POST`), validação, persistência JPA e código concorrente gerado pelo banco.
- Operação de demandas: mudança de status com fluxo controlado, comentários internos e eventos de timeline.
- Financeiro: dotações, lançamentos imutáveis com validação de saldo e resumo em `/api/v1/financial/summary`.
- Auditoria: criação de demanda registrada automaticamente na mesma transação.
- Identidade: login JWT em `POST /api/v1/auth/login`, com perfis centrais, setoriais e técnicos.
- Cadastros-base: contratos e órgãos anuentes com leitura autenticada e inclusão exclusiva do Gestor Central.

## Próximos incrementos obrigatórios antes de produção

1. Políticas finas por módulo e federação OIDC (`GESTOR_CENTRAL`, `GESTOR_SETORIAL`, `TECNICO`).
2. Fluxo transacional de empenho, liquidação, pagamento e estorno, com auditoria automática.
3. Upload de anexos com MinIO, antivírus e URLs temporárias.
4. OpenAPI, testes de integração com PostgreSQL e observabilidade.

> O JWT atual já protege as rotas da API. Em base vazia, defina `BOOTSTRAP_ADMIN_EMAIL` e `BOOTSTRAP_ADMIN_PASSWORD` para criar o primeiro Gestor Central.

## Convenções de implementação

- Valores monetários usam `NUMERIC(19,2)` e `BigDecimal`; nunca `float`.
- Alterações financeiras são imutáveis: correções criam nova movimentação.
- Todos os registros operacionais possuem `created_at`, `updated_at`, autor e exclusão lógica.
- A API deve paginar coleções e aceitar filtros por órgão, contrato, status e período.
- Eventos relevantes devem gravar histórico de auditoria em uma transação com a alteração.

## Execução local da infraestrutura

```sh
docker compose up -d
```

Isso disponibiliza PostgreSQL em `localhost:5432` e MinIO em `localhost:9001`.
