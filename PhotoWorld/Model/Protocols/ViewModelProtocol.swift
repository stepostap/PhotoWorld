//
//  ViewModelProtocol.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation
import Moya
import Combine

protocol ViewModelProtocol: ObservableObject {
    associatedtype errorPresenter: ErrorPresenter
    var moduleOutput: errorPresenter { get }
}

extension ViewModelProtocol {
    func showResponseError(response: Response) {
        do {
            let error = try JSONDecoder().decode(ServerError.self, from: response.data)
            self.moduleOutput.showAlert(error: NetworkError(code: response.statusCode))
            print(error)
        } catch {
            self.moduleOutput.showAlert(error: NetworkError.decodingError)
        }
    }
    
    func checkComplition(res: Subscribers.Completion<MoyaError>, completion: (()->Void)? = nil) {
        switch res {
        case .failure(let error):
            self.moduleOutput.showAlert(error: NetworkError.noAnswer)
            print(error)
        case .finished:
            completion?()
        }
    }
}
