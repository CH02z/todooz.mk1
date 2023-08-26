//
//  LoadingView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.gray, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false))
            
            
        }
        .onAppear() {
            self.isAnimating = true
        }
        .onDisappear() {
            self.isAnimating = false
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
