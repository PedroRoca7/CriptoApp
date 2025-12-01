//
//  BaseView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 26/01/25.
//

import CoreUI
import SwiftUI

struct BaseView<Content: View>: View {
    
    let hideNavigationBar: Bool
    let backgroundColor: Color
    let backgroundTopColor: Color
    let title: String
    let leftIcon: AnyView?
    let leftIconAction: () -> Void
    let rightIcon: AnyView?
    let rightIconAction: () -> Void
    let content: Content
    
    init(
        hideNavigationBar: Bool = false,
        backgroundColor: Color = .background,
        backgroundTopColor: Color = .background,
        title: String = String(),
        leftIcon: AnyView? = nil,
        leftIconAction: @escaping () -> Void = {},
        rightIcon: AnyView? = nil,
        rightIconAction: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.hideNavigationBar = hideNavigationBar
        self.backgroundColor = backgroundColor
        self.backgroundTopColor = backgroundTopColor
        self.title = title
        self.leftIcon = leftIcon
        self.leftIconAction = leftIconAction
        self.rightIcon = rightIcon
        self.rightIconAction = rightIconAction
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    if !hideNavigationBar {
                        HStack {
                            ZStack {
                                if let leftIcon = leftIcon {
                                    leftIcon
                                        .onTapGesture {
                                            leftIconAction()
                                        }
                                        .foregroundColor(.accent)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Text(title)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.accent)
                                    .frame(maxWidth: .infinity)
                                
                                if rightIcon != nil {
                                    rightIcon
                                        .onTapGesture {
                                            rightIconAction()
                                        }
                                        .foregroundColor(.accent)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(backgroundTopColor)
                        .padding(.top, UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .first?
                            .windows
                            .first?
                            .safeAreaInsets.top ?? 0)
                    }
                    VStack {
                        content
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    BaseView(
        hideNavigationBar: false,
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


