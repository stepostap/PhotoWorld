//
//  NetworkError.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation

enum NetworkError {
    case noAnswer
    case decodingError
    case dataError
    case serverError
    case unknownError(code: Int)
    
    public init(code: Int) {
        if code >= 300 && code < 400 {
            self = .unknownError(code: code)
        } else if code < 500 {
            self = .dataError
        } else {
            self = .serverError
        }
    }
    
    var title: String {
        switch self {
        case .noAnswer:
            return "Нет ответа от сервера"
        case .decodingError:
            return "Ошибка в декодировании данных"
        case .dataError:
            return "Неправильный формат входных данных"
        case .serverError:
            return "На сервере произошла ошибка"
        case .unknownError(let code):
            return "Неизвестная ошибка \(code)"
        }
    }
}
