import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

struct LoginView: View {
    @State private var isSigningUp = false
    @Binding var showLoginView: Bool
    
    @StateObject private var viewModel = signInViewModel()
    
    //error handlign
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                VStack(spacing: 15) {
                    VStack(spacing: 10) {
                        Image(systemName: "books.vertical.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.terCol)
                        
                        Text("GradePoint")
                            .font(.custom("ProductSans-Bold", size: 40))
                            .foregroundColor(.secCol)
                    }
                    .padding(.top, 40)
                    
                    
                    VStack(spacing: 20) {
                        TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(16)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .font(.custom("ProductSans-Regular", size: 16))
                            .tint(.white)
                            
                        VStack {
                            SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(16)
                                .foregroundColor(.white)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .tint(.white)
                            HStack {
                                NavigationLink {
                                    
                                    forgotPasswordView()
                                    //                                print("was pressed")
                                } label: {
                                    Text("Forgot password?")
                                        .padding(.leading, 15)
                                        .font(.custom("ProductSans-Regular", size: 13))
                                        .foregroundColor(.secCol.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.signIn()
                                    showLoginView = false
                                } catch {
                                    errorMessage = "An error occurred while signing in: \(error.localizedDescription)"
                                    showError = true
                                }
                            }
                        }) {
                            Text("Log In")
                                .font(.custom("ProductSans-Bold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.terCol)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.secCol.opacity(0.5))
                                .frame(width: 100, height: 1, alignment: .leading)
                            Text("or")
                                .foregroundStyle(.secCol.opacity(0.8))
                                .font(.custom("ProductSans-Regular", size: 16))
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.secCol.opacity(0.5))
                                .frame(width: 100, height: 1, alignment: .leading)
                        }
                        
                        Button(action: {
                            isSigningUp.toggle()
                        }) {
                            Text("Sign Up")
                                .font(.custom("ProductSans-Bold", size: 18))
                                .foregroundColor(.secCol)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.signInGoogle()
                                    showLoginView = false
                                } catch {
                                    errorMessage = "An error occurred while signing in: \(error.localizedDescription)"
                                    showError = true
                                }
                            }
                        }) {
                            HStack {
                                Image("googleLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("Sign in with Google")
                                    .font(.custom("ProductSans-Bold", size: 18))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        Button {
                            Task {
                                do {
                                    try await viewModel.signInApple()
                                } catch {
                                    errorMessage = "An error occurred while signing in: \(error.localizedDescription)"
                                    showError = true
                                }
                            }
                        } label: {
                            HStack {
                                Image("appleLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("Sign in with Apple")
                                    .font(.custom("ProductSans-Bold", size: 18))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        .frame(height: 60)
                        .onChange(of: viewModel.signedInWithApple) { oldValue, newValue in
                            if newValue {
                                showLoginView = false
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 30)
            }
            .fullScreenCover(isPresented: $isSigningUp) {
                SignUpView(showSignUpView: $isSigningUp, showLoginView: $showLoginView)
            }
            //error handlign
            .alert("Error", isPresented: $showError, actions: {
                Button("OK") { showError = false }
            }, message: {
                Text(errorMessage ?? "An unknown error occurred")
            })
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
//            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .foregroundStyle(.white)
            .font(.custom("ProductSans-Regular", size: 16))
            .tint(.white)
    }
}

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

//#Preview {
//    LoginView()
//}
