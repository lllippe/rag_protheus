🤖 **Agente RAG Financeiro: Gemini + Protheus (AdvPL)🌟**

**Descrição do Projeto**

Este projeto demonstra a criação de um **Agente RAG (Retrieval Augmented Generation)** utilizando o Google Gemini e o framework LangChain para modernizar a interação com sistemas ERP legados, como o **Protheus (AdvPL).**

O objetivo é traduzir consultas de negócios complexas (ex: "Qual foi o faturamento do último trimestre de 2024?") em chamadas de API otimizadas, processar os dados financeiros e devolver uma resposta coesa em linguagem natural para uma aplicação frontend (como o **Flutter**).

🏗️ Arquitetura do Sistema (Visão Geral)O fluxo de dados e raciocínio é gerenciado pelo **Agente de IA**, que atua como um tradutor e processador de dados:
1. **Frontend (Flutter)**: Envia a pergunta do usuário para o FastAPI.
2. **Servidor RAG (FastAPI/LangChain)**: O Gemini decide quando e como usar a ferramenta.
3. **Ferramenta AdvPL (Python)**: Faz a chamada REST otimizada ao Protheus/AdvPL.
4. **Protheus**: Retorna o dataset completo (ex: 12 meses de faturamento).
5. **Agente RAG**: Filtra, calcula e gera a resposta final.

✨ **Funcionalidades**

* **Consulta em Linguagem Natural**: Tradução de consultas complexas em comandos estruturados para a API AdvPL.
* **Otimização de Desempenho**: Estratégia de consulta otimizada: Apenas **uma chamada REST anual** é feita ao Protheus para resolver qualquer pergunta (mensal, trimestral ou anual). O processamento de dados é realizado pelo LLM.
* **Segurança Integrada**: Utilização de Basic Auth para comunicação segura com o AppServer Protheus.
* **Processamento de Dados**: Capacidade do Agente de filtrar, agregar e consolidar grandes datasets (os 12 meses de dados) em tempo real, baseado no prompt do usuário.

🛠️ **Setup e Instalação**

**Pré-requisitos**

* Python 3.11+
* Chave de API do Gemini (Google AI Studio)
* API REST de Faturamento AdvPL funcional no seu ambiente Protheus.

**Instalação**

Clone o repositório e instale as dependências Python
pip install -r requirements.txt 

🔑 **Configuração de Ambiente**

Crie um arquivo .env ou defina as seguintes variáveis de ambiente no seu terminal (obrigatório para segurança e funcionamento):

|Variável|Descrição|Exemplo (Linux/macOS)|
|--------|---------|---------------------|
|GEMINI_API_KEY|Chave de API do Google Gemini.|export GEMINI_API_KEY='SUA_CHAVE'|
|PROTHEUS_API_BASE|URL base para sua API REST AdvPL.|export PROTHEUS_API_BASE='http://<IP_APPSERVER>:<PORTA>/rest'|
|PROTHEUS_AUTH_USER|Usuário para autenticação Basic Auth.|export PROTHEUS_AUTH_USER='PROTHEUS_USER'|
|PROTHEUS_AUTH_PASS|Senha para autenticação Basic Auth.|export PROTHEUS_AUTH_PASS='123mudar'|

🚀 **Como Executar o Serviço**

Inicie o servidor Uvicorn com o flag --host 0.0.0.0 para que ele seja acessível ao seu emulador Flutter (10.0.2.2).

Bashuvicorn main:app --reload --host 0.0.0.0 --port 8000

Após iniciar, a documentação interativa estará disponível em: http://localhost:8000/docs.

**Exemplo de Teste (cURL)**

Você pode testar o endpoint diretamente:
POST 'http://localhost:8000/api/rag/query' \
-H 'Content-Type: application/json' \
-d '{
    "query": "Qual foi o faturamento do segundo trimestre de 2025?"
}'


🧠 **Destaques Técnicos**

Este projeto superou desafios críticos de integração de LLMs com APIs legadas:

1. **StructuredTool para Tipagem**: A utilização do StructuredTool (com Pydantic) foi essencial para garantir que o LLM só tentasse chamar a função faturamento_mensal com o argumento ano, conforme a regra de otimização, superando as limitações do Tool genérico.
2. **Estratégia de Data Processing**: O Agente foi instruído via prompt a mudar de um orquestrador de chamadas para um **Processador de Dados**. Ele agora recebe o dataset completo (12 meses) e usa o raciocínio para filtrar e somar o resultado, garantindo alta performance e menor latência.
3. **Controle de Encoding**: Implementação de decodificação explícita (utf8.decode) no *frontend Flutter* para garantir o correto tratamento de caracteres especiais (acentuação) provenientes do servidor.
