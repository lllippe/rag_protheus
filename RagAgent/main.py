from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from agente_ia_setup import RAG_AGENT_CONFIG
from langchain_core.messages import HumanMessage


class QueryRequest(BaseModel):
    query: str


app = FastAPI(title="Servidor RAG - API Protheus")


@app.post("/api/rag/query")
async def rag_query_endpoint(request_data: QueryRequest):
    user_query = request_data.query

    try:
        agent = RAG_AGENT_CONFIG['agent']
        tools = RAG_AGENT_CONFIG['tools']

        # O Agente RAG é invocado com os dados necessários para o prompt ReAct
        result = agent.invoke(
            {
                #"input": user_query,
                "messages": [HumanMessage(content=user_query)],
                "tools": tools,
                "tool_names": ", ".join([t.name for t in tools])
            }
        )

        # O objeto retorna o estado final, onde a última 'message' é a resposta
        final_message = result.get('messages')[-1]
        final_result = final_message.content

        return {"resposta": final_result}

    except Exception as e:
        print(f"Erro na Execução do Agente RAG: {e}")
        raise HTTPException(status_code=500, detail="Erro interno na execução do Agente RAG.")
