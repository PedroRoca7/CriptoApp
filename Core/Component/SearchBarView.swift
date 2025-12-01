//
//  SearchBarView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 21/11/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? .secondaryText : .accent
                )
            TextField("Pesquise por nome ou simbolo...", text: $searchText)
                .disableAutocorrection(true)
                .foregroundStyle(.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(.redColorToken)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.background)
                .shadow(
                    color: .accent.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: 0
                )
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
