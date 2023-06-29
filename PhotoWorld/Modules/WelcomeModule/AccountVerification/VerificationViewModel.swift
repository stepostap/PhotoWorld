//
//  VerificationViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import SwiftUI
import Combine
import SendbirdUIKit

enum CodeEnterState {
    case editing
    case invalid
}

protocol CodeVerificationSuccessProtocol {
    func CodeVerificationSuccess()
}

protocol VerificationViewModelIO: ObservableObject {
    func requestNewCode()
    func sendCode()
    var timeTillNewCode: Int {get set}
    var codeEnterState: CodeEnterState {get set}
    var email: String {get set}
    var insertedCode: String {get set}
}

class VerificationViewModel: VerificationViewModelIO {
    @Published var timeTillNewCode = 59
    @Published var codeEnterState = CodeEnterState.editing
    var insertedCode: String = "123456" {
        didSet {
            codeEnterState = .editing
        }
    }
    var email: String
    var timer: Timer?
    var codeVerificationSuccess: CodeVerificationSuccessProtocol
    let authService = AuthService()
    var cancellable: AnyCancellable?
    var resolver: Resolver?
    
    public init(codeVerificationSuccess: CodeVerificationSuccessProtocol, email: String, resolver: Resolver? = nil) {
        self.codeVerificationSuccess = codeVerificationSuccess
        self.email = email
        self.resolver = resolver
        createTimer()
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func updateTimer() {
        timeTillNewCode -= 1
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timeTillNewCode = 59
        createTimer()
    }
    
    func requestNewCode() {
        resetTimer()
    }
    
    func sendCode() {
        cancellable = authService.getVerificationPublisher(info: VerificationInfo(email: email, activation_code: insertedCode))
            .sink(receiveCompletion: { res in
                print(res)
            }, receiveValue: { response in
                print(response)
                if response.statusCode > 299 {
                    do {
                        let error = try JSONDecoder().decode(ServerError.self, from: response.data)
                        if error.message == "Activation code is not valid" {
                            self.codeEnterState = .invalid
                        }
                    } catch {}
                } else {
                    do {
                        let token = try JSONDecoder().decode(Token.self, from: response.data)
                        self.initSendBird(token: token)
                        self.resolver!.register(type: NetworkServicesFactory.self, {
                            NetworkServicesFactory(token: token.session_token)
                        })
                        self.codeVerificationSuccess.CodeVerificationSuccess()
                    } catch {
                        print(error)
                    }
                }
            })
    }

    
    func initSendBird(token: Token) {
        SBUGlobals.accessToken = token.chat_access_token
        SendbirdUI.initialize(applicationId: token.chat_app_id) {
               // Do something to display the start of the SendbirdUIKit initialization.
           } migrationHandler: {
               // Do something to display the progress of the DB migration.
           } completionHandler: { error in
               print(error)
           }
        
        SBUGlobals.currentUser = SBUUser(userId: token.chat_user_id, nickname: token.username)
    }
}
