import requests
import os
from typing import Optional


AUTH_TUPLE = ('usuario_protheus', 'senha_usuario_protheus')


def protheus_faturamento_mensal(ano: str) -> dict:
    """Função Ferramenta RAG: Obtém dados de faturamento mensal do ERP Protheus."""

    endpoint = "http://ip_servidor_protheus:8090/rest/faturamento"
    params = {'ano': ano}

    try:
        response = requests.get(endpoint, params=params, timeout=15, auth=AUTH_TUPLE)
        print(response.request.url)
        response.raise_for_status()
        return response.json()

    except requests.exceptions.RequestException as e:
        # Se falhar, o RAG saberá que não conseguiu acessar os dados
        return {"error": "Falha na comunicação com a API AdvPL.", "details": str(e)}
