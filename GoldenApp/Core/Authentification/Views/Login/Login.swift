import SwiftUI

struct Login: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedMeshGradient()
                    .opacity(0.9)
                    .transition(.opacity)
                    .offset(y: -200)
                
                VStack(spacing: 20) {
                    
                    
                    // App Title
                    Text("Golden")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .padding(.bottom, 20)
                    Spacer()
                    // Username Field
                    HStack{
                        Text("Login")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                        TextField("Username, email or mobile number", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    
                    // Password Field
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                        SecureField("Password", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    
                    
                    
                    // Forgot Password Link
                    HStack{
                        NavigationLink {
                            Text("Reset password page")
                        } label: {
                            Text("Forgot password?")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    Spacer()
                    // Log In Button
                    HStack {
                        
                        Button {
                            print("Sign in pressed")
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(.blue.opacity(1))
                                    .glassEffect()
                                    .clipShape(Capsule())
                                    .frame(width: 150, height: 50)
                                Text("Log In")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                            }
                        }
                    }
                    
                    // Sign Up Link
                    NavigationLink(destination: Signup()) {
                        Text("Don't have an Account? Sign up")
                            .font(.system(size: 12, weight: .regular))
                    }
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    Login()
}
