//
//  NetworkingManager.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 14/11/25.
//

import Combine
import Foundation

class NetworkingManager {
    
    enum NetworkingError: Error {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad URL Response: \(url)"
            case .unknown:
                return "[⚠] Unknown Error"
            }
        }
    }
    
    static func download<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let data = try await download(url: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func download(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleURLResponse(response: response, url: url, data: data)
    }
    
    private static func handleURLResponse(
        response: URLResponse,
        url: URL,
        data: Data
    ) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return data
    }
}
