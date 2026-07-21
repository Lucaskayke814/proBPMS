# Guia de Teste - proBPMS

## Criar Usuário de Teste no Supabase

### 1. Via Supabase Dashboard

1. Acesse [Supabase Console](https://supabase.com/dashboard)
2. Selecione o projeto `cyolmcowhfhymemmxgrn`
3. Vá para **Authentication > Users**
4. Clique em **+ Add user**
5. Preencha:
   - Email: `teste@probpms.local`
   - Password: `Senha@123456`
   - Auto Confirm User: ✓ (marcar)
6. Clique em **Create user**

### 2. Via Supabase API

```bash
SUPABASE_URL="https://cyolmcowhfhymemmxgrn.supabase.co"
SUPABASE_SERVICE_KEY="sb_secret_IkxGFMeYY2GMSVQemViUEA_fzfIPykE"

curl -X POST "$SUPABASE_URL/auth/v1/admin/users" \
  -H "apikey: $SUPABASE_SERVICE_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@probpms.local",
    "password": "Senha@123456",
    "email_confirm": true
  }'
```

---

## Testar Login

### 1. Via Interface Web

1. Acesse **http://localhost:8080**
2. Preencha:
   - Email: `teste@probpms.local`
   - Senha: `Senha@123456`
3. Clique em **Entrar**
4. Você será redirecionado ao Dashboard

### 2. Via cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@probpms.local",
    "password": "Senha@123456"
  }' | jq .
```

Resposta esperada:
```json
{
  "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600
}
```

---

## Testar API com Token

### 1. Guardar Token

```bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@probpms.local",
    "password": "Senha@123456"
  }' | jq -r '.accessToken')

echo $TOKEN
```

### 2. Listar Contratos

```bash
curl -X GET http://localhost:8080/api/v1/contracts \
  -H "Authorization: Bearer $TOKEN" | jq .
```

### 3. Criar Contrato

```bash
curl -X POST http://localhost:8080/api/v1/contracts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "CNT-2026-001",
    "year": 2026,
    "objectDescription": "Serviços de TI",
    "supplierName": "TechCorp",
    "totalAmount": 100000.00,
    "startsOn": "2026-01-01",
    "endsOn": "2026-12-31",
    "managerName": "João Silva",
    "fiscalName": "Maria Santos",
    "notes": "Teste"
  }' | jq .
```

---

## Testar Swagger UI

1. Acesse: **http://localhost:8080/swagger-ui.html**
2. Clique em **Authorize** (cadeado)
3. Cole o token no campo `Authorization`
4. Clique em **Authorize**
5. Explore e teste os endpoints interativamente

---

## Seed de Dados para Testes

### 1. Criar Órgão Anuente

```bash
curl -X POST http://localhost:8080/api/v1/agencies \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Secretaria de Estado de Planejamento",
    "acronym": "SEPLAG",
    "contactName": "Carlos Silva",
    "contactEmail": "carlos@seplag.mg.gov.br",
    "phone": "31 3915-0000",
    "availableAmount": 500000.00,
    "notes": "Órgão responsável"
  }' | jq .
```

### 2. Criar Funcionalidade

```bash
curl -X POST http://localhost:8080/api/v1/operational/features \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Login com Supabase",
    "systemName": "probpms-api",
    "description": "Integração de autenticação com Supabase",
    "requesterName": "Desenvolvimento",
    "sprint": "Sprint 1",
    "version": "1.0.0",
    "status": "CONCLUÍDO",
    "complexity": "ALTA"
  }' | jq .
```

---

## Testes Automatizados

### Unit Tests

```bash
cd backend
mvn test
```

### Integration Tests

```bash
mvn verify
```

---

## Monitorar Requisições

### 1. Ver logs do Spring

```bash
# Com boot:run
tail -f $TMPDIR/org.springframework.boot.*/output.log

# Ou via Docker
docker logs -f probpms
```

### 2. Habilitar DEBUG

Adicionar ao `application.yml`:

```yaml
logging:
  level:
    br.gov.mg.probpms: DEBUG
    org.springframework.security: DEBUG
    org.springframework.web: DEBUG
```

### 3. Usar Network Inspector

```bash
# Registrar toda requisição HTTP
tcpdump -i lo0 -n 'tcp port 8080'
```

---

## Casos de Teste Manuais

### ✓ TC-001: Login com credenciais válidas
1. Acessar http://localhost:8080
2. Preencher email e senha de teste
3. Clique em Entrar
4. **Esperado**: Redirecionar ao dashboard

### ✓ TC-002: Login com credenciais inválidas
1. Acessar http://localhost:8080
2. Preencher email/senha incorretos
3. Clique em Entrar
4. **Esperado**: Mensagem "Credenciais inválidas"

### ✓ TC-003: Acessar recurso protegido sem token
1. Abrir DevTools (F12)
2. Limpar localStorage: `localStorage.clear()`
3. Acessar http://localhost:8080
4. **Esperado**: Mostrar tela de login

### ✓ TC-004: Criar contrato como GESTOR_CENTRAL
1. Login como usuário com role GESTOR_CENTRAL
2. Vá para aba "Contratos"
3. Preencher formulário (via API ou UI futura)
4. **Esperado**: Contrato aparece na lista

### ✓ TC-005: Tentar criar contrato como TECNICO (sem permissão)
1. Login como usuário com role TECNICO
2. Enviar POST /api/v1/contracts
3. **Esperado**: Erro 403 Forbidden

### ✓ TC-006: Token expirado
1. Fazer login
2. Aguardar 1 hora (ou ajustar `security.jwt.ttl-seconds`)
3. Tentar acessar recurso protegido
4. **Esperado**: Erro 401 Unauthorized, redirecionar ao login

---

## Performance Baseline

Testar com [Apache Bench](https://httpd.apache.org/docs/2.4/programs/ab.html) ou [wrk](https://github.com/wg/wrk):

```bash
# Listar 100 requisições
ab -n 100 -c 10 \
  -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/contracts

# Esperado: > 100 req/sec, latência < 50ms
```

---

## Troubleshooting Testes

| Erro | Causa | Solução |
| --- | --- | --- |
| 401 Unauthorized | Token inválido/expirado | Fazer login novamente |
| 403 Forbidden | Falta de permissão | Usar usuário com role adequado |
| 404 Not Found | Recurso não existe | Verificar ID ou criar recurso |
| 500 Internal Error | Erro na API | Verificar logs do backend |
| Connection refused | Backend parado | `mvn spring-boot:run` |

