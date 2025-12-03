import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ia_protheus/services/web_client.dart';

class RagApiService {
    Future<String> sendQuestion(String question) async {
      String _endpoint = 'api/rag/query'; //Colocar o endpoint que você criou dentro do FastAPI
      http.Client client = WebClient().client;

      String getURL() {
        return "${WebClient.url}$_endpoint";
      }

      Uri getUri() {
        return Uri.parse(getURL());
      }

      final body = jsonEncode({
            'query': question,
          });
      print(body);
      try {
        final response = await http.post(
          getUri(),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        );

        // --- Tratamento da Resposta ---
        
        if (response.statusCode == 200) {
          // Sucesso: A resposta do FastAPI contém o campo 'resposta'
          final utf8Body = utf8.decode(response.bodyBytes);

          final responseBody = jsonDecode(utf8Body);
          
          // Verifica se o campo 'resposta' existe e retorna
          if (responseBody.containsKey('resposta')) {
            final respostaList = responseBody['resposta'] as List;
            
            if (respostaList.isNotEmpty) {
              final firstMessage = respostaList.first as Map<String, dynamic>;
              
              // Verifica e retorna o campo 'text'
              if (firstMessage.containsKey('text')) {
                return firstMessage['text'] as String; // Retorna o texto aninhado
              }
            }
            return 'Erro: Estrutura de resposta inválida ou lista vazia.';
            
          } else {
            return 'Erro: Resposta 200 recebida, mas campo "resposta" ausente.';
          }
          
        } else if (response.statusCode == 400) {
          // Erro do cliente (ex: query vazia)
          return 'Erro 400: Requisição inválida (verifique a query).';
        } else if (response.statusCode == 500) {
          // Erro interno no FastAPI/Agente RAG
          final errorBody = jsonDecode(response.body);
          return 'Erro 500: Falha na execução do Agente RAG. Detalhes: ${errorBody['detail']}';
        } else {
          // Outros códigos de erro HTTP
          return 'Erro de Servidor: Status Code ${response.statusCode}.';
        }
      } catch (e) {
        // Erro de rede ou timeout
        print('Erro de conexão com FastAPI: $e');
        return 'Erro de conexão: Não foi possível alcançar o Servidor RAG.';
      }
    }
}