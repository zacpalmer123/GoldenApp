import SwiftUI

struct AnimatedMeshGradient: View {
    @State private var isActive = false
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            TimelineView(.animation) { context in
                let s = context.date.timeIntervalSince1970
                let v = Float(sin(s)) / 4 / 6
                let dynamicColor = colorScheme == .dark ? Color.black : Color.white
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 0.5 ], [0.5 + v, 0.5 - v], [1.0, 0.5],
                        [0.0, 1.0], [0.7 - v, 1.0], [1.0, 1.0],
                    ],
                    colors: [
                        isActive ? .orange : .purple, isActive ? .red : .pink,  isActive ? .purple : .orange,
                        dynamicColor, dynamicColor, dynamicColor,
                            dynamicColor, dynamicColor, dynamicColor
                    ]
                )
                .ignoresSafeArea()
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    isActive = true
                }
            }
                
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    AnimatedMeshGradient()
}
