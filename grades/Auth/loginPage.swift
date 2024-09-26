import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @State private var isSigningUp = false
    @Binding var showLoginView: Bool
    
    @StateObject private var viewModel = signInViewModel()
    
    let backgroundColor = Color(red: 0.2, green: 0.5, blue: 0.8) // Darker sky blue
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Gold accent
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all).opacity(0.82)
            
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(accentColor)
                    
                    Text("GradePoint")
                        .font(.custom("ProductSans-Bold", size: 40))
                        .foregroundColor(.white)
                }
                
                
                VStack(spacing: 20) {
                    TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    VStack {
                        SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))                        .textFieldStyle(ModernTextFieldStyle())
                        HStack {
                            Button {
                                // place here
                            } label: {
                                Text("Forgot password?")
                                    .padding(.leading, 15)
                                    .font(.custom("ProductSans-Regular", size: 13))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signIn()
                                showLoginView = false
                            } catch {
                                print("error \(error)")
                            }
                        }
                    }) {
                        Text("Log In")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(backgroundColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 1, alignment: .leading)
                        Text("or")
                            .foregroundStyle(.white)
                            .font(.custom("ProductSans-Regular", size: 16))
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 1, alignment: .leading)
                    }
                    
                    Button(action: {
                        isSigningUp.toggle()
                    }) {
                        Text("Sign Up")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(backgroundColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showLoginView = false
                            } catch {
                                print("error \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Image("googleLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                            Text("Sign in with Google")
                                .font(.custom("ProductSans-Bold", size: 18))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                
//                Text("Learning is just a tap away!")
//                    .font(.system(size: 16, weight: .medium, design: .rounded))
//                    .foregroundColor(.white)
//                    .padding(.top)
            }
            .padding(.horizontal, 30)
        }
        .fullScreenCover(isPresented: $isSigningUp) {
            SignUpView(showSignUpView: $isSigningUp, showLoginView: $showLoginView)
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 0.2, green: 0.5, blue: 0.8))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .foregroundStyle(.white)
            .font(.custom("ProductSans-Regular", size: 16))
            .tint(.white)
    }
}

#Preview {
    LoginView(showLoginView: .constant(true))
}
