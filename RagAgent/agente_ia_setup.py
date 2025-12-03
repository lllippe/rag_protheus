# agente_ia_setup.py (SOLUÇÃO FINAL)

import os
from langchain_core.tools import StructuredTool # Substitui a importação do Tool
from pydantic import BaseModel, Field # Necessário para definir a estrutura
from langchain_core.tools import Tool
from langchain.agents import create_agent # Função que sua versão utiliza
from langchain_google_genai import ChatGoogleGenerativeAI
from ferramentas_protheus import protheus_faturamento_mensal
from typing import Optional


class FaturamentoInput(BaseModel):
    """Define os argumentos esperados pela ferramenta de faturamento."""
    ano: str = Field(description="O ano desejado, sempre no formato YYYY (ex: '2025').")


# Carrega a chave do Gemini do ambiente
GEMINI_API_KEY = 'utilizar_sua_api_key' 

# 1. O LLM (Argumento 'model')
llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", api_key=GEMINI_API_KEY)

# 2. A Ferramenta (Argumento 'tools')
tools = [
    StructuredTool.from_function( # NOVO: Usando StructuredTool
        func=protheus_faturamento_mensal,
        name="faturamento_mensal",
        description="Use para obter dados financeiros mensais do ERP Protheus. O Agente deve garantir que os parâmetros 'mes' (MM) e 'ano' (YYYY) sejam extraídos corretamente.",
        args_schema=FaturamentoInput # Passa o esquema Pydantic
    )
]

# 3. O Prompt (Argumento 'system_prompt')
SYSTEM_PROMPT_CONTENT = """
Você é um Agente de Análise de Dados financeiro, especializado em consultar o ERP Protheus. 
Sua função é atuar como um Data Processor (Processador de Dados):
1.  Extrair o ano da pergunta.
2.  Fazer uma ÚNICA consulta anual para obter os 12 meses de dados.
3.  Analisar o conjunto de dados completo (JSON) retornado e realizar a filtragem e agregação.

### 🎯 Regras de Ação Otimizadas:
1.  **Ação Única:** Você DEVE planejar **apenas uma chamada** à ferramenta 'faturamento_mensal' e deve **SOMENTE** fornecer o parâmetro 'ano' (YYYY).
2.  **Processamento de Dados:** Após a consulta, você receberá um conjunto de dados contendo o faturamento dos 12 meses. Seu raciocínio DEVE:
    * **Mensal:** Se o usuário pediu um único mês (ex: "Janeiro"), filtre o dado desse mês no JSON.
    * **Trimestral:** Se o usuário pediu um trimestre (ex: "1º Trimestre"), filtre e **SOME** os três meses correspondentes.
    * **Anual:** Se o usuário pediu o ano total, **SOME** os 12 meses do dataset.
3.  **Resposta Final:** A resposta deve ser a agregação final do valor total, formatada em português, concisa e NUNCA mostrando o JSON ou o processo de filtro.

### 🛠️ Formato de Raciocínio (ReAct)
Use o seguinte formato:

Pensamento: [Descreva seu plano: Qual ano preciso consultar? Qual período (Mensal, Trimestral, Anual) preciso filtrar e somar no dataset de 12 meses que receberei?]

Ação: faturamento_mensal(ano="YYYY")

Observação: [Resultado do AdvPL em JSON (Dataset Completo)]

Pensamento: Eu filtrei os dados do dataset (ex: Meses 01, 02 e 03) e somei os valores. O valor consolidado é X.
Resposta Final: [O valor agregado e formatado para o usuário.]

Comece!
"""

# 4. Criação do Agente (Utilizando a assinatura correta)
RAG_AGENT = create_agent(
    llm,  # POSICIONAL: model
    tools, # POSICIONAL: tools
    system_prompt=SYSTEM_PROMPT_CONTENT, # KEYWORD-ONLY: system_prompt
)

RAG_AGENT_CONFIG = {
    "agent": RAG_AGENT,
    "tools": tools,
}
