# 🗺️ Roadmap - proBPMS

## Fases de Desenvolvimento

### ✅ Fase 0: Foundation (Completo)
- [x] Backend Spring Boot 3.3.2
- [x] Autenticação Supabase + JWT
- [x] Frontend SPA (HTML/CSS/JS)
- [x] 20+ endpoints REST
- [x] Documentação inicial
- [x] Docker Compose setup

**Status**: ✅ 100%  
**Estimado**: 40h  
**Executado**: Completado

---

### 🔴 Fase 1: Compilação e Setup (AGORA)
**Duração**: 30 minutos - 1 hora  
**Prioridade**: CRÍTICA

#### Tasks
1. [ ] Adicionar springdoc dependency ao pom.xml
2. [ ] Separar OperationalDtos em 10 arquivos
3. [ ] Tratar exceptions em JwtService
4. [ ] Resolver type safety em SupabaseAuthService
5. [ ] `mvn clean compile` sem erros
6. [ ] `mvn clean package` gera JAR
7. [ ] `java -jar` inicia sem crashes

#### Validação
```bash
curl http://localhost:8080/api/v1/health
# {"status":"UP",...}
```

**Blocker**: Se não passar, projeto não compila.

---

### 🟡 Fase 2: CRUD Forms (2-3 horas)
**Prioridade**: ALTA  
**Impacto**: Permite entrada de dados

#### Task 2.1: Contract Create Form
- [ ] Modal HTML com campos:
  - [ ] number (text, obrigatório)
  - [ ] year (number, obrigatório)
  - [ ] objectDescription (textarea, obrigatório)
  - [ ] supplierName (text, obrigatório)
  - [ ] totalAmount (number, obrigatório)
  - [ ] startsOn (date)
  - [ ] endsOn (date)
  - [ ] managerName (text)
  - [ ] fiscalName (text)
  - [ ] notes (textarea)
- [ ] Button "Criar Contrato" que:
  - [ ] Valida campos obrigatórios
  - [ ] POST para /api/v1/contracts
  - [ ] Mostra erro se falhar
  - [ ] Recarrega lista se sucesso
  - [ ] Limpa form

#### Task 2.2: Contract Edit Form
- [ ] Modal similar ao create
- [ ] Prefill com dados atuais via GET /contracts/{id}
- [ ] Button "Atualizar" que PATCH /contracts/{id}

#### Task 2.3: Contract Delete
- [ ] Button "Deletar" em cada linha da tabela
- [ ] Dialog de confirmação
- [ ] DELETE /api/v1/contracts/{id}

#### Task 2.4: Repetir para Agencies
- [ ] Fields: name, acronym, contactName, contactEmail, phone, availableAmount, notes
- [ ] Create, Edit, Delete forms

#### Validação
- [ ] Criar 5 contratos via UI
- [ ] Editar 1 contrato
- [ ] Deletar 1 contrato
- [ ] Verificar em Swagger que dados estão corretos

**Estimado**: 2-3 horas  
**Blocker**: Nenhum - pode fazer em paralelo

---

### 🟠 Fase 3: Demand Management (1-2 horas)
**Prioridade**: ALTA  
**Dependência**: Fase 2 (para compreender padrão)

#### Task 3.1: Demand List
- [ ] GET /api/v1/demands
- [ ] Render tabela com: id, title, status, priority, contract
- [ ] Similar ao contracts list

#### Task 3.2: Demand Create Form
- [ ] Modal com campos:
  - [ ] title (text, obrigatório)
  - [ ] description (textarea)
  - [ ] contractId (select dropdown, obrigatório)
  - [ ] agencyId (select dropdown)
  - [ ] priority (select: LOW, MEDIUM, HIGH)
  - [ ] status (select: OPEN, IN_PROGRESS, CLOSED)
- [ ] POST /api/v1/demands

#### Task 3.3: Demand Detail View
- [ ] GET /api/v1/demands/{id}
- [ ] Mostrar todos os campos
- [ ] Botão para editar/deletar

#### Validação
- [ ] Criar demanda ligada a contrato
- [ ] Alterar status
- [ ] Verificar transição de estados

**Estimado**: 1-2 horas

---

### 💰 Fase 4: Movimentação Financeira (2-3 horas)
**Prioridade**: ALTA  
**Dependência**: Fase 2

#### Task 4.1: Financial Movements List
- [ ] GET /api/v1/financial/movements
- [ ] Campos: date, type, contractId, amount, balance
- [ ] Filtro por contrato

