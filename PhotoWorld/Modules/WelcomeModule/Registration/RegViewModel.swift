//
//  RegViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 17.04.2023.
//

import Foundation
import UIKit
import Combine

protocol RegViewModelIO: ObservableObject {
    func createAccount()
    func logInWithGoogle()
    func goToLogIn()
    var name: String {get set}
    var email: String {get set}
    var password: String {get set}
    var repeatPassword: String {get set}
    var passwordStatus: PasswordStatus {get set}
    var emailInputStatus: InputTextFieldState {get set}
    var nameInputStatus: InputTextFieldState {get set}
    var rememberUser: Bool {get set}
}

class RegViewModel<T: WelcomeModuleFlowCoordinatorOutput>: ViewModelProtocol, RegViewModelIO {
    
    typealias errorPresenter = T
    
    internal init(moduleOutput: T) {
        self.moduleOutput = moduleOutput
    }
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var passwordStatus = PasswordStatus.valid
    @Published var emailInputStatus = InputTextFieldState.valid
    @Published var nameInputStatus = InputTextFieldState.valid
    @Published var rememberUser = false
    var moduleOutput: T
    let authService = AuthService()
    var cancellable: AnyCancellable?
    
    func forgotPassword() {
    
    }
    
    func createAccount()  {
//        if !StringValidator.isEmailValid(email) {
//            emailInputStatus = .invalid("Неверный формат почты")
//        }
//
//        if password.isEmpty {
//            passwordStatus = .empty
//        }
//        else if !StringValidator.isPasswordValid(password) {
//            passwordStatus = .weakPassword
//        } else if password != repeatPassword {
//            passwordStatus = .samePassword
//        }
//
//        if name.isEmpty {
//            nameInputStatus = .invalid("Введите имя")
//        }
//        
        if passwordStatus == .valid && emailInputStatus == .valid && nameInputStatus == .valid {
            cancellable = authService.getRegistationPublisher(refInfo: RegInfo(name: name, email: email, password: password))
                .sink(receiveCompletion: { res in
                    self.checkComplition(res: res)
                }, receiveValue: { response in
                    print(response)
                    if response.statusCode > 299 {
                        self.showResponseError(response: response)
                    } else {
                        self.moduleOutput.openAccountVerification(name: self.name, email: self.email)
                        AuthInfo.currentUserEmail = self.email
                    }
                })
        }
        
        // self.moduleOutput.openAccountVerification(email: self.email)
    }
    
    func logInWithGoogle() {
        
    }
    
    func goToLogIn() {
        moduleOutput.openLogin()
    }
}
