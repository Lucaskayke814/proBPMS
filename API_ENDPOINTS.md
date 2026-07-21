# proBPMS API - Endpoints

## Autenticação

### Login
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "usuario@example.com",
  "password": "senha123"
}

Resposta 200:
{
  "accessToken": "eyJhbGc...",
  "tokenType": "Bearer",
  "expiresIn": 3600
}
```

## Catálogo

### Contratos
```
GET /api/v1/contracts
Authorization: Bearer <token>

Resposta 200: Array<{id, number, year, objectDescription, totalAmount, status}>

---

GET /api/v1/contracts/{id}
Authorization: Bearer <token>

Resposta 200: {id, number, year, objectDescription, supplierName, totalAmount, executedAmount, balanceAmount, ...}

---

POST /api/v1/contracts
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL

{
  "number": "CNT-2026-001",
  "year": 2026,
  "objectDescription": "Serviços de TI",
  "supplierName": "TechCorp",
  "totalAmount": 100000.00,
  "startsOn": "2026-01-01",
  "endsOn": "2026-12-31",
  "managerName": "João Silva",
  "fiscalName": "Maria Santos",
  "notes": "Contrato principal"
}

Resposta 201: {id, number, year, objectDescription, totalAmount, status}
```

### Órgãos Anuentes
```
GET /api/v1/agencies
Authorization: Bearer <token>

Resposta 200: Array<{id, name, acronym}>

---

GET /api/v1/agencies/{id}
Authorization: Bearer <token>

Resposta 200: {id, name, acronym, contactName, contactEmail, phone, availableAmount, consumedAmount, balanceAmount, notes}

---

POST /api/v1/agencies
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL

{
  "name": "Secretaria de Estado de Planejamento",
  "acronym": "SEPLAG",
  "contactName": "Carlos Silva",
  "contactEmail": "carlos@seplag.mg.gov.br",
  "phone": "31 3915-0000",
  "availableAmount": 500000.00,
  "notes": "Órgão responsável pela gestão"
}

Resposta 201: {id, name, acronym}
```

## Operacional

### Dashboard
```
GET /api/v1/operational/dashboard
Authorization: Bearer <token>

Resposta 200: {
  "totalFeatures": 10,
  "totalErrors": 2,
  "totalApis": 5,
  "totalPublications": 3,
  "totalModules": 8
}
```

### Funcionalidades
```
GET /api/v1/operational/features
Authorization: Bearer <token>

Resposta 200: Array<{id, title, systemName, status, sprint, version}>

---

POST /api/v1/operational/features
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL, GESTOR_SETORIAL

{
  "title": "Validação de e-mail",
  "systemName": "probpms-auth",
  "description": "Adicionar validação de e-mail",
  "requesterName": "Desenvolvimento",
  "sprint": "Sprint 10",
  "version": "1.0.0",
  "status": "PLANEJADO",
  "complexity": "MÉDIA"
}

Resposta 201: {id, title, systemName, status, sprint, version}
```

### Erros
```
GET /api/v1/operational/errors
Authorization: Bearer <token>

Resposta 200: Array<{id, systemName, severity, status, responsibleName}>

---

POST /api/v1/operational/errors
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL, TECNICO

{
  "systemName": "probpms-api",
  "description": "Login retorna 500 em caso de DB indisponível",
  "severity": "CRÍTICO",
  "environment": "PRODUÇÃO",
  "status": "ABERTO"
}

Resposta 201: {id, systemName, severity, status, responsibleName}
```

### APIs
```
GET /api/v1/operational/apis
Authorization: Bearer <token>

Resposta 200: Array<{id, name, endpoint, httpMethod, status}>

---

POST /api/v1/operational/apis
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL, GESTOR_SETORIAL

{
  "name": "API de Contratos",
  "consumerSystem": "probpms-web",
  "providerSystem": "probpms-api",
  "endpoint": "/api/v1/contracts",
  "httpMethod": "GET",
  "authentication": "Bearer Token",
  "status": "ATIVA"
}

Resposta 201: {id, name, endpoint, httpMethod, status}
```

### Publicações
```
GET /api/v1/operational/publications
Authorization: Bearer <token>

Resposta 200: Array<{id, systemName, version, status, productionDate}>

---

POST /api/v1/operational/publications
Authorization: Bearer <token>
Content-Type: application/json
Requer Role: GESTOR_CENTRAL, TECNICO

{
  "systemName": "probpms-api",
  "version": "1.2.0",
  "sprint": "Sprint 12",
  "description": "Novas funcionalidades de gestão financeira",
  "status": "AGENDADO",
  "productionDate": "2026-08-15"
}

Resposta 201: {id, systemName, version, status, productionDate}
```

## Saúde

### Health Check
```
GET /api/v1/health
(Sem autenticação)

Resposta 200: {status: "UP", service: "probpms-api", timestamp: "2026-07-21T..."}
```

## Códigos de Erro

| Código | Significado |
| --- | --- |
| 200 | OK |
| 201 | Criado |
| 400 | Requisição inválida |
| 401 | Não autenticado |
| 403 | Acesso negado |
| 404 | Não encontrado |
| 500 | Erro interno |

## Autenticação com Bearer Token

Todas as requisições (exceto `/auth/login` e `/health`) requerem:

```
Authorization: Bearer <token-retornado-pelo-login>
```

O token é válido por 1 hora (3600 segundos) por padrão.