#### Task 4.2: Create Movement
- [ ] Modal para criar movimento
- [ ] Campos:
  - [ ] contractId (select)
  - [ ] type (COMMITMENT, LIQUIDATION, PAYMENT, REVERSAL)
  - [ ] amount (number, obrigatório)
  - [ ] description (textarea)
- [ ] POST /api/v1/financial/movements
- [ ] Validar saldo disponível antes de permitir

#### Task 4.3: Totals Dashboard
- [ ] GET /api/v1/financial/summary
- [ ] Mostrar: Total empenho, liquidação, pagamento, saldo

#### Validação
- [ ] Criar empenho dentro do total contratado
- [ ] Tentar empenho acima do total (deve falhar)
- [ ] Ver saldo atualizado

**Estimado**: 2-3 horas

---

### 📄 Fase 5: Upload de Documentos (1-2 horas)
**Prioridade**: MÉDIA  
**Dependência**: Fase 1 (SupabaseStorageService já existe)

#### Task 5.1: Upload Form
- [ ] File input para seleção
- [ ] Drop zone drag-and-drop (opcional)
- [ ] Validação de tipo (PDF, XLSX, DOC)
- [ ] Validação de tamanho (max 10MB)

#### Task 5.2: Upload Handler
- [ ] POST para SupabaseStorageService
- [ ] UploadFile(bucket, fileName, fileData)
- [ ] Retorna URL pública

#### Task 5.3: Document Listing
- [ ] GET /storage/v1/object/{bucket}?list=true
- [ ] Render lista de arquivos
- [ ] Link para download

#### Task 5.4: Document Management
- [ ] Button "Download"
- [ ] Button "Deletar" (DELETE /storage/v1/object/{bucket}/{path})

#### Validação
- [ ] Upload arquivo de teste
- [ ] Verificar em MinIO console
- [ ] Download e validar integridade

**Estimado**: 1-2 horas

---

### 🔐 Fase 6: Segurança e Admin (2-3 horas)
**Prioridade**: MÉDIA  
**Dependência**: Fase 2

#### Task 6.1: User Management Panel
- [ ] Dashboard admin apenas para GESTOR_CENTRAL
- [ ] Lista de usuários Supabase
- [ ] Atribuir roles (GESTOR_CENTRAL, GESTOR_SETORIAL, TECNICO)
- [ ] Ativar/Desativar usuários

#### Task 6.2: Audit Log
- [ ] Listar todas as ações (create, update, delete)
- [ ] Filtro por usuário, data, tipo de ação
- [ ] Campos: timestamp, user, action, resource, details

#### Task 6.3: Permission Validation
- [ ] Testar que cada role só vê sua permissão
- [ ] GESTOR_SETORIAL só vê sua agência
- [ ] TECNICO tem acesso apenas leitura

**Estimado**: 2-3 horas

---

### 🧪 Fase 7: Testes e QA (3-4 horas)
**Prioridade**: ALTA  
**Dependência**: Fase 2, 3, 4, 5

#### Task 7.1: Testes Unitários
- [ ] JwtService (verificar validação)
- [ ] AuthenticationFilter (extrair role)
- [ ] CatalogService (CRUD logic)

#### Task 7.2: Testes de Integração
- [ ] Login -> GET contracts
- [ ] Create contract -> GET contracts (verificar na lista)
- [ ] Edit contract -> GET contract detail (verificar fields)
- [ ] Delete contract -> GET contracts (não deve aparecer)

#### Task 7.3: Testes E2E (Manual)
- [ ] Fluxo completo: Login -> Criar contrato -> Criar demanda -> Criar movimento -> Upload doc -> Logout
- [ ] Testar com 3 roles diferentes
- [ ] Testar errors (400, 401, 403, 404, 500)

#### Task 7.4: Performance
- [ ] Load test com 100 requisições simultâneas
- [ ] Verificar latência < 100ms
- [ ] Verificar CPU/Memory

**Estimado**: 3-4 horas

---

### 🚀 Fase 8: Deployment (2-3 horas)
**Prioridade**: ALTA  
**Dependência**: Fase 7 (testes passando)

#### Task 8.1: Docker Build
- [ ] Criar Dockerfile otimizado
- [ ] Build multi-stage (compilar + run)
- [ ] Tag image: `probpms:latest`, `probpms:v1.0.0`

