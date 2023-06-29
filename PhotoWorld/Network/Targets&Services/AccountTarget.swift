//
//  AccountTarget.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 06.05.2023.
//

import Foundation
import Moya
import CombineMoya
import Combine

enum AccountEndpoints {
    case getTags(forType: ProfileType, token: String)
    case getServices(forType: ProfileType, token: String)
    case createAlbum(forType: ProfileType, album: AlbumbCreationRKO, token: String)
    case addPhotosToAlbum(type: ProfileType, albumName: String, photoURLS: AlbumPhotosUploadiingRKO, token: String)
    case getAlbumPhotos(type: ProfileType, albumName: String, token: String)
    case createAccount(account: Account, token: String)
    case createComment(comment: CommentCretionInfo, email: String, type: ProfileType, token: String)
    case getUserAccountInfo(type: ProfileType, token: String)
    case getAccountInfo(email: String, type: ProfileType, token: String)
    case getUserProfiles(token: String)
    case getChatURL(email: String, token: String)
}

extension AccountEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: "http://212.109.195.151:9090/api/v1/profiles")!
    }
    
    var path: String {
        switch self {
        case .getTags(let forType, _):
            return "/\(forType.networkTitle)/tags"
        case .getServices(let forType, _):
            return "/\(forType.networkTitle)/services"
        case .createAlbum(let forType, _, _):
            return "/\(forType.networkTitle)/albums"
        case .createAccount(let account, _):
            return "/\(account.type.networkTitle)"
        case .createComment(_, email: let email, type: let type, _):
            return "/\(email)/\(type.networkTitle)/comments"
        case .getUserAccountInfo(type: let type, _):
            return "/\(type.networkTitle)"
        case .getAccountInfo(email: let email, type: let type, _):
            return "/\(email)/\(type.networkTitle)/info"
        case .getUserProfiles:
            return ""
        case .getChatURL(email: let email, _):
            return "/\(email)/chat"
        case .addPhotosToAlbum(type: let type, albumName: let albumName, _, _):
            return "/\(type.networkTitle)/albums/\(albumName)/photos"
        case .getAlbumPhotos(type: let type, albumName: let albumName, _):
            return "/\(type.networkTitle)/albums/\(albumName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTags, .getServices, .getAccountInfo, .getUserAccountInfo, .getUserProfiles, .getChatURL, .getAlbumPhotos:
            return .get
        case .createAlbum, .createAccount, .createComment, .addPhotosToAlbum:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getTags, .getServices, .getUserAccountInfo, .getAccountInfo, .getUserProfiles, .getChatURL, .getAlbumPhotos:
            return .requestPlain
        case .createAlbum(forType: _, album: let album, _):
            let data = try! JSONEncoder().encode(album)
            return .requestData(data)
        case .createAccount(account: let account, token: _):
            let rko = PhotographerProfileRKO(account: account)
            let data = try! JSONEncoder().encode(rko)
            return .requestData(data)
        case .createComment(comment: let comment, _, _, _):
            let data = try! JSONEncoder().encode(comment)
            return .requestData(data)
        case .addPhotosToAlbum(_,_,photoURLS: let photoURLS,_):
            let data = try! JSONEncoder().encode(photoURLS)
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getTags(_, let token), .getServices(_, let token), .getUserProfiles(token: let token),
                .createAlbum(_, _, let token), .createAccount(_, let token), .createComment(_, _, _, token: let token), .getUserAccountInfo(_, token: let token), .getAccountInfo(_, _, token: let token), .getChatURL(_, token: let token), .getAlbumPhotos(_,_, let token), .addPhotosToAlbum(_, _, _, let token):
            return ["Content-Type": "application/json", "Accept": "application/json", "Authorization":"Bearer \(token)"]
        }
    }
}

class AccountService {
    internal init(token: String) {
        self.token = token
    }
    
    let token: String
    //plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))]
    let provider = MoyaProvider<AccountEndpoints>()
    
    func getTagsPublisher(forType: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getTags(forType: forType, token: token)).eraseToAnyPublisher()
    }
    
    func getServicesPublisher(forType: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getServices(forType: forType, token: token)).eraseToAnyPublisher()
    }
    
    func getCreateAlbumPublsiher(forType: ProfileType, album: Album) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.createAlbum(forType: forType, album: AlbumbCreationRKO(album: album), token: token))
    }
    
    func getProfileCreationPublisher(account: Account) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.createAccount(account: account, token: token))
    }
    
    func createCommentPublisher(comment: CommentCretionInfo,
                                receiverEmail: String,
                                receiverType: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.createComment(comment: comment,
                                                        email: receiverEmail,
                                                        type: receiverType,
                                                        token: token))
    }
    
    func getUserProfilesPublisher() -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getUserProfiles(token: token))
    }
    
    func getProfileInfo(email: String, type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getAccountInfo(email: email, type: type, token: token))
    }
    
    func getUserProfile(type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getUserAccountInfo(type: type, token: token))
    }
    
    func getChatURL(email: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getChatURL(email: email, token: token))
    }
    
    func getAlbumPhotosPublisher(albumName: String, type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getAlbumPhotos(type: type, albumName: albumName, token: token))
    }
    
    func uploadPhotosToAlbum(photos: [URL], albumName: String, type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.addPhotosToAlbum(type: type, albumName: albumName,
                                                           photoURLS: AlbumPhotosUploadiingRKO(photos: photos), token: token))
    }
}


