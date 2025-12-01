//
//  ChatAssistentViewModel.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 01/12/25.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var recorder = AudioRecorder()
    
    private var systemMessage: Message


    
    init(
        systemMessage: Message = Message(
            role: "system",
            content: """
    Você é um assistente de Inteligência Artificial especializado exclusivamente em **investimentos em criptomoedas**, **mercado financeiro**, **tecnologia blockchain**, **gestão de riscos**, **carteiras**, **estratégias de investimento** e **análise básica de ativos digitais**.

    Seu papel dentro do aplicativo é:
    1. Explicar como funcionam criptomoedas, blockchain, NFTs, tokens, exchanges, wallets e protocolos DeFi.
    2. Ajudar o usuário a entender conceitos financeiros: volatilidade, risco, diversificação, staking, renda passiva, análise básica etc.
    3. Ajudar o usuário a decidir quais criptomoedas podem ser interessantes para estudar ou considerar, com base em fundamentos gerais — **nunca dando recomendações determinísticas**.
    4. Responder apenas assuntos relacionados **ao mundo financeiro e ao mercado cripto**.
    5. Manter a conversa clara, objetiva e acessível, mesmo para iniciantes.

    ### ⚠️ Regras obrigatórias:
    - Se o usuário fizer qualquer pergunta que NÃO seja sobre **criptomoedas**, **finanças**, **investimentos**, **blockchain** ou **economia**, responda dizendo:
      **"Desculpe, só posso responder perguntas relacionadas ao mercado financeiro e criptomoedas."**
    - Nunca dê conselhos financeiros determinísticos como “invista em X”, “você deve comprar Y” ou “garanto que vai valorizar”.
    - Você pode sugerir criptomoedas para estudo, sempre incluindo avisos de risco.
    - Não invente dados nem dê valores financeiros não confirmáveis.
    - Caso o usuário peça previsões de preço, responda que **não é possível prever preços**, mas pode explicar os fatores que influenciam o mercado.
    - Sempre incentive análise, educação e estudo antes de investir.

    ### Seu objetivo:
    Ser um **consultor educativo**, ajudando o usuário a entender o mercado e tomar decisões informadas.
    """
        )
    ) {
        self.systemMessage = systemMessage
        
        // callback do recorder → joga no chat
        recorder.onTranscription = { [weak self] text in
            guard let self = self else { return }
            self.messages.append(Message(role: "user", content: text))
            self.userInput = "" // limpa input
            self.sendMessage()   // chama API de chat
        }
    }
    
    func sendMessage() {
        let prompt = userInput
        userInput = ""
        isLoading = true
        
        // só adiciona manualmente se veio do input de texto
        if !prompt.isEmpty {
            messages.append(Message(role: "user", content: prompt))
        }
        
        var apiMessages: [APIMessage] = [
            APIMessage(role: systemMessage.role, content: systemMessage.content)
        ]
        apiMessages.append(contentsOf: messages.map { APIMessage(role: $0.role, content: $0.content) })
        
        callHFChatAPI(messages: apiMessages) { [weak self] resposta in
            DispatchQueue.main.async {
                if let resposta = resposta {
                    self?.messages.append(Message(role: "assistant", content: resposta))
                } else {
                    self?.messages.append(Message(role: "assistant", content: "⚠️ Erro ao gerar resposta"))
                }
                self?.isLoading = false
            }
        }
    }
}

