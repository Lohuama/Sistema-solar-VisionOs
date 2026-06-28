# 🪐 Sistema Solar — visionOS

Um app imersivo para Apple Vision Pro onde você fica **no centro do sistema solar** e vê os planetas orbitando ao seu redor — com Sol brilhando, anéis no Saturno, Lua orbitando a Terra e um céu estrelado.

Meu primeiro projeto em **visionOS / RealityKit**, feito num fim de semana para aprender spatial computing.

---

## ✨ Funcionalidades

- ☀️ **Sol** com material emissivo (brilha sozinho, sem depender de luz)
- 🪐 **6 planetas** (Mercúrio → Saturno) orbitando em velocidades diferentes
- 💫 **Anéis no Saturno** (cilindro super-achatado inclinado)
- 🌙 **Lua** orbitando a Terra em escala menor
- ⭐ **200 estrelas** espalhadas ao redor do usuário usando coordenadas esféricas
- 🎛️ **Painel volumétrico** com botão para abrir / fechar o sistema solar

## 🛠️ Tecnologias

- **Swift** + **SwiftUI**
- **RealityKit** para o conteúdo 3D
- **ImmersiveSpace** (`.mixed` style) para colocar o sistema solar dentro do seu ambiente real
- **Volumetric Window** para o painel de controle 3D

## 🏗️ Estrutura do projeto

```
MyFirstImmersive/
├── MyFirstImmersiveApp.swift   # Configura WindowGroup + ImmersiveSpace
├── ContentView.swift           # Painel volumétrico (título + botão)
└── ImmersiveView.swift         # O sistema solar (Sol, planetas, anéis, Lua, estrelas)
```

## 🎓 Conceitos aprendidos

- Diferença entre **Window**, **Volume** e **ImmersiveSpace** no visionOS
- Coordenadas 3D (eixo Z negativo é "pra frente")
- Hierarquia de entidades (parent/child) e o "truque do pivô" para criar órbitas
- Materiais: `SimpleMaterial` (recebe luz) vs `UnlitMaterial` (brilha sozinho)
- Animação contínua usando `@State` + `.task` + `simd_quatf` para rotações
- Distribuição uniforme de pontos em uma esfera (coordenadas esféricas)

## ▶️ Como rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/Lohuama/Sistema-solar-VisionOs.git
   ```
2. Abra `MyFirstImmersive.xcodeproj` no Xcode (16 ou superior)
3. Selecione o simulador **Apple Vision Pro** (ou um dispositivo real)
4. Aperte **▶️ Run** (`Cmd + R`)
5. Quando o painel "Meu Sistema Solar" aparecer, clique em **Abrir Sistema Solar**
6. Olhe ao redor — os planetas estão orbitando você! 🚀

## 🌌 Próximos passos

- [ ] Aplicar texturas reais da NASA nos planetas
- [ ] Adicionar trilhas das órbitas (linhas circulares)
- [ ] Som ambiente espacial
- [ ] Controle de velocidade da animação
- [ ] Mais corpos celestes (Urano, Netuno, Plutão)

## 👩🏻‍💻 Autora

**Lohuama Lima** — projeto de fim de semana 🌙

Feito para sair do automático e explorar o universo do spatial computing.
