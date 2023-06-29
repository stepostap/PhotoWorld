//
//  LoginViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation
import Combine
import Moya
import SendbirdUIKit

protocol LoginViewModelIO: ObservableObject {
    func forgotPassword()
    func createAccount()
    func logIn()
    func logInWithGoogle() 
    var email: String {get set}
    var password: String {get set}
    var passwordStatus: PasswordStatus {get set}
    var emailInputStatus: InputTextFieldState {get set}
    var rememberUser: Bool {get set}
}

class LoginViewModel<coordinator: WelcomeModuleFlowCoordinatorOutput>: ViewModelProtocol, LoginViewModelIO {
    typealias errorPresenter = coordinator
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordStatus = PasswordStatus.valid
    @Published var emailInputStatus = InputTextFieldState.valid
    @Published var rememberUser = false

    let moduleOutput: coordinator
    let authService: AuthService
    var resolver: Resolver
    var bag: [AnyCancellable] = []
    
    internal init(moduleOutput: coordinator,
                  authService: AuthService,
                  resolver: Resolver) {
        self.moduleOutput = moduleOutput
        self.authService = authService
        self.resolver = resolver
    }
    
    func forgotPassword() {
        moduleOutput.openResetPasswordFlow()
    }
    
    func createAccount()  {
        moduleOutput.openRegistration()
    }
    
    func logInWithGoogle() {
        
    }
    
    
    func logIn() {
        if email.isEmpty {
            emailInputStatus = .invalid("Введите почту")
        } else if !StringValidator.isEmailValid(email) {
            emailInputStatus = .invalid("Неверный формат почты")
        }
        
        if password.isEmpty {
            passwordStatus = .empty
        }

        if emailInputStatus == .valid {
            authService.getAuthentificationPublisher(authInfo: AuthInfo(email: email, password: password)).sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        let token = try JSONDecoder().decode(Token.self, from: response.data)
                        AuthInfo.currentUserEmail = self.email
                        self.initSendBird(token: token)
                        self.resolver.register(type: NetworkServicesFactory.self, { NetworkServicesFactory(token: token.session_token) })
                        self.getProfilesInfo(token: token.session_token)
                    } catch {
                        print(error)
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            }).store(in: &bag)
        }
    }
    
    
    func getProfilesInfo(token: String) {
        let accountService = AccountService(token: token)
        accountService.getUserProfilesPublisher().sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let profiles = try JSONDecoder().decode(UserProfiles.self, from: response.data)
                    self.getSingleProfile(profiles: profiles, accountService: accountService)
                } catch {
                    print(error)
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    
    func getSingleProfile(profiles: UserProfiles, accountService: AccountService) {
        var type: ProfileType = .model
        if let _ = profiles.profileTypes[.photographer] {
            type = .photographer
        } else if let _ = profiles.profileTypes[.stylist] {
            type = .stylist
        }
        
        accountService.getUserProfile(type: type).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let profileInfo = try JSONDecoder().decode(AccountRKO.self, from: response.data)
                    let account = Account(avaURL: profiles.profileTypes[type]?.avatar_url,
                                          accountRKO: profileInfo,
                                          type: type)
                    ProfileType.currentUserType = account.type
                    self.moduleOutput.loggedIn(account: account)
                } catch {
                    print(error)
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
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
