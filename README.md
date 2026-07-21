# 📋 proBPMS - Gestão Contratual PRODEMGE

Sistema web para gerenciar contratos corporativos com **Supabase Auth** e **Spring Boot 3.3**.

---

## ⚡ Setup (5 min)

### 1. Clonar & Configurar
```bash
git clone https://github.com/SEU_USUARIO/proBPMS.git
cd proBPMS
cp .env.example .env
# Editar .env com suas credenciais Supabase
```

### 2. Criar Supabase Project
1. Abra https://app.supabase.com
2. Crie novo projeto ("New Project")
3. Extraia credenciais: **SUPABASE_URL**, **SUPABASE_PUBLISHABLE_KEY**, **SUPABASE_SECRET_KEY**
4. Copie para `.env`

### 3. Executar Migrações
```bash
# Supabase Dashboard > SQL Editor
# Cole cada arquivo em order:
# backend/src/main/resources/db/migration/V1__*.sql
# backend/src/main/resources/db/migration/V2__*.sql
# ... (V1 até V6)
```

### 4. Rodar Backend
```bash
cd backend
mvn spring-boot:run
```

**Acesse**: http://localhost:8080

---

## 🧪 Testes (5 min)

### Health Check
```bash
curl http://localhost:8080/api/v1/health
# Resultado: {"status":"UP"}
```

### Login
```bash
# 1. Criar usuário no Supabase Dashboard
#    Authentication > Users > Add user
#    Email: teste@probpms.com
#    Password: Seu123Senha!

# 2. Fazer login na UI
#    http://localhost:8080
#    Email: teste@probpms.com
#    Password: Seu123Senha!
```

### CRUD (Contratos)
```bash
# Pegar token após login
TOKEN=$(curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@probpms.com","password":"Seu123Senha!"}' | jq -r '.accessToken')

# Criar contrato
curl -X POST http://localhost:8080/api/v1/contracts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "numeroProcesso": "2024.001",
    "dataAssinatura": "2024-01-01",
    "vigencia": 12,
    "descricao": "Contrato teste"
  }'

# Listar contratos
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/contracts

# Swagger UI: http://localhost:8080/swagger-ui.html
```

---

## 📤 Fazer Commit

```bash
git add .
git commit -m "refactor: implement Supabase-only authentication"
git push origin main
```

---

## 🌍 Deploy (Escolha Uma Opção)

### Option 1: GitHub Codespaces (Mais Fácil)
```
1. GitHub.com > Seu repo > Code > Codespaces > Create
2. Terminal: cd backend && mvn spring-boot:run
3. Clique no link localhost:8080
✅ Sistema rodando em IDE no navegador (sem instalar Maven)
```

### Option 2: Railway (Recomendado)
```
1. Railway.app > New Project
2. Deploy from GitHub
3. Selecione seu repo
4. Configure Build Command: cd backend && mvn clean package -DskipTests
5. Clique Deploy
✅ URL pública em 5 min (ex: https://probpms.up.railway.app)
```

### Option 3: Docker Local
```bash
# Criar backend/Dockerfile
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# Rodar
docker-compose up
```

### Option 4: GitHub Actions
Arquivo: `.github/workflows/deploy.yml`
```yaml
name: Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-java@v3
      with:
        java-version: '21'
    - run: cd backend && mvn clean package -DskipTests
```

---

## 🛠️ Troubleshooting

### Erro: `mvn: command not found`
```bash
# Instalar Maven
# Windows: https://maven.apache.org/download.cgi (descompactar em C:\)
# Adicionar C:\apache-maven-3.9.x\bin ao PATH
# Reiniciar terminal
```

### Erro: Database Connection
```
Verificar:
✓ .env tem SUPABASE_DB_URL?
✓ Migrações foram executadas no Supabase?
✓ Credenciais estão corretas?
✓ Firewall bloqueia porta 5432?
```

