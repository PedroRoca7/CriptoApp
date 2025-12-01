//
//  ChatAssistentService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 01/12/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}

struct APIMessage: Codable {
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let messages: [APIMessage]
    let model: String
    let stream: Bool
}

struct Choice: Codable {
    let message: APIMessage
}

struct ChatResponse: Codable {
    let choices: [Choice]
}

// MARK: - Chamada API
func callHFChatAPI(messages: [APIMessage], completion: @escaping (String?) -> Void) {
    let token =  Bundle.main.object(forInfoDictionaryKey: "HUGGINGFACE_TOKEN") as? String ?? ""
    let url = URL(string: "https://router.huggingface.co/v1/chat/completions")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ChatRequest(messages: messages, model: "openai/gpt-oss-120b:fireworks-ai", stream: false)
    
    do {
        request.httpBody = try JSONEncoder().encode(body)
    } catch {
        completion("Erro ao codificar body: \(error.localizedDescription)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion("Erro de rede: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            completion("Nenhum dado recebido")
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
            let resposta = decoded.choices.first?.message.content
            completion(resposta)
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "Resposta não legível"
            completion("Erro parse JSON: \(error.localizedDescription)\nRaw:\n\(raw)")
        }
    }
    
    task.resume()
}

