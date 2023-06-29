//
//  EnterCodeViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation

protocol EnterNewPasswordViewModelIO: ObservableObject {
    var password: String {get set}
    var repeatPassword: String {get set}
    var passwordStatus: PasswordStatus {get set}
    func canSend() -> Bool
    func sendPassword()
}

class EnterNewPasswordViewModel: EnterNewPasswordViewModelIO {
    internal init(resetPasswordModuleOutput: ResetPasswordModuleOutput) {
        self.resetPasswordModuleOutput = resetPasswordModuleOutput
    }
    
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var passwordStatus = PasswordStatus.valid
    private let resetPasswordModuleOutput: ResetPasswordModuleOutput
    
    func canSend() -> Bool {
        return !password.isEmpty && !repeatPassword.isEmpty && passwordStatus == .valid
    }
    
    func checkPasswords() {
        
    }
    
    func sendPassword() {
        if !StringValidator.isPasswordValid(password) {
            passwordStatus = .weakPassword
            return
        } else if password != repeatPassword {
            passwordStatus = .samePassword
            return
        }
        
        resetPasswordModuleOutput.changePasswordSuccess()
    }
}
