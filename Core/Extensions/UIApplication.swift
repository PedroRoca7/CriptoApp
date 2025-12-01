//
//  UIApplication.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 21/11/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
