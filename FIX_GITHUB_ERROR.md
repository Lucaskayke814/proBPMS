# 🔧 Resolver Erro de Push no GitHub

## ❌ Erro Recebido
```
! [remote rejected] main -> main (push declined due to repository rule violations)
```

---

## ✅ SOLUÇÃO (Escolha uma)

### **OPÇÃO 1: Desabilitar Proteção de Branch** (Mais Rápido)

1. **Abra seu repo**: https://github.com/Lucaskayke814/proBPMS
2. **Clique em**: Settings > Branches
3. **Procure**: "Branch protection rules"
4. **Se houver**, clique no ícone de lixo 🗑️ para deletar
5. **Confirme**: Delete
6. **Depois tente novamente**:
   ```powershell
   git push -u origin main
   ```

---

### **OPÇÃO 2: Push para Nova Branch** (Seguro)

Se não quiser desabilitar proteção, crie uma nova branch:

```powershell
# Renomear branch local
git branch -M main develop

# Fazer push
git push -u origin develop

# Depois no GitHub:
# 1. Vá para Pull Requests
# 2. Clique "New Pull Request"
# 3. Selecione develop -> main
# 4. Clique "Create Pull Request"
# 5. Clique "Merge Pull Request"
```

---

### **OPÇÃO 3: Force Push** (Último Recurso)

⚠️ **Cuidado! Só use se souber o que está fazendo**

```powershell
git push -u origin main --force
```

---

## 🎯 RECOMENDAÇÃO

**Para repositório pessoal**: Use **OPÇÃO 1** (mais rápido)

**Para repositório em time**: Use **OPÇÃO 2** (mais seguro)

---

Qual quer tentar? 👇
