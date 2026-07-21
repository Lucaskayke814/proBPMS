# 🚀 COMO INICIAR O SISTEMA E CRIAR USUÁRIO SUPABASE

## 📦 PRÉ-REQUISITOS
- Java 21+ instalado (você tem Java 8, precisa atualizar: https://adoptium.net/)
- Maven 3.8+ (https://maven.apache.org/download.cgi)
- Conta Supabase ativa: https://supabase.com

---

## ✅ PASSO 1: INSTALAR/CONFIGURAR MAVEN

### Opção A: Instalar Maven via Scoop (Windows)
```powershell
scoop install maven
```

### Opção B: Instalar Maven Manualmente
1. Download: https://maven.apache.org/download.cgi
2. Extrair para: `C:\Program Files\apache-maven`
3. Adicionar ao PATH:
   - Abrir "Variáveis de Ambiente"
   - Adicionar: `C:\Program Files\apache-maven\bin`
   - Reiniciar PowerShell

### Verificar instalação:
```powershell
mvn -version
```

---

## 🔧 PASSO 2: CONFIGURAR AMBIENTE

### Copiar arquivo de exemplo
```powershell
cd c:\Users\x21588131\Desktop\proBPMS\backend
cp .env.example .env
```

### Editar `.env` com credenciais Supabase:
```env
SUPABASE_URL=https://cyolmcowhfhymemmxgrn.supabase.co
SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SECRET_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_DB_URL=postgresql://postgres:password@db.supabase.co:5432/postgres
JWT_SECRET=seu_secret_jwt_aqui
```

---

## 🏃 PASSO 3: INICIAR O SISTEMA

### Build do projeto
```powershell
cd c:\Users\x21588131\Desktop\proBPMS\backend
mvn clean package -DskipTests
```

### Iniciar servidor (opção 1 - via Maven)
```powershell
mvn spring-boot:run
```

### Iniciar servidor (opção 2 - via JAR)
```powershell
java -jar target/probpms-1.0.0.jar
```

**Aguardar até ver:**
```
Started ProBpmsApplication in X seconds
Tomcat started on port(s): 8080 (http)
```

### Acessar em navegador:
```
http://localhost:8080
```

---

## 👤 PASSO 4: CRIAR USUÁRIO NO SUPABASE

### Método 1: Via Dashboard Supabase (Recomendado)

1. **Abrir Supabase Console:**
   - https://app.supabase.com/
   - Selecionar projeto

2. **Ir em Authentication > Users**

3. **Clicar em "Invite"**

4. **Preencher:**
   - Email: `teste@exemplo.com`
   - Password: `Senha123!@#`
   - Confirmar senha

5. **Clicar em "Send invite"**
   - O usuário será criado imediatamente

---

### Método 2: Via cURL (Direto pela API)

```powershell
$email = "teste@exemplo.com"
$password = "Senha123!@#"
$supabaseUrl = "https://cyolmcowhfhymemmxgrn.supabase.co"
$apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."  # Sua PUBLISHABLE KEY

$body = @{
    email = $email
    password = $password
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "apikey" = $apiKey
}

Invoke-WebRequest -Uri "$supabaseUrl/auth/v1/signup" `
  -Method POST `
  -Headers $headers `
  -Body $body
```

---

### Método 3: Via Supabase CLI

```powershell
# Instalar Supabase CLI
scoop install supabase

# Login
supabase login

# Criar usuário
supabase auth users create `
  --email teste@exemplo.com `
  --password Senha123!@#
```

---

## 🧪 PASSO 5: TESTAR O SISTEMA

### Credenciais de Teste
```
Email:    teste@exemplo.com
Senha:    Senha123!@#
URL:      http://localhost:8080
```

### Testar Login
1. Abrir: http://localhost:8080
2. Inserir email e senha
3. Clicar "Entrar"

### Testar Dashboard
- Após login, você verá o Dashboard
- Contadores de contratos, órgãos, demandas

### Testar CRUD
1. **Contratos**:
   - Clicar em "Contratos" no menu
   - Clicar "+ Novo"
   - Preencher form
   - Clicar "Salvar"

2. **Órgãos**:
   - Clicar em "Órgãos Anuentes"
   - Clicar "+ Novo"
   - Preencher form
   - Clicar "Salvar"

---

## 🐛 TROUBLESHOOTING

### Erro: "Maven command not found"
```powershell
# Verificar PATH
$env:PATH -split ';' | findstr "maven"

# Adicionar manualmente:
$env:PATH += ";C:\Program Files\apache-maven\bin"
```

### Erro: "Connection refused" (DB)
- Sistema tentando conectar PostgreSQL local
- Use Supabase cloud (mais seguro)
- Configure `SUPABASE_DB_URL` no `.env`

### Erro: "Invalid JWT token"
- Token expirou
- Secret key incorreto em `.env`
- Fazer logout e login novamente

### Erro: "CORS error"
- Backend retornando erro de CORS
- Verificar SecurityConfig.java
- Deve permitir `/index.html`, `/app.js`, `/api/v1/**`

---

## 📝 LOGS DO SISTEMA

### Ver logs do Maven
```powershell
mvn spring-boot:run -X
```

### Ver logs do Java
```powershell
java -jar target/probpms-1.0.0.jar > logs.txt 2>&1
```

---

## 🔗 URLs ÚTEIS

- **App**: http://localhost:8080
- **Swagger API**: http://localhost:8080/swagger-ui.html
- **Health Check**: http://localhost:8080/api/v1/health
- **Supabase**: https://app.supabase.com/

---

## ✨ RESUMO RÁPIDO

```powershell
# 1. Instalar Maven
scoop install maven

# 2. Navegar ao projeto
cd c:\Users\x21588131\Desktop\proBPMS\backend

# 3. Iniciar
mvn spring-boot:run

# 4. Criar usuário no Supabase (dashboard)
# https://app.supabase.com/ > Auth > Users > Invite

# 5. Acessar
# http://localhost:8080
# Email: teste@exemplo.com
# Password: Senha123!@#
```

---

Qualquer dúvida, me chama! 🚀