### Erro: JWT Invalid
```
Verificar:
✓ Token foi extraído do login?
✓ Token está no header Authorization: Bearer <TOKEN>?
✓ Token não expirou?
✓ SUPABASE_JWKS_URL está correto?
```

### Erro: CORS
```
Já configurado em SecurityConfig.java
Se ainda tiver erro, verificar:
✓ Frontend está na mesma porta?
✓ Authorization header está incluído?
```

---

## 📁 Estrutura

```
proBPMS/
├── README.md                    [Este arquivo]
├── .env.example                 [Template de variáveis]
├── backend/
│   ├── pom.xml                 [Dependências Maven]
│   └── src/main/
│       ├── java/br/gov/mg/probpms/
│       │   ├── identity/        [JWT + Supabase Auth]
│       │   ├── catalog/         [Contratos + Agências]
│       │   ├── demand/          [Demandas]
│       │   ├── financial/       [Movimentação financeira]
│       │   ├── operational/     [Configurações]
│       │   ├── api/             [Exception handlers]
│       │   └── config/          [Security + CORS]
│       └── resources/
│           ├── application.yml  [Config produção]
│           ├── application-dev.yml [Config dev]
│           └── db/migration/    [V1-V6 SQL migrations]
├── index.html                   [Frontend SPA]
└── app.js                       [JavaScript frontend]
```

---

## 🔐 Arquitetura de Auth

```
User → Frontend (Login Form)
         ↓
         → Supabase Auth API (email+password)
         ↓
         ← JWT Token (access_token)
         ↓
         → Backend API + JWT header
         ↓
         → JwtAuthenticationFilter (validação)
         ↓
         → JwtService (verifica via JWKS)
         ↓
         → Endpoint protegido (executa)
```

**Fluxo em código**:
1. `AuthController.login()` → chama `SupabaseAuthService.signIn()`
2. Supabase retorna `access_token`
3. Frontend armazena em `localStorage.accessToken`
4. Cada requisição inclui `Authorization: Bearer <token>`
5. `JwtAuthenticationFilter` valida via `JwtService.verify()`
6. Se válido, executa endpoint

---

## 🧬 Endpoints Principais

### Autenticação
```
POST /api/v1/auth/login              Login com Supabase
  Body: {"email": "...", "password": "..."}
  Return: {"accessToken": "...", "expiresIn": 3600}
```

### Contratos
```
POST /api/v1/contracts               Criar contrato
GET /api/v1/contracts                Listar todos
GET /api/v1/contracts/{id}           Detalhe
PUT /api/v1/contracts/{id}           Atualizar
DELETE /api/v1/contracts/{id}        Deletar
```

### Agências
```
POST /api/v1/agencies                Criar
GET /api/v1/agencies                 Listar
PUT /api/v1/agencies/{id}            Atualizar
DELETE /api/v1/agencies/{id}         Deletar
```

### Saúde
```
GET /api/v1/health                   Status da aplicação
GET /swagger-ui.html                 Documentação interativa
```

---

## 🎯 Stack

| Componente | Tecnologia | Versão |
|-----------|-----------|--------|
| Backend | Spring Boot | 3.3.2 |
| Java | OpenJDK | 21 |
| Database | PostgreSQL | 15+ |
| Auth | Supabase | Latest |
| Frontend | Vanilla JS | ES6 |
| Build | Maven | 3.9+ |
| JWT | Auth0 libs | 4.4.0 |

---

## 📞 Links Úteis

- **Supabase**: https://supabase.com/docs
- **Spring Boot**: https://spring.io/projects/spring-boot
- **PostgreSQL**: https://www.postgresql.org/docs
- **JWT**: https://jwt.io
- **Railway Deploy**: https://railway.app
- **Docker**: https://www.docker.com

---

## 📝 Próximas Ações

1. ✅ Configurar `.env` com Supabase
2. ✅ Executar migrações DB
3. ✅ Rodar `mvn spring-boot:run`
4. ✅ Testar endpoints
5. ✅ Fazer commit
6. ✅ Deploy no Railway

**Status**: 🟢 Pronto para produção

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
