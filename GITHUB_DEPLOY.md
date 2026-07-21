# 🚀 SUBIR NO GITHUB E TESTAR SEM MAVEN

## ✅ SIM, É POSSÍVEL! (3 Formas)

---

## 📤 PASSO 1: PREPARAR E SUBIR NO GITHUB

### 1.1 Criar repositório no GitHub

1. Abra: https://github.com/new
2. Preencha:
   - **Repository name**: `proBPMS`
   - **Description**: `Gestão Contratual PRODEMGE`
   - **Public** (para testar público)
   - Clicar **"Create repository"**

### 1.2 Upload via Git (Terminal)

```powershell
# Navegar ao projeto
cd c:\Users\x21588131\Desktop\proBPMS

# Inicializar Git
git init

# Adicionar todos os arquivos
git add .

# Commit inicial
git commit -m "🎉 Initial commit - proBPMS"

# Adicionar repositório remoto (substitua SEU_USUARIO)
git remote add origin https://github.com/SEU_USUARIO/proBPMS.git

# Fazer push
git branch -M main
git push -u origin main
```

**Pronto!** Seu código está no GitHub ✅

---

## 🧪 OPÇÃO 1: GitHub Codespaces (MAIS FÁCIL - Recomendado)

### ✨ Vantagens
- ✅ Maven pré-instalado
- ✅ Java pré-instalado
- ✅ Sem instalar nada localmente
- ✅ Gratuito (60 horas/mês)
- ✅ IDE completa no navegador

### 🚀 Como usar

1. **Abra seu repo no GitHub**: https://github.com/SEU_USUARIO/proBPMS

2. **Clique em**: `Code > Codespaces > Create codespace on main`

3. **Aguarde abrir** (30 segundos)

4. **Terminal no Codespaces**:
   ```bash
   cd backend
   mvn spring-boot:run
   ```

5. **Popup aparecerá**: "Open http://localhost:8080"

6. **Clique para abrir** ✅

**PRONTO!** Sistema rodando sem Maven no seu PC!

---

## 🐳 OPÇÃO 2: Docker + GitHub (Recomendado para Deploy Real)

### Criar Dockerfile

Crie arquivo: `backend/Dockerfile`

```dockerfile
# Build stage
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Criar docker-compose.yml

Na raiz do projeto:

```yaml
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      SUPABASE_URL: https://cyolmcowhfhymemmxgrn.supabase.co
      SUPABASE_PUBLISHABLE_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
      SUPABASE_SECRET_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
      SUPABASE_DB_URL: postgresql://postgres:password@db.supabase.co:5432/postgres

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: probpms
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Testar localmente com Docker

```powershell
# Instalar Docker Desktop: https://www.docker.com/products/docker-desktop
# Depois:

cd c:\Users\x21588131\Desktop\proBPMS
docker-compose up
```

**Acesse**: http://localhost:8080

---

## 🌐 OPÇÃO 3: Deploy Automático no GitHub Actions

### Criar arquivo: `.github/workflows/deploy.yml`

```yaml
name: Build & Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: probpms
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 21
      uses: actions/setup-java@v3
      with:
        java-version: '21'
        distribution: 'temurin'
    
    - name: Build with Maven
      run: |
        cd backend
        mvn clean package -DskipTests
    
    - name: Upload JAR
      uses: actions/upload-artifact@v3
      with:
        name: app-jar
        path: backend/target/*.jar

    - name: Build Docker Image
      run: |
        cd backend
        docker build -t probpms:latest .
```

### Como funciona

1. **Você faz push** no GitHub
2. **GitHub Actions executa automaticamente**:
   - ✅ Compila com Maven
   - ✅ Roda testes
   - ✅ Cria Docker image
   - ✅ Armazena artefatos

**Resultado**: Você vê o status no GitHub (✅ ou ❌)

---

## 🌍 OPÇÃO 4: Deploy em Plataforma Gratuita

### Opção 4A: Render.com (Recomendado)

