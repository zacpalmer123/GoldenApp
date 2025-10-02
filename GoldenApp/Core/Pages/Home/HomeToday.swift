import SwiftUI

struct HomeToday: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10, id: \.self){ _ in
                    UserPost()
                }
                .padding(.bottom, 15)
            }
        }
    }
}

struct UserPost2: View {
    var body: some View {
        Text("User Post")
    }
}
