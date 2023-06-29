//
//  EnterEmailViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation

protocol EnterEmailViewModelIO: ObservableObject {
    var email: String {get set}
    var emailInputState: InputTextFieldState {get set}
    func sendCode()
}

class EnterEmailViewModel: EnterEmailViewModelIO {
    internal init(resetPasswordModuleOutput: ResetPasswordModuleOutput) {
        self.resetPasswordModuleOutput = resetPasswordModuleOutput
    }
    
    @Published var email = ""
    @Published var emailInputState: InputTextFieldState = .valid
    private let resetPasswordModuleOutput: ResetPasswordModuleOutput
    
    func sendCode() {
        if !StringValidator.isEmailValid(email) {
            emailInputState = .invalid("Неверно введен email")
            return
        }
        resetPasswordModuleOutput.commmitEmail(email: email)
    }
}
