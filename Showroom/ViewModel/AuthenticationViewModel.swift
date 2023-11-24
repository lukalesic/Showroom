//
//  AuthenticationViewModel.swift
//  Showroom
//
//  Created by Luka Lešić on 24.11.2023..
//

import Foundation
import FirebaseAuth

struct User {
    let uid: String
    let email: String
}

@Observable
class AuthenticationViewModel {
    var email: String = ""
    var password: String = ""
    private var _currentUser : User? = nil
    var hasError = false
    var errorMessage = ""
    var isLoggedIn = false
    
    private var handler = Auth.auth().addStateDidChangeListener{ _,_ in }
    
    var currentUser: User {
        return _currentUser ?? User(uid: "", email: "")
    }
    
    init() {
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self._currentUser = User(uid: user.uid, email: user.email!)
                self.isLoggedIn = true
            } else {
                self._currentUser = nil
                self.isLoggedIn = false
            }
        }
    }
    
    func signIn() async {
        hasError = false
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp() async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
    func signOut() async {
        hasError = false
        do {
            try Auth.auth().signOut()
            
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func resetInputFields() {
        self.email = ""
        self.password = ""
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handler)
    }
}