#### Task 8.2: Deploy Local
- [ ] Docker run com variáveis de env
- [ ] Testar endpoints
- [ ] Ver logs

#### Task 8.3: Deploy Produção
- [ ] Escolher ambiente (Azure, AWS, etc)
- [ ] Criar secrets (JWT_SECRET, SUPABASE_KEY)
- [ ] Configurar SSL/TLS
- [ ] Setup backups automáticos

#### Task 8.4: CI/CD
- [ ] GitHub Actions (build + deploy automático)
- [ ] Testes rodam a cada push
- [ ] Deploy automático se testes passarem

**Estimado**: 2-3 horas

---

### 📊 Fase 9: Monitoramento e Observabilidade (2 horas)
**Prioridade**: MÉDIA  
**Dependência**: Fase 8

#### Task 9.1: Logging Centralizador
- [ ] ELK Stack ou CloudWatch
- [ ] Ver todos os logs centralizados
- [ ] Alertas para erros

#### Task 9.2: Métricas
- [ ] Prometheus para coleta
- [ ] Grafana para visualização
- [ ] Dashboards: CPU, Memory, Requests, Latency

#### Task 9.3: Tracing Distribuído
- [ ] Jaeger para rastrear requisições
- [ ] Ver fluxo completo (Controller -> Service -> DB)

**Estimado**: 2 horas

---

## Timeline Total

| Fase | Tasks | Estimado | Status |
| --- | --- | --- | --- |
| 0 | Foundation | 40h | ✅ Done |
| 1 | Compilação | 1h | 🔴 Next |
| 2 | CRUD Forms | 2-3h | 🟡 Priority |
| 3 | Demandas | 1-2h | 🟡 Priority |
| 4 | Financeiro | 2-3h | 🟡 Priority |
| 5 | Upload | 1-2h | 🟠 Nice to have |
| 6 | Admin/Security | 2-3h | 🟠 Nice to have |
| 7 | Testes | 3-4h | 🟠 Nice to have |
| 8 | Deploy | 2-3h | 🟠 Nice to have |
| 9 | Monitoring | 2h | 🟢 Optional |
| **TOTAL** | **~45 tasks** | **~60-80h** | - |

---

## Roadmap Visual

```
Jul 2026                Aug 2026              Set 2026
│                      │                      │
├─ Fase 1: Compile (HOJE)                    
│  └─ 1h
│
├─ Fase 2: Forms ──────┤
│  └─ 2-3h
│
├─ Fase 3: Demands ────┤
│  └─ 1-2h
│
├─ Fase 4: Financeiro─┤
│  └─ 2-3h
│
├─ Fase 5: Upload ────┤
│  └─ 1-2h
│
├─ Fase 6: Admin ─────┤
│  └─ 2-3h
│
├─ Fase 7: Testes ────┤
│  └─ 3-4h
│
└─ Fase 8-9: Deploy ──────────────┤
   └─ 4-5h                        v Production Ready ✅
```

---

## Como Usar Este Roadmap

1. **Leia STATUS.md** para visão geral
2. **Abra QUICKREF.md** para comandos
3. **Siga Fase 1** (Compile) - blocker crítico
4. **Siga Fase 2** (Forms) - maior impacto
5. **Confira COMPILE_ERRORS.md** se travar
6. **Use TESTING.md** para validar cada fase

---

## Métricas de Sucesso

| Fase | Métrica | Alvo |
| --- | --- | --- |
| 1 | Build sucesso | 100% |
| 2 | Contracts CRUD | 5 testes |
| 3 | Demands criadas | 10 total |
| 4 | Movimentos | Saldo válido |
| 5 | Upload | 5 arquivos |
| 6 | Admin | 3 usuários |
| 7 | Tests pass | 100% |
| 8 | Deploy | Live em 1h |
| 9 | Monitoring | Dashboards ativos |

---

## Notas Importantes

### Antes de Cada Fase
1. Ler documentação relevante
2. Verificar dependências completadas
3. Cria branch git
4. Escrever testes primeiro (TDD)

### Durante Cada Fase
1. Validar localmente
2. Testar via Swagger
3. Verificar logs
4. Commit frequentes

### Depois de Cada Fase
1. Code review
2. Testes manuais
3. Merge para main
4. Deploy test

---

**Última atualização**: Jul 2026  
**Versão**: 1.0 Alpha  
**Próximo**: Fase 1 (Compilação)
