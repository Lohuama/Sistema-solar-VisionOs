//
//  ContentView.swift
//  MyFirstImmersive
//
//  Created by Lohuama Lima on 27/06/26.
//

import SwiftUI

struct ContentView: View {

    @State private var sistemaSolarOpen = false

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack(spacing: 24) {
            Text("Meu Sistema Solar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.yellow)

            Text(sistemaSolarOpen
                 ? "Olhe ao redor — os planetas estão orbitando você!"
                 : "Toque no botão para mergulhar no sistema solar.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                Task {
                    if sistemaSolarOpen {
                        await dismissImmersiveSpace()
                        sistemaSolarOpen = false
                    } else {
                        switch await openImmersiveSpace(id: "Sistema Solar") {
                        case .opened:
                            sistemaSolarOpen = true
                        case .error, .userCancelled:
                            sistemaSolarOpen = false
                        @unknown default:
                            sistemaSolarOpen = false
                        }
                    }
                }
            } label: {
                Text(sistemaSolarOpen ? "Fechar Sistema Solar" : "Abrir Sistema Solar")
                    .font(.title2)
                    .padding(.horizontal)
            }
            .fontWeight(.semibold)
        }
        .padding(40)
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
