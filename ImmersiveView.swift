//
//  ImmersiveView.swift
//  MyFirstImmersive
//
//  O sistema solar imersivo — Sol + planetas + estrelas + anéis + Lua.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {

    @State private var tempoDecorrido: Float = 0

    // Cores mais ricas e realistas pros planetas.
    private let planetas: [(nome: String, cor: UIColor, raio: Float, distancia: Float, velocidade: Float)] = [
        ("Mercurio", UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1), 0.04, 0.50, 1.6),
        ("Venus",    UIColor(red: 0.95, green: 0.65, blue: 0.30, alpha: 1), 0.07, 0.75, 1.2),
        ("Terra",    UIColor(red: 0.20, green: 0.45, blue: 0.85, alpha: 1), 0.08, 1.00, 1.0),
        ("Marte",    UIColor(red: 0.80, green: 0.30, blue: 0.20, alpha: 1), 0.06, 1.30, 0.8),
        ("Jupiter",  UIColor(red: 0.85, green: 0.60, blue: 0.40, alpha: 1), 0.16, 1.70, 0.4),
        ("Saturno",  UIColor(red: 0.90, green: 0.80, blue: 0.50, alpha: 1), 0.13, 2.10, 0.3),
    ]

    var body: some View {
        RealityView { content in
            // === CENTRO DO SISTEMA SOLAR ===
            let centro = Entity()
            centro.name = "centroSolar"
            centro.position = [0, 1.5, -1.5]
            content.add(centro)

            // === SOL com material UNLIT (sempre brilha, igual uma estrela) ===
            let sol = ModelEntity(
                mesh: .generateSphere(radius: 0.22),
                materials: [UnlitMaterial(color: .systemYellow)]
            )
            sol.name = "sol"
            centro.addChild(sol)

            // === PLANETAS + PIVÔS ===
            for config in planetas {
                let pivot = Entity()
                pivot.name = "pivot_\(config.nome)"

                let planeta = ModelEntity(
                    mesh: .generateSphere(radius: config.raio),
                    materials: [SimpleMaterial(color: config.cor, isMetallic: false)]
                )
                planeta.position = [config.distancia, 0, 0]
                planeta.name = "planeta_\(config.nome)"

                // 💫 ANÉIS DO SATURNO
                // Um cilindro super-achatado (3mm de altura) cercando Saturno.
                if config.nome == "Saturno" {
                    let aneis = ModelEntity(
                        mesh: .generateCylinder(height: 0.003, radius: config.raio * 2.4),
                        materials: [SimpleMaterial(
                            color: UIColor(red: 0.85, green: 0.75, blue: 0.55, alpha: 1),
                            isMetallic: false
                        )]
                    )
                    // Inclina os anéis (parecido com o Saturno real).
                    aneis.transform.rotation = simd_quatf(angle: 0.35, axis: [1, 0, 0])
                    planeta.addChild(aneis)
                }

                // 🌙 LUA orbitando a Terra (BÔNUS!)
                if config.nome == "Terra" {
                    let luaPivot = Entity()
                    luaPivot.name = "luaPivot"

                    let lua = ModelEntity(
                        mesh: .generateSphere(radius: 0.025),
                        materials: [SimpleMaterial(color: .lightGray, isMetallic: false)]
                    )
                    // Lua a 8cm da Terra.
                    lua.position = [config.raio + 0.08, 0, 0]
                    luaPivot.addChild(lua)
                    planeta.addChild(luaPivot)
                }

                pivot.addChild(planeta)
                centro.addChild(pivot)
            }

            // === ESTRELAS NO FUNDO ===
            // 200 esferas brancas pequenas, espalhadas numa esfera ao redor do usuário.
            let estrelas = Entity()
            estrelas.name = "estrelas"
            estrelas.position = [0, 1.5, 0]   // centra na altura dos olhos do usuário

            for _ in 0..<200 {
                // Posição aleatória numa esfera — coordenadas esféricas.
                let theta = Float.random(in: 0..<(2 * .pi))
                let phi = Float.random(in: 0.1..<(.pi - 0.1))
                let distancia = Float.random(in: 4...8)

                let x = distancia * sin(phi) * cos(theta)
                let y = distancia * cos(phi)
                let z = distancia * sin(phi) * sin(theta)

                let estrela = ModelEntity(
                    mesh: .generateSphere(radius: Float.random(in: 0.008...0.025)),
                    materials: [UnlitMaterial(color: .white)]
                )
                estrela.position = [x, y, z]
                estrelas.addChild(estrela)
            }
            content.add(estrelas)

        } update: { content in
            // Acha o centro do sistema solar pelo nome.
            guard let centro = content.entities.first(where: { $0.name == "centroSolar" }) else { return }

            // Roda os pivôs (planetas orbitando o Sol).
            for config in planetas {
                if let pivot = centro.findEntity(named: "pivot_\(config.nome)") {
                    pivot.transform.rotation = simd_quatf(
                        angle: tempoDecorrido * config.velocidade,
                        axis: [0, 1, 0]
                    )
                }
            }

            // 🌙 Lua orbita a Terra (3x mais rápido que a Terra orbita o Sol).
            if let luaPivot = centro.findEntity(named: "luaPivot") {
                luaPivot.transform.rotation = simd_quatf(
                    angle: tempoDecorrido * 3.0,
                    axis: [0, 1, 0]
                )
            }

            // Sol gira no próprio eixo, lento.
            if let sol = centro.findEntity(named: "sol") {
                sol.transform.rotation = simd_quatf(angle: tempoDecorrido * 0.2, axis: [0, 1, 0])
            }
        }
        .task {
            // Loop que faz o tempo correr (60fps).
            let inicio = Date()
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(16))
                tempoDecorrido = Float(Date().timeIntervalSince(inicio))
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
