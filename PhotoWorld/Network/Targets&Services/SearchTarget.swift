//
//  SearchTarget.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import Moya
import CombineMoya
import Combine

enum SearchTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://212.109.195.151:9090/api/v1/search")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return Method.post
    }
    
    var task: Task {
        switch self {
        case .search(let query, _):
            let data = try! JSONEncoder().encode(query)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .search(_, let token):
            return ["Content-Type": "application/json", "Accept": "application/json", "Authorization":"Bearer \(token)"]
        }
    }
    
    case search(query: SearchInfo, token: String)
}

class SearchService {
    internal init(token: String) {
        self.token = token
    }
    
    let token: String
    let provider = MoyaProvider<SearchTarget>()
    
    func getSearchPublisher(query: SearchInfo) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.search(query: query, token: token)).eraseToAnyPublisher()
    }
}
