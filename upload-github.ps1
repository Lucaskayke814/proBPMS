#!/usr/bin/env pwsh
# Script para subir proBPMS no GitHub

Write-Host "╔════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   proBPMS - GitHub Upload Helper   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar Git
Write-Host "[1/5] Verificando Git..." -ForegroundColor Yellow
try {
  $gitVersion = git --version
  Write-Host "✓ $gitVersion" -ForegroundColor Green
} catch {
  Write-Host "✗ Git não encontrado!" -ForegroundColor Red
  Write-Host "📥 Instale em: https://git-scm.com/download/win" -ForegroundColor Blue
  exit 1
}

# Configurar Git
Write-Host ""
Write-Host "[2/5] Configurando Git..." -ForegroundColor Yellow
$userName = git config user.name
$userEmail = git config user.email

if (-not $userName) {
  Write-Host "📝 Configure seu Git:" -ForegroundColor Cyan
  git config --global user.name "Seu Nome"
  git config --global user.email "seu.email@gmail.com"
  Write-Host "✓ Configurado" -ForegroundColor Green
} else {
  Write-Host "✓ Já configurado: $userName ($userEmail)" -ForegroundColor Green
}

# Inicializar repo
Write-Host ""
Write-Host "[3/5] Inicializando repositório..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
  git init
  Write-Host "✓ Repositório criado" -ForegroundColor Green
} else {
  Write-Host "✓ Repositório já existe" -ForegroundColor Green
}

# Criar .gitignore
Write-Host ""
Write-Host "[4/5] Criando .gitignore..." -ForegroundColor Yellow
if (-not (Test-Path ".gitignore")) {
  @"
# Java
target/
*.class
*.jar
*.war
*.nar
*.log
.classpath
.project
.settings/
.vscode/
.idea/

# Maven
pom.xml.tag
pom.xml.releaseBackup

# Node
node_modules/
npm-debug.log
.next/

# Env
.env
.env.local
.env.*.local

# OS
.DS_Store
Thumbs.db

# IDE
*.swp
*.swo
*~
.history/

# Build
dist/
build/
out/
"@ | Out-File ".gitignore" -Encoding UTF8
  Write-Host "✓ .gitignore criado" -ForegroundColor Green
} else {
  Write-Host "✓ .gitignore já existe" -ForegroundColor Green
}

# Adicionar e fazer commit
Write-Host ""
Write-Host "[5/5] Preparando para upload..." -ForegroundColor Yellow
git add .
$status = git status --short

if ($status) {
  Write-Host "📦 Arquivos a fazer commit:" -ForegroundColor Cyan
  Write-Host $status -ForegroundColor Gray
  Write-Host ""
  
  git commit -m "🎉 Initial commit - proBPMS with professional UI"
  Write-Host "✓ Commit criado" -ForegroundColor Green
} else {
  Write-Host "✓ Sem alterações a fazer commit" -ForegroundColor Green
}

Write-Host ""
Write-Host "╔════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        PRÓXIMO PASSO               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Crie um repositório vazio no GitHub:" -ForegroundColor Yellow
Write-Host "   https://github.com/new" -ForegroundColor Blue
Write-Host ""
Write-Host "2️⃣  Copie a URL do repositório (SSH ou HTTPS)" -ForegroundColor Yellow
Write-Host ""
Write-Host "3️⃣  Execute este comando (substitua SEU_USUARIO):" -ForegroundColor Yellow
Write-Host ""
Write-Host "   git remote add origin https://github.com/SEU_USUARIO/proBPMS.git" -ForegroundColor Magenta
Write-Host "   git branch -M main" -ForegroundColor Magenta
Write-Host "   git push -u origin main" -ForegroundColor Magenta
Write-Host ""
Write-Host "4️⃣  Depois, para testar SEM Maven:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Opção A - GitHub Codespaces (Recomendado):" -ForegroundColor Cyan
Write-Host "   - GitHub.com > Seu repo > Code > Codespaces > Create" -ForegroundColor Gray
Write-Host ""
Write-Host "   Opção B - Railway.app (Deploy Automático):" -ForegroundColor Cyan
Write-Host "   - Railway.app > New Project > GitHub > Deploy" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Guia completo: GITHUB_DEPLOY.md" -ForegroundColor Blue
Write-Host ""
