-- ============================================================================
-- proBPMS - Base de dados corporativa para gestão contratual SEPLAG x PRODEMGE
-- Banco: PostgreSQL/Supabase
-- Objetivo: persistir TODO o ciclo administrativo, financeiro, operacional e técnico
-- ============================================================================

BEGIN;

-- --------------------------------------------------------------------------
-- EXTENSOES
-- --------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- --------------------------------------------------------------------------
-- TABELAS DE APOIO (DOMINIOS)
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS demand_type (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  descricao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  ordem SMALLINT NOT NULL,
  encerrado BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_priority (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(30) NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  peso SMALLINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_complexity (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(30) NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  fator NUMERIC(8,2) NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS contract_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS financial_movement_type (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(60) NOT NULL UNIQUE,
  nome VARCHAR(140) NOT NULL,
  bucket VARCHAR(30) NOT NULL CHECK (bucket IN ('dotacao', 'empenho', 'liquidacao', 'pagamento', 'consumo')),
  sinal SMALLINT NOT NULL CHECK (sinal IN (-1, 1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS document_type (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(60) NOT NULL UNIQUE,
  nome VARCHAR(140) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS notification_type (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(60) NOT NULL UNIQUE,
  nome VARCHAR(140) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS module_request_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  ordem SMALLINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS feature_request_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  ordem SMALLINT NOT NULL,
  encerrado BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS feature_category (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  descricao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS user_role (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(60) NOT NULL UNIQUE,
  nome VARCHAR(140) NOT NULL,
  descricao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------------------------
-- CADASTROS PRINCIPAIS
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS app_user (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE SET NULL,
  nome VARCHAR(200) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  telefone VARCHAR(30),
  cargo VARCHAR(120),
  tipo_usuario VARCHAR(60),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS app_user_role (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_user_id UUID NOT NULL REFERENCES app_user(id),
  role_id UUID NOT NULL REFERENCES user_role(id),
  agency_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_app_user_role UNIQUE (app_user_id, role_id, agency_id)
);

CREATE TABLE IF NOT EXISTS agency (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  sigla VARCHAR(30) NOT NULL,
  responsavel VARCHAR(200),
  gestor_setorial VARCHAR(200),
  fiscal VARCHAR(200),
  email VARCHAR(255),
  telefone VARCHAR(30),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_agency_sigla UNIQUE (sigla)
);

CREATE TABLE IF NOT EXISTS contract (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  is_corporate_contract BOOLEAN NOT NULL DEFAULT TRUE,
  numero VARCHAR(60) NOT NULL,
  ano SMALLINT NOT NULL,
  processo_administrativo VARCHAR(120) NOT NULL,
  objeto TEXT NOT NULL,
  fornecedor VARCHAR(255) NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  status_id UUID NOT NULL REFERENCES contract_status(id),
  gestor_id UUID REFERENCES app_user(id),
  fiscal_id UUID REFERENCES app_user(id),
  valor_total NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_executado NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_empenhado NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_liquidado NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_pago NUMERIC(18,2) NOT NULL DEFAULT 0,
  saldo_atual NUMERIC(18,2) NOT NULL DEFAULT 0,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT ck_contract_singleton_flag CHECK (is_corporate_contract = TRUE),
  CONSTRAINT uq_contract_singleton UNIQUE (is_corporate_contract),
  CONSTRAINT uq_contract_numero_ano UNIQUE (numero, ano),
  CONSTRAINT ck_contract_datas CHECK (data_fim >= data_inicio)
);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'contract'
      AND column_name = 'is_corporate_contract'
  ) THEN
    ALTER TABLE contract ADD COLUMN is_corporate_contract BOOLEAN NOT NULL DEFAULT TRUE;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_schema = 'public'
      AND table_name = 'contract'
      AND constraint_name = 'ck_contract_singleton_flag'
  ) THEN
    ALTER TABLE contract ADD CONSTRAINT ck_contract_singleton_flag CHECK (is_corporate_contract = TRUE);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_schema = 'public'
      AND table_name = 'contract'
      AND constraint_name = 'uq_contract_singleton'
  ) THEN
    ALTER TABLE contract ADD CONSTRAINT uq_contract_singleton UNIQUE (is_corporate_contract);
  END IF;
END;
$$;

CREATE TABLE IF NOT EXISTS contract_agency (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID NOT NULL REFERENCES agency(id),
  saldo_inicial NUMERIC(18,2) NOT NULL DEFAULT 0,
  saldo_consumido NUMERIC(18,2) NOT NULL DEFAULT 0,
  saldo_atual NUMERIC(18,2) NOT NULL DEFAULT 0,
  quantidade_demandas INTEGER NOT NULL DEFAULT 0,
  quantidade_publicacoes INTEGER NOT NULL DEFAULT 0,
  quantidade_funcionalidades INTEGER NOT NULL DEFAULT 0,
  quantidade_erros INTEGER NOT NULL DEFAULT 0,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_contract_agency UNIQUE (contract_id, agency_id)
);

CREATE TABLE IF NOT EXISTS contracted_service (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,
  categoria VARCHAR(120),
  situacao VARCHAR(80),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_contracted_service_nome UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS contract_service (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  service_id UUID NOT NULL REFERENCES contracted_service(id),
  valor_contratado NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_consumido NUMERIC(18,2) NOT NULL DEFAULT 0,
  saldo_atual NUMERIC(18,2) NOT NULL DEFAULT 0,
  situacao VARCHAR(80),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_contract_service UNIQUE (contract_id, service_id)
);

CREATE TABLE IF NOT EXISTS system (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(200) NOT NULL,
  sigla VARCHAR(40) NOT NULL,
  descricao TEXT,
  responsavel VARCHAR(200),
  agency_id UUID REFERENCES agency(id),
  situacao VARCHAR(80),
  documentacao_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_system_sigla UNIQUE (sigla)
);

CREATE TABLE IF NOT EXISTS system_module (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  system_id UUID NOT NULL REFERENCES system(id),
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,
  situacao VARCHAR(80),
  responsavel VARCHAR(200),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_system_module_nome UNIQUE (system_id, nome)
);

-- --------------------------------------------------------------------------
-- DEMANDAS E DETALHAMENTOS
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS demand (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  numero VARCHAR(80) NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT NOT NULL,
  demand_type_id UUID NOT NULL REFERENCES demand_type(id),
  categoria VARCHAR(120),
  system_id UUID REFERENCES system(id),
  module_id UUID REFERENCES system_module(id),
  agency_id UUID REFERENCES agency(id),
  solicitante VARCHAR(200),
  responsavel_id UUID REFERENCES app_user(id),
  prioridade_id UUID REFERENCES demand_priority(id),
  status_id UUID NOT NULL REFERENCES demand_status(id),
  complexidade_id UUID REFERENCES demand_complexity(id),
  data_abertura DATE NOT NULL DEFAULT CURRENT_DATE,
  prazo DATE,
  data_conclusao DATE,
  estimativa_horas NUMERIC(10,2) NOT NULL DEFAULT 0,
  horas_realizadas NUMERIC(10,2) NOT NULL DEFAULT 0,
  valor_previsto NUMERIC(18,2) NOT NULL DEFAULT 0,
  valor_executado NUMERIC(18,2) NOT NULL DEFAULT 0,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_demand_numero_contract UNIQUE (contract_id, numero)
);

CREATE TABLE IF NOT EXISTS demand_service (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  service_id UUID NOT NULL REFERENCES contracted_service(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_demand_service UNIQUE (demand_id, service_id)
);

CREATE TABLE IF NOT EXISTS demand_comment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  autor VARCHAR(200) NOT NULL,
  data_hora TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  texto TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_publication (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  system_id UUID REFERENCES system(id),
  versao VARCHAR(60),
  sprint VARCHAR(60),
  data_publicacao DATE NOT NULL,
  ambiente VARCHAR(50),
  responsavel VARCHAR(200),
  checklist TEXT,
  rollback TEXT,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_api (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  nome VARCHAR(200) NOT NULL,
  sistema_consumidor VARCHAR(200),
  sistema_provedor VARCHAR(200),
  endpoint TEXT,
  metodo VARCHAR(20),
  autenticacao VARCHAR(120),
  versao VARCHAR(60),
  documentacao_url TEXT,
  status VARCHAR(80),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_functionality (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  descricao TEXT NOT NULL,
  system_id UUID REFERENCES system(id),
  module_id UUID REFERENCES system_module(id),
  complexidade_id UUID REFERENCES demand_complexity(id),
  sprint VARCHAR(60),
  versao VARCHAR(60),
  status VARCHAR(80),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_error (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  criticidade VARCHAR(50) NOT NULL,
  ambiente VARCHAR(50),
  versao VARCHAR(60),
  passos_reproducao TEXT,
  resultado_esperado TEXT,
  resultado_obtido TEXT,
  correcao_aplicada TEXT,
  tempo_resolucao_horas NUMERIC(10,2),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS demand_homologation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  demand_id UUID NOT NULL REFERENCES demand(id),
  ambiente VARCHAR(50),
  data_homologacao DATE,
  responsavel VARCHAR(200),
  resultado VARCHAR(80),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS module_request (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID NOT NULL REFERENCES agency(id),
  system_id UUID REFERENCES system(id),
  nome_modulo VARCHAR(200) NOT NULL,
  sigla_modulo VARCHAR(40) NOT NULL,
  data_criacao_modulo DATE NOT NULL,
  processo_sei VARCHAR(120),
  data_solicitacao DATE NOT NULL,
  prazo_atendimento DATE,
  responsavel_id UUID REFERENCES app_user(id),
  status_id UUID NOT NULL REFERENCES module_request_status(id),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'module_request'
      AND column_name = 'sigla_modulo'
  ) THEN
    ALTER TABLE module_request ADD COLUMN sigla_modulo VARCHAR(40);
    UPDATE module_request SET sigla_modulo = SUBSTRING(REGEXP_REPLACE(nome_modulo, '[^A-Za-z0-9]', '', 'g') FROM 1 FOR 20) WHERE sigla_modulo IS NULL;
    ALTER TABLE module_request ALTER COLUMN sigla_modulo SET NOT NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'module_request'
      AND column_name = 'data_criacao_modulo'
  ) THEN
    ALTER TABLE module_request ADD COLUMN data_criacao_modulo DATE;
    UPDATE module_request SET data_criacao_modulo = COALESCE(data_solicitacao, CURRENT_DATE) WHERE data_criacao_modulo IS NULL;
    ALTER TABLE module_request ALTER COLUMN data_criacao_modulo SET NOT NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'module_request'
      AND column_name = 'prazo_atendimento'
  ) THEN
    ALTER TABLE module_request ADD COLUMN prazo_atendimento DATE;
  END IF;
END;
$$;

CREATE TABLE IF NOT EXISTS module_request_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_request_id UUID NOT NULL REFERENCES module_request(id),
  status_anterior_id UUID REFERENCES module_request_status(id),
  status_novo_id UUID REFERENCES module_request_status(id),
  observacoes TEXT,
  data_hora TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS feature_request (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID NOT NULL REFERENCES agency(id),
  system_id UUID REFERENCES system(id),
  module_id UUID REFERENCES system_module(id),
  demand_id UUID REFERENCES demand(id),
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT NOT NULL,
  processo_sei VARCHAR(120),
  prioridade_id UUID REFERENCES demand_priority(id),
  categoria_id UUID REFERENCES feature_category(id),
  responsavel_id UUID REFERENCES app_user(id),
  sprint VARCHAR(60),
  status_id UUID NOT NULL REFERENCES feature_request_status(id),
  estimativa_horas NUMERIC(10,2) NOT NULL DEFAULT 0,
  data_solicitacao DATE NOT NULL,
  data_entrega DATE,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS feature_request_comment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  feature_request_id UUID NOT NULL REFERENCES feature_request(id),
  autor VARCHAR(200) NOT NULL,
  texto TEXT NOT NULL,
  data_hora TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS timeline_event (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID REFERENCES contract(id),
  agency_id UUID REFERENCES agency(id),
  categoria VARCHAR(80) NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT,
  referencia_tabela VARCHAR(120),
  referencia_id UUID,
  data_evento TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS report_export (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo_relatorio VARCHAR(80) NOT NULL,
  formato VARCHAR(20) NOT NULL CHECK (formato IN ('PDF', 'XLSX')),
  filtros JSONB,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
  arquivo_url TEXT,
  solicitado_em TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  concluido_em TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS notification_rule (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(80) NOT NULL UNIQUE,
  nome VARCHAR(140) NOT NULL,
  percentual_limite NUMERIC(5,2),
  dias_antecedencia INTEGER,
  ativo_regra BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------------------------
-- FINANCEIRO
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS budget_allocation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID REFERENCES agency(id),
  exercicio SMALLINT NOT NULL,
  numero_dotacao VARCHAR(100) NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  data_movimento DATE NOT NULL,
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_budget_allocation UNIQUE (contract_id, numero_dotacao)
);

CREATE TABLE IF NOT EXISTS commitment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID REFERENCES agency(id),
  numero_empenho VARCHAR(100) NOT NULL,
  data_empenho DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_commitment UNIQUE (contract_id, numero_empenho)
);

CREATE TABLE IF NOT EXISTS commitment_adjustment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  commitment_id UUID NOT NULL REFERENCES commitment(id),
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('REFORCO', 'ANULACAO')),
  data_movimento DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS invoice (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID REFERENCES agency(id),
  numero_nota VARCHAR(120) NOT NULL,
  emissao DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  descricao TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_invoice UNIQUE (contract_id, numero_nota)
);

CREATE TABLE IF NOT EXISTS liquidation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  commitment_id UUID REFERENCES commitment(id),
  invoice_id UUID REFERENCES invoice(id),
  numero_liquidacao VARCHAR(120) NOT NULL,
  data_liquidacao DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_liquidation UNIQUE (contract_id, numero_liquidacao)
);

CREATE TABLE IF NOT EXISTS payment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  liquidation_id UUID REFERENCES liquidation(id),
  numero_pagamento VARCHAR(120) NOT NULL,
  data_pagamento DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_payment UNIQUE (contract_id, numero_pagamento)
);

CREATE TABLE IF NOT EXISTS financial_movement (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID NOT NULL REFERENCES contract(id),
  agency_id UUID REFERENCES agency(id),
  service_id UUID REFERENCES contracted_service(id),
  demand_id UUID REFERENCES demand(id),
  movement_type_id UUID NOT NULL REFERENCES financial_movement_type(id),
  budget_allocation_id UUID REFERENCES budget_allocation(id),
  commitment_id UUID REFERENCES commitment(id),
  liquidation_id UUID REFERENCES liquidation(id),
  payment_id UUID REFERENCES payment(id),
  invoice_id UUID REFERENCES invoice(id),
  data_movimento DATE NOT NULL,
  valor NUMERIC(18,2) NOT NULL CHECK (valor >= 0),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------------------------
-- DOCUMENTOS, NOTIFICACOES, HISTORICO, INDICADORES
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS document (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_type_id UUID REFERENCES document_type(id),
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  data_documento DATE NOT NULL,
  usuario_nome VARCHAR(200),
  arquivo_url TEXT NOT NULL,
  contract_id UUID REFERENCES contract(id),
  demand_id UUID REFERENCES demand(id),
  system_id UUID REFERENCES system(id),
  publication_id UUID REFERENCES demand_publication(id),
  commitment_id UUID REFERENCES commitment(id),
  invoice_id UUID REFERENCES invoice(id),
  agency_id UUID REFERENCES agency(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS app_notification (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  notification_type_id UUID REFERENCES notification_type(id),
  titulo VARCHAR(255) NOT NULL,
  mensagem TEXT NOT NULL,
  referencia_tabela VARCHAR(120),
  referencia_id UUID,
  lida BOOLEAN NOT NULL DEFAULT FALSE,
  data_hora TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS audit_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID REFERENCES auth.users(id),
  data_hora TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  tabela VARCHAR(120) NOT NULL,
  registro_id UUID,
  acao VARCHAR(30) NOT NULL,
  campo_alterado VARCHAR(120),
  valor_anterior TEXT,
  valor_novo TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS indicator_snapshot (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id UUID REFERENCES contract(id),
  referencia_data DATE NOT NULL,
  chave VARCHAR(120) NOT NULL,
  valor NUMERIC(18,2) NOT NULL,
  dimensao1 VARCHAR(120),
  dimensao2 VARCHAR(120),
  observacoes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------------------------
-- FUNCOES DE AUDITORIA PADRAO
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_set_audit_fields()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at = COALESCE(NEW.created_at, TIMEZONE('utc', NOW()));
    NEW.updated_at = COALESCE(NEW.updated_at, TIMEZONE('utc', NOW()));
    IF NEW.created_by IS NULL THEN
      NEW.created_by = auth.uid();
    END IF;
    NEW.updated_by = NEW.created_by;
    NEW.ativo = COALESCE(NEW.ativo, TRUE);
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.updated_at = TIMEZONE('utc', NOW());
    NEW.updated_by = auth.uid();
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_write_audit_history()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  k TEXT;
  old_val TEXT;
  new_val TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_history (usuario_id, tabela, registro_id, acao, campo_alterado, valor_anterior, valor_novo)
    VALUES (auth.uid(), TG_TABLE_NAME, NEW.id, 'INSERT', NULL, NULL, row_to_json(NEW)::TEXT);
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_history (usuario_id, tabela, registro_id, acao, campo_alterado, valor_anterior, valor_novo)
    VALUES (auth.uid(), TG_TABLE_NAME, OLD.id, 'DELETE', NULL, row_to_json(OLD)::TEXT, NULL);
    RETURN OLD;
  ELSE
    FOR k IN SELECT key FROM jsonb_each(to_jsonb(NEW))
    LOOP
      IF k IN ('updated_at', 'updated_by') THEN
        CONTINUE;
      END IF;

      old_val := to_jsonb(OLD)->>k;
      new_val := to_jsonb(NEW)->>k;

      IF old_val IS DISTINCT FROM new_val THEN
        INSERT INTO audit_history (usuario_id, tabela, registro_id, acao, campo_alterado, valor_anterior, valor_novo)
        VALUES (auth.uid(), TG_TABLE_NAME, NEW.id, 'UPDATE', k, old_val, new_val);
      END IF;
    END LOOP;

    RETURN NEW;
  END IF;
END;
$$;

-- --------------------------------------------------------------------------
-- FUNCOES FINANCEIRAS
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_recalculate_contract_balances(p_contract_id UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_empenhado NUMERIC(18,2);
  v_liquidado NUMERIC(18,2);
  v_pago NUMERIC(18,2);
  v_consumo NUMERIC(18,2);
BEGIN
  SELECT COALESCE(SUM(fm.valor * fmt.sinal), 0)
    INTO v_empenhado
  FROM financial_movement fm
  JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
  WHERE fm.contract_id = p_contract_id
    AND fm.ativo = TRUE
    AND fmt.bucket = 'empenho';

  SELECT COALESCE(SUM(fm.valor * fmt.sinal), 0)
    INTO v_liquidado
  FROM financial_movement fm
  JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
  WHERE fm.contract_id = p_contract_id
    AND fm.ativo = TRUE
    AND fmt.bucket = 'liquidacao';

  SELECT COALESCE(SUM(fm.valor * fmt.sinal), 0)
    INTO v_pago
  FROM financial_movement fm
  JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
  WHERE fm.contract_id = p_contract_id
    AND fm.ativo = TRUE
    AND fmt.bucket = 'pagamento';

  SELECT COALESCE(SUM(fm.valor * fmt.sinal), 0)
    INTO v_consumo
  FROM financial_movement fm
  JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
  WHERE fm.contract_id = p_contract_id
    AND fm.ativo = TRUE
    AND fmt.bucket = 'consumo';

  UPDATE contract c
     SET valor_empenhado = v_empenhado,
         valor_liquidado = v_liquidado,
         valor_pago = v_pago,
         valor_executado = v_consumo,
         saldo_atual = c.valor_total - v_consumo
   WHERE c.id = p_contract_id;
END;
$$;

CREATE OR REPLACE FUNCTION fn_recalculate_agency_balances(p_contract_id UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE contract_agency ca
     SET saldo_consumido = COALESCE(agg.total_consumido, 0),
         saldo_atual = ca.saldo_inicial - COALESCE(agg.total_consumido, 0)
  FROM (
      SELECT fm.agency_id, COALESCE(SUM(fm.valor * fmt.sinal), 0) AS total_consumido
      FROM financial_movement fm
      JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
      WHERE fm.contract_id = p_contract_id
        AND fm.ativo = TRUE
        AND fm.agency_id IS NOT NULL
        AND fmt.bucket = 'consumo'
      GROUP BY fm.agency_id
  ) agg
  WHERE ca.contract_id = p_contract_id
    AND ca.agency_id = agg.agency_id;

  UPDATE contract_agency ca
     SET saldo_consumido = 0,
         saldo_atual = saldo_inicial
   WHERE ca.contract_id = p_contract_id
     AND NOT EXISTS (
        SELECT 1
        FROM financial_movement fm
        JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
        WHERE fm.contract_id = p_contract_id
          AND fm.ativo = TRUE
          AND fmt.bucket = 'consumo'
          AND fm.agency_id = ca.agency_id
     );
END;
$$;

CREATE OR REPLACE FUNCTION fn_recalculate_service_balances(p_contract_id UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE contract_service cs
     SET valor_consumido = COALESCE(agg.total_consumido, 0),
         saldo_atual = cs.valor_contratado - COALESCE(agg.total_consumido, 0)
  FROM (
      SELECT fm.service_id, COALESCE(SUM(fm.valor * fmt.sinal), 0) AS total_consumido
      FROM financial_movement fm
      JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
      WHERE fm.contract_id = p_contract_id
        AND fm.ativo = TRUE
        AND fm.service_id IS NOT NULL
        AND fmt.bucket = 'consumo'
      GROUP BY fm.service_id
  ) agg
  WHERE cs.contract_id = p_contract_id
    AND cs.service_id = agg.service_id;

  UPDATE contract_service cs
     SET valor_consumido = 0,
         saldo_atual = valor_contratado
   WHERE cs.contract_id = p_contract_id
     AND NOT EXISTS (
       SELECT 1
       FROM financial_movement fm
       JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
       WHERE fm.contract_id = p_contract_id
         AND fm.ativo = TRUE
         AND fmt.bucket = 'consumo'
         AND fm.service_id = cs.service_id
     );
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_financial_movement()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_contract_id UUID;
BEGIN
  v_contract_id := COALESCE(NEW.contract_id, OLD.contract_id);
  PERFORM fn_recalculate_contract_balances(v_contract_id);
  PERFORM fn_recalculate_agency_balances(v_contract_id);
  PERFORM fn_recalculate_service_balances(v_contract_id);
  RETURN COALESCE(NEW, OLD);
END;
$$;

-- --------------------------------------------------------------------------
-- FUNCOES DE EVENTOS E NOTIFICACOES
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_emit_notification(p_codigo VARCHAR, p_titulo VARCHAR, p_mensagem TEXT, p_tabela VARCHAR, p_registro UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_type_id UUID;
BEGIN
  SELECT id INTO v_type_id FROM notification_type WHERE codigo = p_codigo LIMIT 1;

  INSERT INTO app_notification (notification_type_id, titulo, mensagem, referencia_tabela, referencia_id)
  VALUES (v_type_id, p_titulo, p_mensagem, p_tabela, p_registro);
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_demand_notifications()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_status_nome TEXT;
  v_critical_count INTEGER;
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM fn_emit_notification(
      'NOVA_DEMANDA',
      'Nova demanda registrada',
      'Demanda ' || NEW.numero || ' foi cadastrada.',
      'demand',
      NEW.id
    );
  END IF;

  IF TG_OP = 'UPDATE' AND NEW.status_id IS DISTINCT FROM OLD.status_id THEN
    SELECT nome INTO v_status_nome FROM demand_status WHERE id = NEW.status_id;
    PERFORM fn_emit_notification(
      'MUDANCA_STATUS',
      'Mudanca de status da demanda',
      'Demanda ' || NEW.numero || ' alterada para status: ' || COALESCE(v_status_nome, 'N/A') || '.',
      'demand',
      NEW.id
    );
  END IF;

  IF NEW.prazo IS NOT NULL AND NEW.prazo < CURRENT_DATE AND NEW.data_conclusao IS NULL THEN
    PERFORM fn_emit_notification(
      'PRAZO_VENCIDO',
      'Prazo vencido',
      'Demanda ' || NEW.numero || ' esta com prazo vencido.',
      'demand',
      NEW.id
    );
  END IF;

  SELECT COUNT(*) INTO v_critical_count
  FROM demand_error de
  WHERE de.demand_id = NEW.id
    AND de.ativo = TRUE
    AND UPPER(COALESCE(de.criticidade, '')) = 'CRITICA';

  IF v_critical_count > 0 THEN
    PERFORM fn_emit_notification(
      'ERRO_CRITICO',
      'Erro critico registrado',
      'Demanda ' || NEW.numero || ' possui erro critico associado.',
      'demand',
      NEW.id
    );
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_publication_notifications()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM fn_emit_notification(
    'PUBLICACAO',
    'Nova publicacao',
    'Publicacao vinculada a demanda registrada em ' || TO_CHAR(NEW.data_publicacao, 'DD/MM/YYYY') || '.',
    'demand_publication',
    NEW.id
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_api_notifications()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM fn_emit_notification(
    'NOVA_API',
    'Nova API registrada',
    'API ' || NEW.nome || ' foi registrada para a demanda.',
    'demand_api',
    NEW.id
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_document_notifications()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM fn_emit_notification(
    'NOVO_DOCUMENTO',
    'Novo documento anexado',
    'Documento ' || NEW.nome || ' foi anexado.',
    'document',
    NEW.id
  );
  RETURN NEW;
END;
$$;

-- --------------------------------------------------------------------------
-- FUNCOES DE AUTORIZACAO
-- --------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_user_is_active()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM app_user u
    WHERE u.auth_user_id = auth.uid()
      AND u.ativo = TRUE
  );
$$;

CREATE OR REPLACE FUNCTION fn_user_is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM app_user u
    WHERE u.auth_user_id = auth.uid()
      AND u.ativo = TRUE
      AND UPPER(COALESCE(u.tipo_usuario, '')) IN ('ADMIN', 'ADMINISTRADOR')
  );
$$;

CREATE OR REPLACE FUNCTION fn_has_role(p_role_code VARCHAR)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM app_user u
    JOIN app_user_role aur ON aur.app_user_id = u.id AND aur.ativo = TRUE
    JOIN user_role r ON r.id = aur.role_id AND r.ativo = TRUE
    WHERE u.auth_user_id = auth.uid()
      AND u.ativo = TRUE
      AND r.codigo = p_role_code
  );
$$;

CREATE OR REPLACE FUNCTION fn_bind_current_user()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email TEXT;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN FALSE;
  END IF;

  v_email := lower((auth.jwt() ->> 'email'));
  IF v_email IS NULL OR v_email = '' THEN
    RETURN FALSE;
  END IF;

  UPDATE app_user
     SET auth_user_id = auth.uid(),
         updated_at = TIMEZONE('utc', NOW()),
         updated_by = auth.uid()
   WHERE auth_user_id IS NULL
     AND ativo = TRUE
     AND lower(email) = v_email;

  RETURN EXISTS (
    SELECT 1
    FROM app_user u
    WHERE u.auth_user_id = auth.uid()
      AND u.ativo = TRUE
  );
END;
$$;

CREATE OR REPLACE FUNCTION fn_append_timeline_event(
  p_contract_id UUID,
  p_agency_id UUID,
  p_categoria VARCHAR,
  p_titulo VARCHAR,
  p_descricao TEXT,
  p_referencia_tabela VARCHAR,
  p_referencia_id UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO timeline_event (
    contract_id,
    agency_id,
    categoria,
    titulo,
    descricao,
    referencia_tabela,
    referencia_id
  ) VALUES (
    p_contract_id,
    p_agency_id,
    p_categoria,
    p_titulo,
    p_descricao,
    p_referencia_tabela,
    p_referencia_id
  );
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_module_request_timeline()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_status_nome TEXT;
BEGIN
  SELECT nome INTO v_status_nome FROM module_request_status WHERE id = NEW.status_id;

  PERFORM fn_append_timeline_event(
    NEW.contract_id,
    NEW.agency_id,
    'MODULO',
    'Solicitacao de modulo: ' || NEW.nome_modulo,
    'Status atual: ' || COALESCE(v_status_nome, 'N/A'),
    'module_request',
    NEW.id
  );

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_after_feature_request_timeline()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_status_nome TEXT;
BEGIN
  SELECT nome INTO v_status_nome FROM feature_request_status WHERE id = NEW.status_id;

  PERFORM fn_append_timeline_event(
    NEW.contract_id,
    NEW.agency_id,
    'FUNCIONALIDADE',
    'Solicitacao de funcionalidade: ' || NEW.titulo,
    'Status atual: ' || COALESCE(v_status_nome, 'N/A'),
    'feature_request',
    NEW.id
  );

  RETURN NEW;
END;
$$;

-- --------------------------------------------------------------------------
-- TRIGGERS: AUDITORIA PADRAO
-- --------------------------------------------------------------------------
DO $$
DECLARE
  t RECORD;
BEGIN
  FOR t IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      AND table_name IN (
        'demand_type', 'demand_status', 'demand_priority', 'demand_complexity',
        'contract_status', 'financial_movement_type', 'document_type', 'notification_type',
        'module_request_status', 'feature_request_status', 'feature_category', 'user_role',
        'app_user', 'agency', 'contract', 'contract_agency', 'contracted_service',
        'app_user_role',
        'contract_service', 'system', 'system_module', 'demand', 'demand_service',
        'demand_comment', 'demand_publication', 'demand_api', 'demand_functionality',
        'demand_error', 'demand_homologation', 'budget_allocation', 'commitment',
        'commitment_adjustment', 'invoice', 'liquidation', 'payment', 'financial_movement',
        'module_request', 'module_request_history', 'feature_request', 'feature_request_comment',
        'timeline_event', 'report_export', 'notification_rule',
        'document', 'app_notification', 'audit_history', 'indicator_snapshot'
      )
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS trg_set_audit_fields_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('CREATE TRIGGER trg_set_audit_fields_%I BEFORE INSERT OR UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION fn_set_audit_fields()', t.table_name, t.table_name);
  END LOOP;
END;
$$;

DO $$
DECLARE
  t RECORD;
BEGIN
  FOR t IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      AND table_name IN (
        'demand_type', 'demand_status', 'demand_priority', 'demand_complexity',
        'contract_status', 'financial_movement_type', 'document_type', 'notification_type',
        'module_request_status', 'feature_request_status', 'feature_category', 'user_role',
        'app_user', 'agency', 'contract', 'contract_agency', 'contracted_service',
        'app_user_role',
        'contract_service', 'system', 'system_module', 'demand', 'demand_service',
        'demand_comment', 'demand_publication', 'demand_api', 'demand_functionality',
        'demand_error', 'demand_homologation', 'budget_allocation', 'commitment',
        'commitment_adjustment', 'invoice', 'liquidation', 'payment', 'financial_movement',
        'module_request', 'module_request_history', 'feature_request', 'feature_request_comment',
        'timeline_event', 'report_export', 'notification_rule',
        'document', 'app_notification', 'indicator_snapshot'
      )
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS trg_audit_history_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('CREATE TRIGGER trg_audit_history_%I AFTER INSERT OR UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION fn_write_audit_history()', t.table_name, t.table_name);
  END LOOP;
END;
$$;

DROP TRIGGER IF EXISTS trg_financial_recalc ON financial_movement;
CREATE TRIGGER trg_financial_recalc
AFTER INSERT OR UPDATE OR DELETE ON financial_movement
FOR EACH ROW
EXECUTE FUNCTION fn_after_financial_movement();

DROP TRIGGER IF EXISTS trg_demand_notifications ON demand;
CREATE TRIGGER trg_demand_notifications
AFTER INSERT OR UPDATE ON demand
FOR EACH ROW
EXECUTE FUNCTION fn_after_demand_notifications();

DROP TRIGGER IF EXISTS trg_publication_notifications ON demand_publication;
CREATE TRIGGER trg_publication_notifications
AFTER INSERT ON demand_publication
FOR EACH ROW
EXECUTE FUNCTION fn_after_publication_notifications();

DROP TRIGGER IF EXISTS trg_api_notifications ON demand_api;
CREATE TRIGGER trg_api_notifications
AFTER INSERT ON demand_api
FOR EACH ROW
EXECUTE FUNCTION fn_after_api_notifications();

DROP TRIGGER IF EXISTS trg_document_notifications ON document;
CREATE TRIGGER trg_document_notifications
AFTER INSERT ON document
FOR EACH ROW
EXECUTE FUNCTION fn_after_document_notifications();

DROP TRIGGER IF EXISTS trg_module_request_timeline ON module_request;
CREATE TRIGGER trg_module_request_timeline
AFTER INSERT OR UPDATE ON module_request
FOR EACH ROW
EXECUTE FUNCTION fn_after_module_request_timeline();

DROP TRIGGER IF EXISTS trg_feature_request_timeline ON feature_request;
CREATE TRIGGER trg_feature_request_timeline
AFTER INSERT OR UPDATE ON feature_request
FOR EACH ROW
EXECUTE FUNCTION fn_after_feature_request_timeline();

-- --------------------------------------------------------------------------
-- RLS (CONFIGURACAO SEGURA)
-- 1) Tabelas de dominio: leitura para usuario ativo, escrita apenas admin
-- 2) Tabelas de negocio: admin ve tudo; demais usuarios veem apenas criados por eles
-- 3) DELETE fisico bloqueado no cliente (usar exclusao logica via ativo=false)
-- --------------------------------------------------------------------------

DO $$
DECLARE
  t RECORD;
BEGIN
  -- Tabelas de dominio (somente leitura para usuarios autenticados)
  FOR t IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      AND table_name IN (
        'demand_type', 'demand_status', 'demand_priority', 'demand_complexity',
        'contract_status', 'financial_movement_type', 'document_type', 'notification_type',
        'module_request_status', 'feature_request_status', 'feature_category', 'user_role'
      )
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t.table_name);

    EXECUTE format('DROP POLICY IF EXISTS p_select_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_insert_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_update_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_delete_%I ON %I', t.table_name, t.table_name);

    EXECUTE format('CREATE POLICY p_select_%I ON %I FOR SELECT USING (fn_user_is_active())', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_insert_%I ON %I FOR INSERT WITH CHECK (fn_user_is_admin())', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_update_%I ON %I FOR UPDATE USING (fn_user_is_admin()) WITH CHECK (fn_user_is_admin())', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_delete_%I ON %I FOR DELETE USING (FALSE)', t.table_name, t.table_name);
  END LOOP;

  -- Tabelas de negocio (isolamento por usuario criador)
  FOR t IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      AND table_name IN (
        'app_user', 'agency', 'contract', 'contract_agency', 'contracted_service',
        'app_user_role',
        'contract_service', 'system', 'system_module', 'demand', 'demand_service',
        'demand_comment', 'demand_publication', 'demand_api', 'demand_functionality',
        'demand_error', 'demand_homologation', 'budget_allocation', 'commitment',
        'commitment_adjustment', 'invoice', 'liquidation', 'payment', 'financial_movement',
        'module_request', 'module_request_history', 'feature_request', 'feature_request_comment',
        'timeline_event', 'report_export', 'notification_rule',
        'document', 'app_notification', 'audit_history', 'indicator_snapshot'
      )
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t.table_name);

    EXECUTE format('DROP POLICY IF EXISTS p_select_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_insert_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_update_%I ON %I', t.table_name, t.table_name);
    EXECUTE format('DROP POLICY IF EXISTS p_delete_%I ON %I', t.table_name, t.table_name);

    EXECUTE format('CREATE POLICY p_select_%I ON %I FOR SELECT USING (fn_user_is_active() AND (fn_user_is_admin() OR created_by = auth.uid()))', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_insert_%I ON %I FOR INSERT WITH CHECK (fn_user_is_active() AND COALESCE(created_by, auth.uid()) = auth.uid())', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_update_%I ON %I FOR UPDATE USING (fn_user_is_active() AND (fn_user_is_admin() OR created_by = auth.uid())) WITH CHECK (fn_user_is_active() AND (fn_user_is_admin() OR created_by = auth.uid()))', t.table_name, t.table_name);
    EXECUTE format('CREATE POLICY p_delete_%I ON %I FOR DELETE USING (FALSE)', t.table_name, t.table_name);
  END LOOP;
END;
$$;

-- Cadastros compartilhados do contrato corporativo: leitura para qualquer usuario ativo.
DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['contract', 'agency', 'contracted_service', 'system', 'system_module', 'contract_agency', 'contract_service']
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS p_select_%I ON %I', t, t);
    EXECUTE format('CREATE POLICY p_select_%I ON %I FOR SELECT USING (fn_user_is_active())', t, t);

    EXECUTE format('DROP POLICY IF EXISTS p_insert_%I ON %I', t, t);
    EXECUTE format('CREATE POLICY p_insert_%I ON %I FOR INSERT WITH CHECK (fn_user_is_admin())', t, t);

    EXECUTE format('DROP POLICY IF EXISTS p_update_%I ON %I', t, t);
    EXECUTE format('CREATE POLICY p_update_%I ON %I FOR UPDATE USING (fn_user_is_admin()) WITH CHECK (fn_user_is_admin())', t, t);
  END LOOP;
END;
$$;

ALTER TABLE app_user ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS p_select_app_user ON app_user;
DROP POLICY IF EXISTS p_insert_app_user ON app_user;
DROP POLICY IF EXISTS p_update_app_user ON app_user;
DROP POLICY IF EXISTS p_delete_app_user ON app_user;

CREATE POLICY p_select_app_user ON app_user
  FOR SELECT
  USING (
    fn_user_is_active() AND (
      fn_user_is_admin()
      OR auth_user_id = auth.uid()
      OR created_by = auth.uid()
    )
  );

CREATE POLICY p_insert_app_user ON app_user
  FOR INSERT
  WITH CHECK (fn_user_is_admin());

CREATE POLICY p_update_app_user ON app_user
  FOR UPDATE
  USING (fn_user_is_admin() OR auth_user_id = auth.uid())
  WITH CHECK (fn_user_is_admin() OR auth_user_id = auth.uid());

CREATE POLICY p_delete_app_user ON app_user
  FOR DELETE
  USING (FALSE);

-- --------------------------------------------------------------------------
-- INDICES
-- --------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_contract_status_id ON contract(status_id);
CREATE INDEX IF NOT EXISTS idx_contract_gestor_id ON contract(gestor_id);
CREATE INDEX IF NOT EXISTS idx_contract_fiscal_id ON contract(fiscal_id);
CREATE INDEX IF NOT EXISTS idx_contract_ativo ON contract(ativo);
CREATE INDEX IF NOT EXISTS idx_contract_datas ON contract(data_inicio, data_fim);

CREATE INDEX IF NOT EXISTS idx_contract_agency_contract_id ON contract_agency(contract_id);
CREATE INDEX IF NOT EXISTS idx_contract_agency_agency_id ON contract_agency(agency_id);

CREATE INDEX IF NOT EXISTS idx_contract_service_contract_id ON contract_service(contract_id);
CREATE INDEX IF NOT EXISTS idx_contract_service_service_id ON contract_service(service_id);

CREATE INDEX IF NOT EXISTS idx_system_agency_id ON system(agency_id);
CREATE INDEX IF NOT EXISTS idx_system_module_system_id ON system_module(system_id);

CREATE INDEX IF NOT EXISTS idx_demand_contract_id ON demand(contract_id);
CREATE INDEX IF NOT EXISTS idx_demand_status_id ON demand(status_id);
CREATE INDEX IF NOT EXISTS idx_demand_type_id ON demand(demand_type_id);
CREATE INDEX IF NOT EXISTS idx_demand_system_id ON demand(system_id);
CREATE INDEX IF NOT EXISTS idx_demand_module_id ON demand(module_id);
CREATE INDEX IF NOT EXISTS idx_demand_agency_id ON demand(agency_id);
CREATE INDEX IF NOT EXISTS idx_demand_responsavel_id ON demand(responsavel_id);
CREATE INDEX IF NOT EXISTS idx_demand_prazo ON demand(prazo);
CREATE INDEX IF NOT EXISTS idx_demand_data_abertura ON demand(data_abertura);
CREATE INDEX IF NOT EXISTS idx_demand_ativo ON demand(ativo);

CREATE INDEX IF NOT EXISTS idx_demand_publication_demand_id ON demand_publication(demand_id);
CREATE INDEX IF NOT EXISTS idx_demand_api_demand_id ON demand_api(demand_id);
CREATE INDEX IF NOT EXISTS idx_demand_functionality_demand_id ON demand_functionality(demand_id);
CREATE INDEX IF NOT EXISTS idx_demand_error_demand_id ON demand_error(demand_id);
CREATE INDEX IF NOT EXISTS idx_demand_comment_demand_id ON demand_comment(demand_id);

CREATE INDEX IF NOT EXISTS idx_budget_allocation_contract_id ON budget_allocation(contract_id);
CREATE INDEX IF NOT EXISTS idx_commitment_contract_id ON commitment(contract_id);
CREATE INDEX IF NOT EXISTS idx_invoice_contract_id ON invoice(contract_id);
CREATE INDEX IF NOT EXISTS idx_liquidation_contract_id ON liquidation(contract_id);
CREATE INDEX IF NOT EXISTS idx_payment_contract_id ON payment(contract_id);

CREATE INDEX IF NOT EXISTS idx_financial_movement_contract_id ON financial_movement(contract_id);
CREATE INDEX IF NOT EXISTS idx_financial_movement_agency_id ON financial_movement(agency_id);
CREATE INDEX IF NOT EXISTS idx_financial_movement_service_id ON financial_movement(service_id);
CREATE INDEX IF NOT EXISTS idx_financial_movement_type_id ON financial_movement(movement_type_id);
CREATE INDEX IF NOT EXISTS idx_financial_movement_data ON financial_movement(data_movimento);
CREATE INDEX IF NOT EXISTS idx_financial_movement_ativo ON financial_movement(ativo);

CREATE INDEX IF NOT EXISTS idx_document_contract_id ON document(contract_id);
CREATE INDEX IF NOT EXISTS idx_document_demand_id ON document(demand_id);
CREATE INDEX IF NOT EXISTS idx_document_system_id ON document(system_id);
CREATE INDEX IF NOT EXISTS idx_document_agency_id ON document(agency_id);

CREATE INDEX IF NOT EXISTS idx_audit_history_tabela_registro ON audit_history(tabela, registro_id);
CREATE INDEX IF NOT EXISTS idx_audit_history_data_hora ON audit_history(data_hora DESC);
CREATE INDEX IF NOT EXISTS idx_notification_data_hora ON app_notification(data_hora DESC);
CREATE INDEX IF NOT EXISTS idx_app_user_role_user ON app_user_role(app_user_id);
CREATE INDEX IF NOT EXISTS idx_app_user_role_role ON app_user_role(role_id);
CREATE INDEX IF NOT EXISTS idx_module_request_contract_id ON module_request(contract_id);
CREATE INDEX IF NOT EXISTS idx_module_request_agency_id ON module_request(agency_id);
CREATE INDEX IF NOT EXISTS idx_module_request_status_id ON module_request(status_id);
CREATE INDEX IF NOT EXISTS idx_feature_request_contract_id ON feature_request(contract_id);
CREATE INDEX IF NOT EXISTS idx_feature_request_agency_id ON feature_request(agency_id);
CREATE INDEX IF NOT EXISTS idx_feature_request_status_id ON feature_request(status_id);
CREATE INDEX IF NOT EXISTS idx_feature_request_priority_id ON feature_request(prioridade_id);
CREATE INDEX IF NOT EXISTS idx_feature_request_category_id ON feature_request(categoria_id);
CREATE INDEX IF NOT EXISTS idx_timeline_event_contract_id ON timeline_event(contract_id);
CREATE INDEX IF NOT EXISTS idx_timeline_event_data_evento ON timeline_event(data_evento DESC);

-- --------------------------------------------------------------------------
-- DADOS INICIAIS DOS DOMINIOS
-- --------------------------------------------------------------------------
INSERT INTO demand_type (codigo, nome, descricao)
VALUES
  ('NOVA_FUNCIONALIDADE', 'Nova funcionalidade', NULL),
  ('CORRECAO', 'Correcao', NULL),
  ('ERRO', 'Erro', NULL),
  ('API', 'API', NULL),
  ('INTEGRACAO', 'Integracao', NULL),
  ('PUBLICACAO', 'Publicacao', NULL),
  ('NOVO_MODULO', 'Novo modulo', NULL),
  ('MELHORIA', 'Melhoria', NULL),
  ('SUSTENTACAO', 'Sustentacao', NULL),
  ('INFRAESTRUTURA', 'Infraestrutura', NULL),
  ('HOMOLOGACAO', 'Homologacao', NULL),
  ('PESQUISA', 'Pesquisa', NULL),
  ('OUTRO', 'Outro', NULL)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO demand_status (codigo, nome, ordem, encerrado)
VALUES
  ('NOVA', 'Nova', 1, FALSE),
  ('EM_ANALISE', 'Em analise', 2, FALSE),
  ('AGUARDANDO_INFORMACOES', 'Aguardando informacoes', 3, FALSE),
  ('PLANEJAMENTO', 'Planejamento', 4, FALSE),
  ('DESENVOLVIMENTO', 'Desenvolvimento', 5, FALSE),
  ('TESTES', 'Testes', 6, FALSE),
  ('HOMOLOGACAO', 'Homologacao', 7, FALSE),
  ('PRONTA_PUBLICACAO', 'Pronta para publicacao', 8, FALSE),
  ('PUBLICADA', 'Publicada', 9, FALSE),
  ('CONCLUIDA', 'Concluida', 10, TRUE),
  ('CANCELADA', 'Cancelada', 11, TRUE),
  ('REJEITADA', 'Rejeitada', 12, TRUE)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO demand_priority (codigo, nome, peso)
VALUES
  ('BAIXA', 'Baixa', 1),
  ('MEDIA', 'Media', 2),
  ('ALTA', 'Alta', 3),
  ('CRITICA', 'Critica', 4)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO demand_complexity (codigo, nome, fator)
VALUES
  ('MUITO_BAIXA', 'Muito baixa', 1),
  ('BAIXA', 'Baixa', 2),
  ('MEDIA', 'Media', 3),
  ('ALTA', 'Alta', 5),
  ('MUITO_ALTA', 'Muito alta', 8)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO contract_status (codigo, nome)
VALUES
  ('RASCUNHO', 'Rascunho'),
  ('ATIVO', 'Ativo'),
  ('SUSPENSO', 'Suspenso'),
  ('ENCERRADO', 'Encerrado')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO financial_movement_type (codigo, nome, bucket, sinal)
VALUES
  ('DOTACAO_INICIAL', 'Dotacao inicial', 'dotacao', 1),
  ('DOTACAO_REFORCO', 'Dotacao reforco', 'dotacao', 1),
  ('DOTACAO_ANULACAO', 'Dotacao anulacao', 'dotacao', -1),
  ('EMPENHO', 'Empenho', 'empenho', 1),
  ('EMPENHO_REFORCO', 'Empenho reforco', 'empenho', 1),
  ('EMPENHO_ANULACAO', 'Empenho anulacao', 'empenho', -1),
  ('LIQUIDACAO', 'Liquidacao', 'liquidacao', 1),
  ('PAGAMENTO', 'Pagamento', 'pagamento', 1),
  ('CONSUMO_SERVICO', 'Consumo de servico', 'consumo', 1),
  ('ESTORNO_CONSUMO', 'Estorno de consumo', 'consumo', -1)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO document_type (codigo, nome)
VALUES
  ('CONTRATO', 'Contrato'),
  ('DEMANDA', 'Demanda'),
  ('SISTEMA', 'Sistema'),
  ('PUBLICACAO', 'Publicacao'),
  ('EMPENHO', 'Empenho'),
  ('NOTA_FISCAL', 'Nota fiscal'),
  ('ORGAO', 'Orgao'),
  ('MEMORANDO', 'Memorando'),
  ('OFICIO', 'Oficio'),
  ('SEI', 'SEI'),
  ('OUTRO', 'Outro')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO notification_type (codigo, nome)
VALUES
  ('NOVA_DEMANDA', 'Nova demanda'),
  ('MUDANCA_STATUS', 'Mudanca de status'),
  ('PUBLICACAO', 'Publicacao'),
  ('SALDO_BAIXO', 'Saldo baixo'),
  ('CONTRATO_PROXIMO_VENCIMENTO', 'Contrato proximo do vencimento'),
  ('PRAZO_VENCIDO', 'Prazo vencido'),
  ('NOVA_FUNCIONALIDADE', 'Nova funcionalidade'),
  ('ERRO_CRITICO', 'Erro critico'),
  ('NOVA_API', 'Nova API'),
  ('NOVO_DOCUMENTO', 'Novo documento')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO module_request_status (codigo, nome, ordem)
VALUES
  ('SOLICITADO', 'Solicitado', 1),
  ('EM_ANALISE', 'Em analise', 2),
  ('EM_DESENVOLVIMENTO', 'Em desenvolvimento', 3),
  ('EM_HOMOLOGACAO', 'Em homologacao', 4),
  ('IMPLANTADO', 'Implantado', 5),
  ('CANCELADO', 'Cancelado', 6)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO feature_request_status (codigo, nome, ordem, encerrado)
VALUES
  ('BACKLOG', 'Backlog', 1, FALSE),
  ('EM_ANALISE', 'Em analise', 2, FALSE),
  ('APROVADA', 'Aprovada', 3, FALSE),
  ('EM_DESENVOLVIMENTO', 'Em desenvolvimento', 4, FALSE),
  ('HOMOLOGACAO', 'Homologacao', 5, FALSE),
  ('PRODUCAO', 'Producao', 6, TRUE),
  ('REJEITADA', 'Rejeitada', 7, TRUE)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO feature_category (codigo, nome, descricao)
VALUES
  ('EVOLUCAO', 'Evolucao', 'Solicitacoes de evolucao funcional'),
  ('CORRECAO', 'Correcao', 'Solicitacoes de correcao de comportamento'),
  ('INTEGRACAO', 'Integracao', 'Solicitacoes envolvendo integracoes e APIs'),
  ('USABILIDADE', 'Usabilidade', 'Solicitacoes de melhoria de experiencia do usuario'),
  ('RELATORIO', 'Relatorio', 'Solicitacoes de relatorios e extracoes')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO user_role (codigo, nome, descricao)
VALUES
  ('ADMINISTRADOR', 'Administrador', 'Acesso total ao sistema'),
  ('GESTOR_CENTRAL', 'Gestor Central (SEPLAG)', 'Gestao central do contrato corporativo'),
  ('GESTOR_ANUENTE', 'Gestor do Anuente', 'Gestao das demandas e saldos do orgao anuente'),
  ('FISCAL', 'Fiscal', 'Acompanhamento tecnico e contratual'),
  ('CONSULTA', 'Consulta', 'Acesso somente leitura')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO notification_rule (codigo, nome, percentual_limite, dias_antecedencia)
VALUES
  ('SALDO_75', 'Alerta de consumo em 75%', 75, NULL),
  ('SALDO_90', 'Alerta de consumo em 90%', 90, NULL),
  ('SALDO_95', 'Alerta de consumo em 95%', 95, NULL),
  ('CONTRATO_VENCER', 'Contrato proximo do vencimento', NULL, 60),
  ('EMPENHO_BAIXO', 'Empenho proximo do fim', NULL, 30)
ON CONFLICT (codigo) DO NOTHING;

-- --------------------------------------------------------------------------
-- CONTRATO CORPORATIVO UNICO (SEMEADURA)
-- --------------------------------------------------------------------------
INSERT INTO contract (
  is_corporate_contract,
  numero,
  ano,
  processo_administrativo,
  objeto,
  fornecedor,
  data_inicio,
  data_fim,
  status_id,
  valor_total,
  saldo_atual,
  observacoes
)
SELECT
  TRUE,
  'CONTRATO-CORP-BPMS',
  EXTRACT(YEAR FROM CURRENT_DATE)::SMALLINT,
  'SEI-BPMS-CORPORATIVO',
  'Contrato corporativo do BPMS para atendimento aos orgaos anuentes',
  'PRODEMGE',
  CURRENT_DATE,
  (CURRENT_DATE + INTERVAL '48 months')::DATE,
  cs.id,
  0,
  0,
  'Cadastro inicial automatico do contrato corporativo unico'
FROM contract_status cs
WHERE cs.codigo = 'ATIVO'
ON CONFLICT (is_corporate_contract) DO NOTHING;

INSERT INTO contract_agency (
  contract_id,
  agency_id,
  saldo_inicial,
  saldo_consumido,
  saldo_atual,
  observacoes
)
SELECT
  c.id,
  a.id,
  0,
  0,
  0,
  'Vinculo inicial automatico ao contrato corporativo unico'
FROM contract c
JOIN agency a ON a.ativo = TRUE
WHERE c.is_corporate_contract = TRUE
ON CONFLICT (contract_id, agency_id) DO NOTHING;

INSERT INTO contract_service (
  contract_id,
  service_id,
  valor_contratado,
  valor_consumido,
  saldo_atual,
  situacao,
  observacoes
)
SELECT
  c.id,
  s.id,
  0,
  0,
  0,
  'ATIVO',
  'Vinculo inicial automatico ao contrato corporativo unico'
FROM contract c
JOIN contracted_service s ON s.ativo = TRUE
WHERE c.is_corporate_contract = TRUE
ON CONFLICT (contract_id, service_id) DO NOTHING;

-- --------------------------------------------------------------------------
-- CADASTROS INICIAIS PUBLICOS (BASE OPERACIONAL)
-- --------------------------------------------------------------------------
INSERT INTO agency (nome, sigla, responsavel, gestor_setorial, fiscal, email, telefone, observacoes)
VALUES
  ('Secretaria de Estado de Planejamento e Gestao', 'SEPLAG', NULL, NULL, NULL, NULL, NULL, 'Cadastro inicial automatico'),
  ('Companhia de Tecnologia da Informacao do Estado de Minas Gerais', 'PRODEMGE', NULL, NULL, NULL, NULL, NULL, 'Cadastro inicial automatico')
ON CONFLICT (sigla) DO NOTHING;

INSERT INTO contracted_service (nome, descricao, categoria, situacao, observacoes)
VALUES
  ('Sustentacao de sistemas', 'Atendimento corretivo e sustentacao operacional', 'SUSTENTACAO', 'ATIVO', 'Cadastro inicial automatico'),
  ('Evolucao funcional', 'Implementacao de novas funcionalidades e melhorias', 'EVOLUCAO', 'ATIVO', 'Cadastro inicial automatico'),
  ('Publicacao e deploy', 'Publicacoes, rollback e checklist tecnico', 'PUBLICACAO', 'ATIVO', 'Cadastro inicial automatico'),
  ('Integracao e APIs', 'Integracoes entre sistemas e APIs corporativas', 'INTEGRACAO', 'ATIVO', 'Cadastro inicial automatico')
ON CONFLICT (nome) DO NOTHING;

INSERT INTO system (nome, sigla, descricao, responsavel, agency_id, situacao, documentacao_url)
SELECT
  'proBPMS',
  'PROBPMS',
  'Sistema corporativo de gestao contratual',
  NULL,
  a.id,
  'ATIVO',
  NULL
FROM agency a
WHERE a.sigla = 'SEPLAG'
ON CONFLICT (sigla) DO NOTHING;

-- Backfill idempotente apos seed de anuentes/servicos para garantir vinculos do contrato unico.
INSERT INTO contract_agency (
  contract_id,
  agency_id,
  saldo_inicial,
  saldo_consumido,
  saldo_atual,
  observacoes
)
SELECT
  c.id,
  a.id,
  0,
  0,
  0,
  'Vinculo automatico do contrato corporativo unico'
FROM contract c
JOIN agency a ON a.ativo = TRUE
WHERE c.is_corporate_contract = TRUE
ON CONFLICT (contract_id, agency_id) DO NOTHING;

INSERT INTO contract_service (
  contract_id,
  service_id,
  valor_contratado,
  valor_consumido,
  saldo_atual,
  situacao,
  observacoes
)
SELECT
  c.id,
  s.id,
  0,
  0,
  0,
  'ATIVO',
  'Vinculo automatico do contrato corporativo unico'
FROM contract c
JOIN contracted_service s ON s.ativo = TRUE
WHERE c.is_corporate_contract = TRUE
ON CONFLICT (contract_id, service_id) DO NOTHING;

-- --------------------------------------------------------------------------
-- VIEWS DE APOIO (DASHBOARD E RELATORIOS)
-- --------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dashboard_executivo AS
SELECT
  c.id AS contract_id,
  c.numero,
  c.ano,
  c.valor_total,
  c.valor_executado,
  c.valor_pago,
  c.valor_empenhado,
  c.valor_liquidado,
  c.saldo_atual,
  (SELECT COUNT(*) FROM demand d WHERE d.contract_id = c.id AND d.ativo = TRUE) AS demandas_total,
  (SELECT COUNT(*) FROM demand d JOIN demand_status ds ON ds.id = d.status_id WHERE d.contract_id = c.id AND d.ativo = TRUE AND ds.encerrado = FALSE) AS demandas_abertas,
  (SELECT COUNT(*) FROM demand d WHERE d.contract_id = c.id AND d.ativo = TRUE AND d.prazo IS NOT NULL AND d.prazo < CURRENT_DATE AND d.data_conclusao IS NULL) AS demandas_atrasadas,
  (SELECT COUNT(*) FROM demand_publication dp JOIN demand d2 ON d2.id = dp.demand_id WHERE d2.contract_id = c.id AND dp.ativo = TRUE) AS publicacoes_total,
  (SELECT COUNT(*) FROM demand_api da JOIN demand d3 ON d3.id = da.demand_id WHERE d3.contract_id = c.id AND da.ativo = TRUE) AS apis_total,
  (SELECT COUNT(*) FROM demand_functionality df JOIN demand d4 ON d4.id = df.demand_id WHERE d4.contract_id = c.id AND df.ativo = TRUE) AS funcionalidades_total,
  (SELECT COUNT(*) FROM demand_error de JOIN demand d5 ON d5.id = de.demand_id WHERE d5.contract_id = c.id AND de.ativo = TRUE) AS erros_total
FROM contract c
WHERE c.ativo = TRUE;

CREATE OR REPLACE VIEW vw_consumo_mensal AS
SELECT
  fm.contract_id,
  DATE_TRUNC('month', fm.data_movimento)::DATE AS mes,
  SUM(fm.valor * fmt.sinal) AS valor_consumido
FROM financial_movement fm
JOIN financial_movement_type fmt ON fmt.id = fm.movement_type_id
WHERE fm.ativo = TRUE
  AND fmt.bucket = 'consumo'
GROUP BY fm.contract_id, DATE_TRUNC('month', fm.data_movimento)::DATE;

CREATE OR REPLACE VIEW vw_saldo_por_anuente AS
SELECT
  ca.contract_id,
  ca.agency_id,
  a.nome AS anuente_nome,
  a.sigla AS anuente_sigla,
  ca.saldo_inicial,
  ca.saldo_consumido,
  ca.saldo_atual,
  ca.quantidade_demandas,
  ca.quantidade_publicacoes,
  ca.quantidade_funcionalidades,
  ca.quantidade_erros
FROM contract_agency ca
JOIN agency a ON a.id = ca.agency_id
WHERE ca.ativo = TRUE
  AND a.ativo = TRUE;

CREATE OR REPLACE VIEW vw_saldo_por_empenho AS
SELECT
  c.contract_id,
  c.id AS commitment_id,
  c.numero_empenho,
  c.data_empenho,
  c.valor AS valor_original,
  COALESCE(SUM(CASE WHEN ca.tipo = 'REFORCO' THEN ca.valor ELSE 0 END), 0) AS valor_reforco,
  COALESCE(SUM(CASE WHEN ca.tipo = 'ANULACAO' THEN ca.valor ELSE 0 END), 0) AS valor_anulacao,
  c.valor
    + COALESCE(SUM(CASE WHEN ca.tipo = 'REFORCO' THEN ca.valor ELSE 0 END), 0)
    - COALESCE(SUM(CASE WHEN ca.tipo = 'ANULACAO' THEN ca.valor ELSE 0 END), 0) AS valor_ajustado
FROM commitment c
LEFT JOIN commitment_adjustment ca ON ca.commitment_id = c.id AND ca.ativo = TRUE
WHERE c.ativo = TRUE
GROUP BY c.contract_id, c.id, c.numero_empenho, c.data_empenho, c.valor;

CREATE OR REPLACE VIEW vw_saldo_por_dotacao AS
SELECT
  ba.contract_id,
  ba.id AS budget_allocation_id,
  ba.numero_dotacao,
  ba.exercicio,
  ba.valor,
  ba.data_movimento,
  ba.agency_id
FROM budget_allocation ba
WHERE ba.ativo = TRUE;

CREATE OR REPLACE VIEW vw_linha_do_tempo AS
SELECT
  te.id,
  te.contract_id,
  te.agency_id,
  te.categoria,
  te.titulo,
  te.descricao,
  te.referencia_tabela,
  te.referencia_id,
  te.data_evento
FROM timeline_event te
WHERE te.ativo = TRUE
ORDER BY te.data_evento DESC;

CREATE OR REPLACE VIEW vw_module_request_status AS
SELECT
  mr.id,
  mr.created_at,
  mr.contract_id,
  mr.agency_id,
  mr.system_id,
  mr.nome_modulo,
  mr.sigla_modulo,
  mr.data_criacao_modulo,
  mr.data_solicitacao,
  mr.prazo_atendimento,
  mr.status_id,
  mrs.codigo AS status_codigo,
  mrs.nome AS status_nome,
  mr.processo_sei,
  mr.observacoes,
  CASE
    WHEN mr.prazo_atendimento IS NULL THEN 'SEM PRAZO'
    WHEN mrs.codigo IN ('IMPLANTADO', 'CANCELADO') THEN 'CONCLUIDO'
    WHEN CURRENT_DATE > mr.prazo_atendimento THEN 'ATRASADO'
    ELSE 'NO PRAZO'
  END AS situacao_prazo,
  CASE
    WHEN mr.prazo_atendimento IS NOT NULL
         AND mrs.codigo NOT IN ('IMPLANTADO', 'CANCELADO')
         AND CURRENT_DATE > mr.prazo_atendimento
      THEN (CURRENT_DATE - mr.prazo_atendimento)
    ELSE 0
  END AS dias_atraso
FROM module_request mr
JOIN module_request_status mrs ON mrs.id = mr.status_id
WHERE mr.ativo = TRUE;

-- --------------------------------------------------------------------------
-- GRANTS (SUPABASE CLIENT)
-- Mantem seguranca via RLS, mas garante privilegios necessarios de objeto.
-- --------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO authenticated, anon;

DO $$
DECLARE
  t RECORD;
BEGIN
  FOR t IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
  LOOP
    EXECUTE format('GRANT SELECT, INSERT, UPDATE ON TABLE %I TO authenticated', t.table_name);
    EXECUTE format('GRANT SELECT ON TABLE %I TO anon', t.table_name);
  END LOOP;
END;
$$;

DO $$
DECLARE
  v RECORD;
BEGIN
  FOR v IN
    SELECT table_name
    FROM information_schema.views
    WHERE table_schema = 'public'
  LOOP
    EXECUTE format('GRANT SELECT ON TABLE %I TO authenticated, anon', v.table_name);
  END LOOP;
END;
$$;

COMMIT;
