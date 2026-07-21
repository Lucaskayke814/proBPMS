# ⚡ Quick Reference - proBPMS

## Comandos Úteis

### Inicializar Projeto
```bash
# Clonar / entrar no projeto
cd c:\Users\x21588131\Desktop\proBPMS

# Iniciar Docker
docker-compose up -d

# Ver status
docker-compose ps
```

### Build e Execução
```bash
# Limpar e compilar
cd backend
mvn clean compile

# Compilar e testar
mvn clean package

# Rodar
mvn spring-boot:run

# Ou rodar JAR direto
java -jar target/probpms-api-*.jar
```

### Testar API
```bash
# Health check
curl http://localhost:8080/api/v1/health

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@probpms.local","password":"senha123"}'

# Listar contratos (com token)
curl -X GET http://localhost:8080/api/v1/contracts \
  -H "Authorization: Bearer <token>"
```

### Ver Logs
```bash
# Local
tail -f backend/logs/probpms.log

# Docker
docker logs -f probpms

# Systemd
sudo journalctl -u probpms -f
```

### Limpar Cache
```bash
# Remover DB volume
docker-compose down -v

# Limpar Maven
mvn clean

# Limpar token do browser (DevTools)
localStorage.clear()
```

---

## URLs Importantes

| URL | Propósito |
| --- | --- |
| http://localhost:8080 | App Frontend |
| http://localhost:8080/swagger-ui.html | API Docs |
| http://localhost:9000 | MinIO Console |
| http://localhost:5432 | PostgreSQL |
| https://supabase.com/dashboard | Supabase |

---

## Estrutura de Pastas

```
backend/
├── src/main/
│   ├── java/br/gov/mg/probpms/
│   │   ├── api/               Controllers
│   │   ├── catalog/           Contratos/Agências
│   │   ├── demand/            Demandas
│   │   ├── financial/         Financeiro
│   │   ├── identity/          Auth/JWT
│   │   ├── operational/       Dashboard
│   │   └── infra/             Services externos
│   └── resources/
│       ├── static/            Frontend (HTML/CSS/JS)
│       ├── application.yml    Config
│       └── db/migration/      Flyway SQL
└── pom.xml
```

---

## Próximas Tarefas (Checklist)

### 🔴 CRÍTICO - Primeira Ação
- [ ] Ler [COMPILE_ERRORS.md](COMPILE_ERRORS.md)
- [ ] Corrigir erro 1: Adicionar springdoc ao pom.xml
- [ ] Corrigir erro 2: Separar OperationalDtos
- [ ] Corrigir erro 3: Tratar exceptions em JwtService
- [ ] Corrigir erro 4: Type safety em SupabaseAuthService
- [ ] Validar: `mvn clean package` sem erros
- [ ] Testar: `mvn spring-boot:run`
- [ ] Login em http://localhost:8080

### 🟡 IMPORTANTE - Segunda Ação (2-3 horas)
- [ ] Criar modal CREATE Contrato (ver form em STATUS.md)
- [ ] Criar modal EDIT Contrato
- [ ] Criar botão DELETE com confirmação
- [ ] Testar POST/PATCH/DELETE
- [ ] Repetir padrão para Agencies
- [ ] Atualizar index.html com novos forms
- [ ] Testar via Swagger

### 🟢 SECUNDÁRIA - Terceira Ação
- [ ] Implementar Demand Management
- [ ] Implementar Financeiro
- [ ] Implementar Upload de Documentos
- [ ] Escrever testes unitários
- [ ] QA e validação

---

## Documentação Rápida

| Arquivo | Para Quem | Tópico |
| --- | --- | --- |
| STATUS.md | Gerente | Visão geral do projeto |
| README.md | Dev | Como começar rápido |
| COMPILE_ERRORS.md | Dev | Erros e soluções |
| API_ENDPOINTS.md | Dev/QA | Endpoints REST |
| DEPLOYMENT.md | DevOps | Deploy em 4 cenários |
| TESTING.md | QA/Tester | Como testar |
| CHANGELOG.md | Todos | Histórico de mudanças |

