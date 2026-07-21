#!/usr/bin/env pwsh
# Script para resolver erro de push no GitHub

Write-Host "╔════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Resolver Erro de Push GitHub     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 Erro encontrado:" -ForegroundColor Yellow
Write-Host "  [remote rejected] main -> main (push declined due to repository rule violations)" -ForegroundColor Red
Write-Host ""

Write-Host "🔍 Soluções disponíveis:" -ForegroundColor Cyan
Write-Host "  1. Desabilitar proteção de branch (GitHub Settings)" -ForegroundColor Gray
Write-Host "  2. Push para nova branch 'develop' (Recomendado)" -ForegroundColor Gray
Write-Host "  3. Force push (último recurso)" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Qual opção? (1/2/3)"

switch ($choice) {
  "1" {
    Write-Host ""
    Write-Host "📖 OPÇÃO 1: Desabilitar Proteção de Branch" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Abra: https://github.com/Lucaskayke814/proBPMS/settings/branches" -ForegroundColor Yellow
    Write-Host "2. Clique no ícone 🗑️ para deletar branch protection rules" -ForegroundColor Yellow
    Write-Host "3. Confirme a exclusão" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Depois execute:" -ForegroundColor Cyan
    Write-Host "  git push -u origin main" -ForegroundColor Magenta
    Write-Host ""
  }

  "2" {
    Write-Host ""
    Write-Host "📤 OPÇÃO 2: Push para Branch 'develop'" -ForegroundColor Cyan
    Write-Host ""
    
    # Verificar se já está em develop
    $currentBranch = git rev-parse --abbrev-ref HEAD
    
    if ($currentBranch -eq "develop") {
      Write-Host "✓ Já está em branch 'develop'" -ForegroundColor Green
    } else {
      Write-Host "[1/3] Criando/Mudando para branch 'develop'..." -ForegroundColor Yellow
      git checkout -b develop
      
      Write-Host "[2/3] Fazendo push..." -ForegroundColor Yellow
      git push -u origin develop
      
      Write-Host ""
      Write-Host "✓ Push concluído!" -ForegroundColor Green
      Write-Host ""
      Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
      Write-Host "  1. Abra: https://github.com/Lucaskayke814/proBPMS/compare/main...develop" -ForegroundColor Gray
      Write-Host "  2. Clique 'Create Pull Request'" -ForegroundColor Gray
      Write-Host "  3. Preencha a descrição" -ForegroundColor Gray
      Write-Host "  4. Clique 'Create Pull Request'" -ForegroundColor Gray
      Write-Host "  5. Clique 'Merge Pull Request'" -ForegroundColor Gray
      Write-Host ""
    }
  }

  "3" {
    Write-Host ""
    Write-Host "⚠️  OPÇÃO 3: Force Push" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "AVISO: Isso pode sobrescrever histórico!" -ForegroundColor Red
    Write-Host ""
    $confirm = Read-Host "Tem certeza? (s/n)"
    
    if ($confirm -eq "s") {
      Write-Host ""
      Write-Host "Executando: git push -u origin main --force" -ForegroundColor Magenta
      git push -u origin main --force
      Write-Host ""
      Write-Host "✓ Push concluído!" -ForegroundColor Green
    } else {
      Write-Host "❌ Cancelado" -ForegroundColor Red
    }
  }

  default {
    Write-Host "❌ Opção inválida" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "📚 Documentação: FIX_GITHUB_ERROR.md" -ForegroundColor Blue
Write-Host ""
