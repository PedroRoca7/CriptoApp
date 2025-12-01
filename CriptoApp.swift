//
//  CriptoAppApp.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 24/01/25.
//

import SwiftUI

@main
struct CriptoApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true) 
            }
            .environmentObject(viewModel)
        }
    }
}