---

## Configuração Rápida

### .env (após `cp .env.example .env`)
```
SUPABASE_URL=https://cyolmcowhfhymemmxgrn.supabase.co
SUPABASE_SECRET_KEY=your_secret_key_here
JWT_SECRET=chave-segura-32-caracteres-aqui
DB_URL=jdbc:postgresql://localhost:5432/probpms
DB_USER=probpms
DB_PASSWORD=probpms_dev
```

### Variáveis de Produção
```
SUPABASE_DB_URL=jdbc:postgresql://cyolmcowhfhymemmxgrn.postgres.supabase.co:5432/postgres
DB_USER=postgres
DB_PASSWORD=<senha-do-supabase-postgres>
JWT_SECRET=<gerar-novo-seguro>
```

---

## Troubleshooting Rápido

| Problema | Solução |
| --- | --- |
| Port 8080 em uso | `lsof -ti:8080 \| xargs kill -9` |
| DB não conecta | `docker-compose restart postgres` |
| JWT inválido | Fazer login novamente |
| 401 Unauthorized | Verificar Bearer token no header |
| 403 Forbidden | Verificar role do usuário |
| Swagger não abre | Adicionar springdoc dependency |
| Frontend branco | Ver DevTools > Console |

---

## Diagrama de Fluxo (ASCII)

```
┌──────────────┐
│  User Login  │
└──────┬───────┘
       │ email/password
       ↓
┌─────────────────────────┐
│ POST /api/v1/auth/login │
└──────┬──────────────────┘
       │
       ↓
┌──────────────────────────┐
│ SupabaseAuthService      │
└──────┬───────────────────┘
       │
       ↓
┌──────────────────────────┐
│ Supabase Auth API        │
└──────┬───────────────────┘
       │ JWT token
       ↓
┌──────────────────────────┐
│ localStorage.setItem     │
│ probpms_token            │
└──────┬───────────────────┘
       │
       ↓
┌──────────────────────────┐
│ Redirect to Dashboard    │
└──────┬───────────────────┘
       │ Authorization: Bearer jwt
       ↓
┌──────────────────────────┐
│ JwtAuthenticationFilter  │
│ + SecurityContext        │
└──────┬───────────────────┘
       │ roles loaded
       ↓
┌──────────────────────────┐
│ Return Protected Data    │
└──────────────────────────┘
```

---

## Validação Local (Passo a Passo)

1. **Terminal 1**: `docker-compose up -d`
2. **Terminal 2**: `cd backend && mvn spring-boot:run`
3. **Esperar**: "Started ProBpmsApplication in X seconds"
4. **Browser**: http://localhost:8080
5. **Supabase**: Criar usuário em https://supabase.com/dashboard
6. **Login**: Email e senha do usuário criado
7. **Dashboard**: Deve carregar com cards de resumo
8. **Swagger**: Testar em http://localhost:8080/swagger-ui.html

---

## Commits Recomendados

```bash
# Depois de corrigir erros
git commit -m "fix: corrigir erros de compilação"

# Depois de implementar forms
git commit -m "feat: implementar CRUD forms para contratos"

# Depois de testes
git commit -m "test: adicionar testes manuais"

# Deploy
git commit -m "chore: preparar para produção"
git tag v1.0.0-alpha
```

---

## Performance Baseline

```bash
# Apache Bench test
ab -n 100 -c 10 -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/contracts

# Esperado: > 100 req/s, latência < 50ms
```

---

## Contato / Dúvidas

- **Docs**: Ler o .md correspondente
- **Código**: Search em `backend/src`
- **API**: Teste em `/swagger-ui.html`
- **Logs**: `docker logs` ou `tail -f logs/`

---

**Última atualização**: Jul 2026  
**Status**: Ready for Testing ✅
