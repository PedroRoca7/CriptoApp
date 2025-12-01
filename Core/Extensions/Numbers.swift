//
//  Numbers.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 23/02/25.
//

import Foundation

extension Double {
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "BRL"
        formatter.currencySymbol = "R$ "
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func toDollarString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func string(format: String = "%.2f") -> String {
        return String(format: format, self)
    }
    
    func toPercentageString() -> String {
        let formatted = String(format: "%.2f", self)
        let brazilFormatted = formatted.replacingOccurrences(of: ".", with: ",")
        return "\(brazilFormatted)%"
    }
    
    
    func abbreviated() -> String {
        let num = abs(self)
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...: // Trillion
            return "\(sign)\((num / 1_000_000_000_000).rounded(toPlaces: 2))Tr"
        case 1_000_000_000...: // Billion
            return "\(sign)\((num / 1_000_000_000).rounded(toPlaces: 2))Bn"
        case 1_000_000...: // Million
            return "\(sign)\((num / 1_000_000).rounded(toPlaces: 2))M"
        case 1_000...: // Thousand
            return "\(sign)\((num / 1_000).rounded(toPlaces: 2))K"
        default:
            return "\(sign)\(self.rounded(toPlaces: 2))"
        }
    }
     
    func rounded(toPlaces places:Int) -> String {
        String(format: "%.\(places)f", self)
    }
}

extension Optional where Wrapped == Double {
    func string(format: String = "%.2f") -> String {
        return String(format: format, self ?? 0)
    }
}

extension Int {
    private func string() -> String {
        return String(self)
    }
}
