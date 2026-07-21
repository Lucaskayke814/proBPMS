# TESTES - Validacao da Base Corporativa

## 1. Validar banco

No Supabase > Table Editor, confirmar criacao de:
- [ ] Tabelas de dominio (`demand_type`, `demand_status`, `contract_status`, etc.)
- [ ] Cadastros principais (`contract`, `agency`, `system`, `contracted_service`, `demand`)
- [ ] Financeiro (`budget_allocation`, `commitment`, `liquidation`, `payment`, `financial_movement`)
- [ ] Suporte (`document`, `app_notification`, `audit_history`, `indicator_snapshot`)

No Supabase > SQL:
- [ ] View `vw_dashboard_executivo` criada
- [ ] Trigger de auditoria e trigger de recalc financeiro ativos

## 2. Validar autenticacao

- [ ] Criar usuario em Authentication > Users
- [ ] Login realizado com sucesso no app

## 3. Validar CRUD com exclusao logica

1. Contratos
- [ ] Incluir contrato
- [ ] Editar contrato
- [ ] Inativar contrato (campo `ativo = false`)

2. Orgaos
- [ ] Incluir orgao
- [ ] Editar orgao
- [ ] Inativar orgao

3. Sistemas
- [ ] Incluir sistema
- [ ] Editar sistema
- [ ] Inativar sistema

4. Servicos
- [ ] Incluir servico
- [ ] Editar servico
- [ ] Inativar servico

5. Demandas
- [ ] Incluir demanda
- [ ] Editar demanda
- [ ] Inativar demanda

## 4. Validar pesquisa, filtro, paginacao e ordenacao

- [ ] Contratos: pesquisa + filtro de status + ordenacao + paginacao
- [ ] Orgaos: pesquisa + ordenacao + paginacao
- [ ] Demandas: pesquisa + filtro de status + ordenacao + paginacao

## 5. Validar financeiro automatico

- [ ] Registrar movimentacao de consumo
- [ ] Confirmar atualizacao automatica de `contract.valor_executado` e `contract.saldo_atual`
- [ ] Registrar movimentacao de empenho/liquidacao/pagamento
- [ ] Confirmar atualizacao automatica dos totais no contrato

## 6. Validar historico

- [ ] Criar/editar/inativar registro
- [ ] Verificar linhas correspondentes em `audit_history`

## 7. Validar dashboard

- [ ] KPI de contratos
- [ ] KPI de saldo total
- [ ] KPI de demandas abertas
- [ ] Tabela executiva por contrato

Se todos os itens acima passarem, o incremento atual esta consistente para operacao inicial.
