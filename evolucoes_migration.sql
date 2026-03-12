-- ============================================
-- CLÍNICA FÁCIL — Evolucoes Migration
-- Run this in Supabase SQL Editor
-- ============================================

-- 7. EVOLUCOES (clinical evolution notes / session records)
CREATE TABLE IF NOT EXISTS public.evolucoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  data DATE NOT NULL,
  hora TEXT NOT NULL,
  humor INTEGER DEFAULT 0 CHECK (humor >= 0 AND humor <= 10),
  ansiedade INTEGER DEFAULT 0 CHECK (ansiedade >= 0 AND ansiedade <= 10),
  -- SOAP fields (nullable — user can use free text instead)
  soap_s TEXT, -- Subjetivo
  soap_o TEXT, -- Objetivo
  soap_a TEXT, -- Avaliação
  soap_p TEXT, -- Plano
  -- Free text (alternative to SOAP)
  texto TEXT,
  -- Intervention tags
  tags JSONB DEFAULT '[]'::JSONB,
  -- Session transcript
  transcricao TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.evolucoes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can CRUD own evolucoes" ON public.evolucoes FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_evolucoes_user ON public.evolucoes(user_id);
CREATE INDEX idx_evolucoes_paciente ON public.evolucoes(paciente_id);
CREATE INDEX idx_evolucoes_data ON public.evolucoes(data);

-- Also add testes table if not exists
CREATE TABLE IF NOT EXISTS public.testes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  local_id TEXT,
  paciente_id UUID NOT NULL REFERENCES public.pacientes(id) ON DELETE CASCADE,
  data DATE NOT NULL,
  teste_nome TEXT NOT NULL,
  score INTEGER,
  nivel TEXT,
  cor TEXT,
  descricao TEXT,
  perfil JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.testes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can CRUD own testes" ON public.testes FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_testes_user ON public.testes(user_id);
CREATE INDEX idx_testes_paciente ON public.testes(paciente_id);
