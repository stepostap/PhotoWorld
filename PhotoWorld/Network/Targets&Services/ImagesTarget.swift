//
//  ImagesTarget.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 08.05.2023.
//

import Foundation
import Moya
import UIKit
import CombineMoya
import Combine

enum ImageEndpoints: TargetType {
    case upload(image: UIImage, id: String, token: String)
    case delete(url: String, token: String)
        
    var baseURL: URL {
        return URL(string: "http://212.109.195.151:9090/api/v1/images")!
    }
    
    var path: String {
        switch self {
        case .delete:
            return "/delete"
        case .upload:
            return "/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .delete:
            return .delete
        case .upload:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .delete(let url, _):
            let data = try! JSONEncoder().encode(ImageURL(image_url: url))
            return .requestData(data)
        case .upload(let image, let id, _):
//            let boundary = "Boundary-\(id)"
//            let data = createBody(boundary: boundary,
//                                  data: image.jpegData(compressionQuality: 0.7)!,
//                                  mimeType: "image/jpg",
//                                  fileName: "image.jpg")
//            return .requestData(data!)
            let imageData = image.jpegData(compressionQuality: 0.5)
            let memberIdData = id.data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormBodyPart] = [Moya.MultipartFormBodyPart(provider: .data(imageData!), name: "file", fileName: "image.jpeg", mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormBodyPart(provider: .data(memberIdData), name: "member_id"))
            return .uploadMultipartFormData(MultipartFormData(parts: formData))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .delete(_, let token):
            return ["Content-Type": "application/json", "Accept": "application/json", "Authorization":"Bearer \(token)"]
        case .upload(_, let id, let token):
            let boundary = "Boundary-\(id)"
            return ["Content-Type": "multipart/form-data; boundary=\(boundary)", "Accept": "application/json", "Authorization":"Bearer \(token)"]
        }
    }
    
    func createBody(boundary: String, data: Data, mimeType: String, fileName: String) -> Data? {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

class ImagesService {
    internal init(token: String) {
        self.token = token
    }
    
    let token: String
    //plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))]
    let provider = MoyaProvider<ImageEndpoints>()
    
    func getUploadImagePublisher(image: UIImage) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.upload(image: image, id: UUID().uuidString, token: token)).eraseToAnyPublisher()
    }
    
    func getDeletePublisher(url: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.delete(url: url, token: token)).eraseToAnyPublisher()
    }
}
