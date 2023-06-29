//
//  PhotosessionTarget.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import Moya
import CombineMoya
import Combine

enum PhotosessionTarget: TargetType {
    case createPhotosession(photosession: PhotosessionCreationInfo, token: String)
    case getPhotosession(id: String, token: String)
    case getPhotosessions(token: String)
    case getTags(token: String)
    case inviteParticipant(invitationInfo: InvitationInfo, photosessionID: String, token: String)
    case acceptInvite(photosesionId: String, profileType: ProfileType, token: String)
    case declineInvite(photosesionId: String, profileType: ProfileType, token: String)
    case getResultsPhotos(photosessionId: String, token: String)
    case finishPhotosession(photosessionId: String, token: String)
    case addResultPhotos(photosessionId: String, photos: PhotosessionPhotos, token: String)
    
    var baseURL: URL {
        return URL(string: "http://212.109.195.151:9090/api/v1/photosessions")!
    }
    
    var path: String {
        switch self {
        case .acceptInvite(let photosesionId, let profileType, _):
            return "/\(photosesionId)/participants/accept/\(profileType.rawValue)"
        case .createPhotosession( _,  _):
            return ""
        case .declineInvite(let photosesionId, let profileType,  _):
            return "/\(photosesionId)/participants/cancel/\(profileType.networkTitle)"
        case .getPhotosession(let id,  _):
            return "/\(id)"
        case .getPhotosessions(_):
            return ""
        case .getTags(_):
            return "/tags"
        case .inviteParticipant(_, let id, _):
            return "/\(id)/participants/invite"
        case .getResultsPhotos(photosessionId: let photosessionId, _):
            return "/\(photosessionId)/resultPhotos"
        case .finishPhotosession(photosessionId: let photosessionId, _ ):
            return "/\(photosessionId)/finish"
        case .addResultPhotos(let photosessionId, _, _):
            return "/\(photosessionId)/resultPhotos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .acceptInvite, .inviteParticipant, .declineInvite, .finishPhotosession:
            return .post
        case .createPhotosession, .addResultPhotos:
            return .put
        case .getPhotosession, .getPhotosessions, .getTags, .getResultsPhotos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .acceptInvite, .declineInvite, .getPhotosession, .getTags:
            return .requestPlain
        case .createPhotosession(let photosession, _):
            let data = try! JSONEncoder().encode(photosession)
            return .requestData(data)
        case .inviteParticipant(let info, _, _):
            let data = try! JSONEncoder().encode(info)
            return .requestData(data)
        case .getResultsPhotos:
            return .requestPlain
        case .finishPhotosession:
            return .requestPlain
        case .addResultPhotos(_ , photos: let photos, _):
            let data = try! JSONEncoder().encode(photos)
            return .requestData(data)
        case .getPhotosessions:
            return .requestParameters(parameters: ["type":"ALL"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .acceptInvite(_,_,let token), .declineInvite(_,_,let token), .getPhotosession(_, let token), .getPhotosessions(let token), .getTags(let token), .createPhotosession( _,  let token), .inviteParticipant(_,_,let token), .addResultPhotos(_,_,token: let token), .finishPhotosession(_, token: let token), .getResultsPhotos(_, token: let token):
            return ["Content-Type": "application/json", "Accept": "application/json", "Authorization":"Bearer \(token)"]
        }
    }
}

class PhotosessionService {
    
    internal init(token: String) {
        self.token = token
    }
    
    let token: String
    //plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))]
    let provider = MoyaProvider<PhotosessionTarget>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])

    func createPhotosessionPublisher(photosession: PhotosessionCreationInfo) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.createPhotosession(photosession: photosession, token: token))
    }
    
    func getPhotosesionPublisher(id: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getPhotosession(id: id, token: token))
    }
    
    func getTagsPublisher() -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getTags(token: token))
    }
    
    func getAllPhotosessionsPublisher() -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getPhotosessions(token: token))
    }
    
    func getResultPhotosPublisher(id: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.getResultsPhotos(photosessionId: id, token: token))
    }
    
    func addResultsPhotosPublisher(id: String, photos: [URL]) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.addResultPhotos(photosessionId: id,
                                                          photos: PhotosessionPhotos(photos: photos),
                                                          token: token))
    }
    
    func finishPhotosessionPublisher(id: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.finishPhotosession(photosessionId: id, token: token))
    }
    
    func inviteParticipant(invitationInfo: InvitationInfo, photosessionID: String) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.inviteParticipant(invitationInfo: invitationInfo, photosessionID: photosessionID, token: token))
    }
    
    func acceptInvite(photosesionId: String, type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.acceptInvite(photosesionId: photosesionId, profileType: type, token: token))
    }
    
    func declineInvite(photosesionId: String, type: ProfileType) -> AnyPublisher<Response, MoyaError> {
        return provider.requestPublisher(.declineInvite(photosesionId: photosesionId, profileType: type, token: token))
    }
}
