import SwiftUI

struct FullScreenAnimatedMeshGradient: View {
    @State private var isActive = false
    @State private var isExpanded = false
    var body: some View {
            TimelineView(.animation) { context in
                let s = context.date.timeIntervalSince1970
                let v = Float(sin(s)) / 4 / 2
                
                MeshGradient(
                    width: 3,
                    height: 2,
                    points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 1.0], [0.5 + v, 1.0 ], [1.0, 1.0]
                    ],
                    colors: [
                        .red, .pink, .orange,
                        .orange, .purple, .yellow
                    ]
                )
                
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
                .ignoresSafeArea(.all)
                
                
            }
            
            }

    
}

#Preview {
    FullScreenAnimatedMeshGradient()
}
