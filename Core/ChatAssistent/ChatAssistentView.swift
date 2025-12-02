//
//  ChatAssistentView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 01/12/25.
//

import SwiftUI
import CoreUI

struct ChatView: View {
    
    @EnvironmentObject private var viewModel: ChatViewModel
    @State private var isRecording = false
    @State private var showSuggestions = false
    
    let suggestions = [
            "Como está o mercado de cripto hoje?",
            "Analise meu portifólio",
            "Quais criptos mais subiram hoje?",
            "Faça um resumo das principais notícias de cripto"
        ]
        
    var body: some View {
        VStack {
            if viewModel.messages.isEmpty {
                Spacer()
                Text("Hi, How can I help you?")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: .scale12) {
                            ForEach(viewModel.messages) { msg in
                                HStack {
                                    if msg.role == "user" {
                                        Spacer()
                                        Text(msg.content)
                                            .padding()
                                            .background(.redColorToken)
                                            .foregroundColor(.white)
                                            .cornerRadius(.scale12)
                                    } else {
                                        Text(msg.content)
                                            .padding()
                                            .background(.accent)
                                            .foregroundColor(Color.background)
                                            .cornerRadius(.scale12)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding()
                        .onChange(of: viewModel.messages.count) { _ in
                            if let last = viewModel.messages.last {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Digite sua mensagem...", text: $viewModel.userInput)
                    .padding(6)
                    .background(Color.background)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading)
                    .onSubmit {
                        if !viewModel.userInput.isEmpty && !viewModel.isLoading {
                            viewModel.sendMessage()
                        }
                    }
                
                Button(action: viewModel.sendMessage) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .background(Color.background)
                .cornerRadius(8)
                .disabled(viewModel.userInput.isEmpty || viewModel.isLoading)
                .buttonStyle(.borderedProminent)
                .tint(.redColorToken)
                .foregroundStyle(
                    .white
                )
                
                Button(action: {
                    if isRecording {
                        viewModel.recorder.stopRecordingAndSend()
                    } else {
                        viewModel.recorder.startRecording()
                    }
                    isRecording.toggle()
                }) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(isRecording ? .redColorToken : .background)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, .scale8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.secondaryText, .background],
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .sheet(isPresented: $showSuggestions) {
            suggestionSheet
                .presentationDetents([.fraction(0.8), .medium])
        }
                
        // 👉 Abre o bottomsheet quando a tela aparecer
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showSuggestions = true
            }
        }
    }
    
    var suggestionSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sugestões Rápidas")
                .font(.headline)
            
            ForEach(suggestions, id: \.self) { text in
                Button(action: {
                    if text == "Analise meu portifólio" {
                        viewModel.userInput = viewModel.generatePortfolioSummaryFromCoreData()
                        viewModel.sendMessage()
                        showSuggestions = false
                    } else {
                        viewModel.userInput = text
                        viewModel.sendMessage()
                        showSuggestions = false
                    }
                }) {
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    ChatView()
        .environmentObject(ChatViewModel(allCoins: []))
}