1. Abra: https://render.com
2. Clique: **"New+" > "Web Service"**
3. Conecte seu **repositório GitHub**
4. Configure:
   - **Name**: proBPMS
   - **Build Command**: `cd backend && mvn clean package -DskipTests`
   - **Start Command**: `java -jar backend/target/*.jar`
5. Clique **"Deploy"**

**Resultado**: App rodando publicamente em `https://probpms.onrender.com` 🎉

### Opção 4B: Railway.app

1. Abra: https://railway.app
2. Clique: **"New Project" > "Deploy from GitHub"**
3. Selecione seu repo
4. Railway detecta Maven automaticamente
5. Clique **"Deploy"** ✅

**Resultado**: App em `https://probpms-production.up.railway.app`

### Opção 4C: Heroku (Recomendado - Mais Fácil)

1. Abra: https://www.heroku.com
2. Clicar **"Create New App"**
3. Conectar **GitHub**
4. Habilitar **"Automatic Deploys"**
5. Fazer push no GitHub

**Resultado**: Deploy automático a cada push! 🚀

---

## 📊 COMPARAÇÃO DAS OPÇÕES

| Opção | Dificuldade | Maven? | Custo | Melhor Para |
|-------|------------|--------|-----|----|
| **Codespaces** | ⭐ Muito Fácil | ✅ Sim | Grátis | Desenvolvimento |
| **Docker Local** | ⭐⭐ Fácil | ✅ Via Docker | Grátis | Teste local |
| **GitHub Actions** | ⭐⭐⭐ Médio | ✅ Automático | Grátis | CI/CD |
| **Render.com** | ⭐⭐ Fácil | ✅ Automático | Grátis | Deploy |
| **Railway** | ⭐ Muito Fácil | ✅ Automático | Grátis | Deploy |
| **Heroku** | ⭐ Muito Fácil | ✅ Automático | Pago | Deploy Profissional |

---

## 🎯 RECOMENDAÇÃO PARA VOCÊ

### Para **testar agora sem instalar nada**:
👉 **GitHub Codespaces** (5 minutos, super fácil)

### Para **fazer deploy público**:
👉 **Railway.app** (10 minutos, completamente automático)

### Para **setup profissional**:
👉 **Docker + GitHub Actions + Heroku/Railway** (30 minutos, mas automático)

---

## 📝 RESUMO RÁPIDO

### Upload no GitHub
```powershell
cd c:\Users\x21588131\Desktop\proBPMS
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/SEU_USUARIO/proBPMS.git
git branch -M main
git push -u origin main
```

### Testar no Codespaces (SEM Maven)
```
1. GitHub.com > Seu repo
2. Code > Codespaces > Create
3. Aguarde abrir
4. Terminal: cd backend && mvn spring-boot:run
5. Clique no link localhost:8080
```

### Deploy no Railway (SEM Fazer Nada)
```
1. Railway.app
2. New Project > GitHub
3. Selecione repo
4. Clique Deploy
5. Pronto! URL pública em 5 minutos
```

---

## 🔗 LINKS ÚTEIS

- **GitHub**: https://github.com
- **Codespaces**: https://github.com/codespaces
- **Docker**: https://www.docker.com/products/docker-desktop
- **Railway**: https://railway.app
- **Render**: https://render.com
- **Heroku**: https://www.heroku.com

---

## ❓ FAQ

**P: Posso usar Codespaces grátis?**
R: Sim! 60 horas/mês (suficiente para desenvolvimento)

**P: Preciso de cartão de crédito?**
R: Railway e Render não cobram. Heroku cobra. Codespaces é grátis.

**P: Como conectar ao Supabase?**
R: As variáveis de ambiente já estão no `backend/src/main/resources/application.yml`

**P: E se quebrar algo no deploy?**
R: GitHub Actions e Railway fazem rollback automático da versão anterior

**P: Qual é mais rápido?**
R: Codespaces abre em 30s. Railway faz deploy em 2-3 minutos.

---

Qual opção quer tentar? 🚀
