//
//  ChatAssistentRecord.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 01/12/25.
//

import AVFoundation

class AudioRecorder: NSObject {
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?
    
    var onTranscription: ((String) -> Void)?  // callback quando tiver texto
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("gravacao.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.record()
            
            print("🎙️ Gravando em: \(audioFilename!)")
        } catch {
            print("Erro ao iniciar gravação: \(error)")
        }
    }
    
    func stopRecordingAndSend() {
        audioRecorder?.stop()
        if let url = audioFilename {
            sendToHuggingFace(audioURL: url)
        }
    }
    
    private func sendToHuggingFace(audioURL: URL) {
        let token = Bundle.main.object(forInfoDictionaryKey: "HUGGINGFACE_TOKEN") as? String ?? ""
        
        guard let audioData = try? Data(contentsOf: audioURL) else { return }
        
        var request = URLRequest(url: URL(string: "https://api-inference.huggingface.co/models/openai/whisper-large-v3")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("audio/m4a", forHTTPHeaderField: "Content-Type")
        request.httpBody = audioData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let text = json["text"] as? String {
                DispatchQueue.main.async {
                    self?.onTranscription?(text)
                }
            }
        }
        task.resume()
    }
}

