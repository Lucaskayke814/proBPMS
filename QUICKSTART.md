# ⏱️ Início Rápido em 5 Minutos

## 1️⃣ Setup Inicial (1 min)

```bash
# Copiar arquivo de ambiente
cp .env.example .env

# (Já contém credenciais Supabase pré-preenchidas)
```

---

## 2️⃣ Iniciar Infraestrutura (1 min)

```bash
# Terminal 1: Iniciar Docker
docker-compose up -d

# Verificar
docker-compose ps  # Deve mostrar postgres e minio running
```

---

## 3️⃣ Corrigir Erros de Compilação (1 min - CRÍTICO)

**Antes de compilar, execute estas 4 correções:**

1. **Adicionar springdoc ao `backend/pom.xml`** (após a linha `springdoc-openapi-starter-webmvc-ui`):
   ```xml
   <dependency>
       <groupId>org.springdoc</groupId>
       <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
       <version>2.6.0</version>
   </dependency>
   ```

2. **Ver [COMPILE_ERRORS.md](COMPILE_ERRORS.md)** para as outras 3 correções (5 min)

---

## 4️⃣ Build e Execução (1.5 min)

```bash
# Terminal 2: Backend
cd backend

# Compilar
mvn clean compile

# Build
mvn clean package

# Rodar
java -jar target/probpms-api-*.jar
# ou
mvn spring-boot:run
```

**Esperar: "Started ProBpmsApplication"**

---

## 5️⃣ Acessar Aplicação (0.5 min)

```bash
# Abrir no navegador
http://localhost:8080
```

**Você verá**:
- ✅ Tela de login
- ✅ Campo email e senha
- ✅ Botão "Entrar"

---

## 🔑 Fazer Login

1. **Criar usuário no Supabase**:
   - Abra https://supabase.com/dashboard
   - Selecione projeto `cyolmcowhfhymemmxgrn`
   - Vá em **Authentication > Users**
   - Clique **+ Add user**
   - Email: `teste@probpms.local`
   - Password: `Senha@123`
   - Marca **Auto Confirm User**
   - Clique **Create user**

2. **Fazer login na app**:
   - Email: `teste@probpms.local`
   - Senha: `Senha@123`
   - Clique **Entrar**

3. **Dashboard aparecer** ✅

---

## 🧪 Testar API

```bash
# Terminal 3: Testes

# Health
curl http://localhost:8080/api/v1/health

# Listar contratos (sem token retorna erro 401)
curl http://localhost:8080/api/v1/contracts

# Ver Swagger
# http://localhost:8080/swagger-ui.html
```

---

## 🚀 Próximo Passo

1. Corrigir os 4 erros em [COMPILE_ERRORS.md](COMPILE_ERRORS.md) (~30 min)
2. Implementar forms CRUD em [ROADMAP.md](ROADMAP.md) > Fase 2 (~2 horas)
3. Ver [TESTING.md](TESTING.md) para mais testes

---

## ⚠️ Se Algo Quebrar

| Problema | Solução |
| --- | --- |
| Port 8080 em uso | `lsof -ti:8080 \| xargs kill -9` |
| Compile error | Ver [COMPILE_ERRORS.md](COMPILE_ERRORS.md) |
| DB não conecta | `docker-compose ps` (DB rodando?) |
| Login falha | Usuário criado no Supabase? |
| API retorna 500 | Ver logs: `docker logs probpms` |

---

## 📚 Documentação Importante

- **[STATUS.md](STATUS.md)** - Visão geral (leia primeiro!)
- **[COMPILE_ERRORS.md](COMPILE_ERRORS.md)** - Erros de build (CRÍTICO)
- **[ROADMAP.md](ROADMAP.md)** - Próximas tarefas
- **[QUICKREF.md](QUICKREF.md)** - Comandos úteis
- **[API_ENDPOINTS.md](API_ENDPOINTS.md)** - Endpoints REST
- **[TESTING.md](TESTING.md)** - Como testar
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Deploy em produção

---

**Tempo total: ~5 minutos ⏱️**  
**Resultado: App rodando + Dashboard visível ✅**

---

### Checklist de Validação

- [ ] `.env` copiado
- [ ] `docker-compose up -d` rodando
- [ ] Erros compilação corrigidos
- [ ] Backend compilou sem erros
- [ ] `http://localhost:8080` acessível
- [ ] Usuário criado no Supabase
- [ ] Login funciona
- [ ] Dashboard carrega dados

**Tudo OK? Prosseguir para [ROADMAP.md](ROADMAP.md) Fase 2** 🚀
