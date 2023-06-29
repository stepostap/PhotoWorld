//
// AuthTarget.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 03.05.2023.
//

import Foundation
import Moya
import CombineMoya
import Combine

enum AuthEndpoints {
    case register(RegInfo)
    case authenticate(AuthInfo)
    case verify(VerificationInfo)
    case repeatVerification(Email)
    case logout(Email)
}

extension AuthEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: "http://212.109.195.151:9090/api/v1/auth")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        case .authenticate:
            return "authenticate"
        case .verify, .repeatVerification:
            return "/verify"
        case .logout:
            return "/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .authenticate, .verify, .repeatVerification:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .register(let regInfo):
            let data = try! JSONEncoder().encode(regInfo)
            return .requestData(data)
        case .authenticate(let authInfo):
            let data = try! JSONEncoder().encode(authInfo)
            return .requestData(data)
        case .verify(let verificationInfo):
            let data = try! JSONEncoder().encode(verificationInfo)
            return .requestData(data)
        case .repeatVerification(let email), .logout(let email):
            let data = try! JSONEncoder().encode(email)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
}

class AuthService {
    var cancellable: AnyCancellable?
    private var bag = Set<AnyCancellable>()
    //
    let provider = MoyaProvider<AuthEndpoints>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])
    
    func getRegistationPublisher(refInfo: RegInfo) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.register(refInfo)).eraseToAnyPublisher()
    }
    
    func resendVerificationPublisher(email: Email) -> AnyPublisher<Response, MoyaError>  {
        return provider.requestPublisher(.repeatVerification(email)).eraseToAnyPublisher()
    }
    
    func getAuthentificationPublisher(authInfo: AuthInfo) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.authenticate(authInfo)).eraseToAnyPublisher()
    }
    
    func getLogoutPublisher(email: Email) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.logout(email)).eraseToAnyPublisher()
    }
    
    func getVerificationPublisher(info: VerificationInfo) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.verify(info)).eraseToAnyPublisher()
    }
}

