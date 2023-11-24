//
//  AuthenticationView.swift
//  Showroom
//
//  Created by Luka Lešić on 23.11.2023..
//

import SwiftUI

enum AuthenticationScreen: String {
    case login = "Login"
    case registration = "Registration"
}

struct AuthenticationView: View {
    @State var viewModel = AuthenticationViewModel()
    @State private var currentAuthScreen = AuthenticationScreen.login
    
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager

    var body: some View {
        if (viewModel.isLoggedIn) {
            ObjectsView()
                .environment(manager)
        } else {
                mainLoginViewBody()
            
                .alert("\(viewModel.errorMessage)", isPresented: $viewModel.hasError) {
                    Button("OK", role: .cancel) { }
                }
        }
    }
}

private extension AuthenticationView {
    
    @ViewBuilder
    func mainLoginViewBody() -> some View {
        VStack(spacing: 1) {
            Spacer()
            titleText()
            Spacer()
            emailField()
            passwordField()
            Spacer()
            switch self.currentAuthScreen {
            case .login:
                loginButton()
                registrationViewLink()
                    .padding(.top, 15)

            case .registration:
                registerButton()
                loginViewLink()
                    .padding(.top, 15)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func titleText() -> some View {
        Text(self.currentAuthScreen.rawValue)
            .font(.extraLargeTitle)
    }
    
    @ViewBuilder
    func emailField() -> some View {
        TextField("Email", text: $viewModel.email)
            .frame(width: 400)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
    
    @ViewBuilder
    func passwordField() -> some View {
        SecureField("Password", text: $viewModel.password)
            .textFieldStyle(.roundedBorder)
            .frame(width: 400)
            .padding(.top, 15)
            .disableAutocorrection(true)
    }
    
    @ViewBuilder
    func loginButton() -> some View {
        Button {
            Task {
                await viewModel.signIn()
            }
        } label: {
            Text("Login")
        }
    }
    
    @ViewBuilder
    func registerButton() -> some View {
        Button {
            Task {
                await viewModel.signUp()
            }
        } label: {
            Text("Register")
        }
    }
    
    @ViewBuilder
    func registrationViewLink() -> some View {
        Button {
            withAnimation {
                self.currentAuthScreen = .registration
                viewModel.resetInputFields()
            }
        } label: {
            Text("Register a new account")
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func loginViewLink() -> some View {
        Button {
            withAnimation {
                self.currentAuthScreen = .login
                viewModel.resetInputFields()
            }
        } label: {
            Text("Login with existing account")
        }
        .buttonStyle(.plain)
    }

}
