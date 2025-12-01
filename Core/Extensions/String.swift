//
//  String.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 29/11/25.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
