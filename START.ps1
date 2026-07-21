#!/usr/bin/env pwsh
# Script para instalar Maven e iniciar proBPMS

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  proBPMS - Setup & Start Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Java
Write-Host "[1/4] Verificando Java..." -ForegroundColor Yellow
try {
  $javaVersion = java -version 2>&1
  if ($javaVersion -like "*1.8*") {
    Write-Host "⚠️  Detectado: Java 8" -ForegroundColor Yellow
    Write-Host "ℹ️  Recomendado: Java 21+" -ForegroundColor Cyan
    Write-Host "📥 Download: https://adoptium.net/" -ForegroundColor Blue
  } else {
    Write-Host "✓ Java detectado:" -ForegroundColor Green
    Write-Host "  $javaVersion" -ForegroundColor Green
  }
} catch {
  Write-Host "✗ Java não encontrado!" -ForegroundColor Red
  Write-Host "📥 Instale em: https://adoptium.net/" -ForegroundColor Blue
  exit 1
}

# Verificar Maven
Write-Host ""
Write-Host "[2/4] Verificando Maven..." -ForegroundColor Yellow
try {
  $mvnVersion = mvn -version 2>&1
  Write-Host "✓ Maven encontrado" -ForegroundColor Green
  Write-Host "  $($mvnVersion[0])" -ForegroundColor Green
} catch {
  Write-Host "✗ Maven não encontrado" -ForegroundColor Red
  Write-Host ""
  Write-Host "=== OPÇÕES DE INSTALAÇÃO ===" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Opção 1: Instalar Scoop (recomendado)" -ForegroundColor Cyan
  Write-Host "  Abra PowerShell como Admin e execute:" -ForegroundColor White
  Write-Host "  iwr -useb get.scoop.sh | iex" -ForegroundColor Magenta
  Write-Host "  Depois: scoop install maven" -ForegroundColor Magenta
  Write-Host ""
  Write-Host "Opção 2: Instalar Chocolatey" -ForegroundColor Cyan
  Write-Host "  choco install maven" -ForegroundColor Magenta
  Write-Host ""
  Write-Host "Opção 3: Download manual" -ForegroundColor Cyan
  Write-Host "  https://maven.apache.org/download.cgi" -ForegroundColor Blue
  Write-Host ""
  exit 1
}

# Navegar ao projeto
Write-Host ""
Write-Host "[3/4] Preparando projeto..." -ForegroundColor Yellow
cd "c:\Users\x21588131\Desktop\proBPMS\backend"
if (Test-Path "pom.xml") {
  Write-Host "✓ pom.xml encontrado" -ForegroundColor Green
} else {
  Write-Host "✗ pom.xml não encontrado" -ForegroundColor Red
  exit 1
}

# Iniciar
Write-Host ""
Write-Host "[4/4] Iniciando servidor..." -ForegroundColor Yellow
Write-Host ""
Write-Host "🚀 Iniciando proBPMS..." -ForegroundColor Cyan
Write-Host "📍 URL: http://localhost:8080" -ForegroundColor Cyan
Write-Host "⏱️  Aguarde 30-60 segundos para inicializar..." -ForegroundColor Yellow
Write-Host ""

mvn spring-boot:run
