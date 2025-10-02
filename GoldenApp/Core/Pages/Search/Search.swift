import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let username: String
}

struct Search: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText: String = ""

    private let friends: [Friend] = [
        Friend(name: "Josh Powers", imageName: "profile1", username: "joshua44"),
        Friend(name: "Jack Malo", imageName: "profile1", username: "jackmalo32"),
        Friend(name: "Zac Palmer", imageName: "profile1", username: "zacpalmer1"),
        Friend(name: "Lee Eberly", imageName: "profile1", username: "leeeberly"),
        Friend(name: "Kennedy Seigler", imageName: "profile1", username: "kennseigler2"),
        Friend(name: "Davis Cooney", imageName: "profile1", username: "davis47"),
        Friend(name: "Zachary Palmer", imageName: "profile1", username: "zachary32")
    ]

    // 🔍 Filter friends by username only (not sorted)
    private var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter {
                $0.username.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 13) {
                HStack{
                    
                    Text("Recently Searched")
                        .font(.default).bold()
                        
                    Spacer()
                    Text("Clear")
                        .font(.default)
                        .foregroundColor(.red)
                }
                .padding(.top, 120)
                ForEach(filteredFriends) { friend in
                    Divider()
                    HStack {
                        Image(friend.imageName)
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(friend.name)
                                .font(.default)
                                .foregroundColor(.primary)
                                .padding(.bottom, 0.2)
                            Text("@\(friend.username)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by username"
        )
    }
}

#Preview {
    Search()
}
