import SwiftUI

struct HomeYesterday: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(11..<20, id: \.self){ _ in
                    UserPostYesterday()
                }
            }
        }
    }
}



struct UserPostYesterday2: View {
    var body: some View {
        Text("Yesterday's post")
    }
}
