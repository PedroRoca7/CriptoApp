//
//  BaseView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 26/01/25.
//

import CoreUI
import SwiftUI

struct BaseView<Content: View>: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let hideNavigationBar: Bool
    let backgroundColor: Color
    let title: String
    let leftIcon: AnyView?
    let rightIcon: AnyView?
    let leftIconAction: (() -> Void)?
    let content: Content
    
    init(
        hideNavigationBar: Bool = false,
        backgroundColor: Color = .background,
        title: String = .init(),
        leftIcon: AnyView? = nil,
        rightIcon: AnyView? = nil,
        leftIconAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.hideNavigationBar = hideNavigationBar
        self.backgroundColor = backgroundColor
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.leftIconAction = leftIconAction
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color(UIColor(Color.theme.background))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !hideNavigationBar {
                    HStack {
                        ZStack {
                            if let leftIcon = leftIcon {
                                Button(action: {
                                    leftIconAction?() ?? presentationMode.wrappedValue.dismiss()
                                }) {
                                    leftIcon
                                }
                                .foregroundColor(.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Text(title)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.accent)
                                .padding()
                                .frame(maxWidth: .infinity)
                            
                            if rightIcon != nil {
                                rightIcon
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .ignoresSafeArea(edges: .top)
                    .padding()
                    .background(Color.theme.background)
                }
                Spacer(minLength: 0)
                
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    BaseView(
        title: "Teste",
        leftIcon: AnyView(
            Image(systemName: "chevron.backward")
        ),
        rightIcon: AnyView(
            Image(systemName: "chevron.right"))
    ) {
        Text("Hello, World!")
    }
}


