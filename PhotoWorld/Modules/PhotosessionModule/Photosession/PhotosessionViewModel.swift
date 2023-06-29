//
//  PhotosessionViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.05.2023.
//

import Foundation
import Combine

protocol PhotosessionViewModelIO: ObservableObject {
    var photosession: PhotosessionFullInfo {get}
    func filterParticipants(index: Int) -> [ParticipantInfo]
    func openAccount(participant: ParticipantInfo) 
    func finishPhotosession()
    func openChat()
    func inviteUsers()
    func hideTabBar() 
    func openImages()
    func isOrganizer() -> Bool
}

class PhotosessionViewModel<coordinator: PhotoSessionModuleFlowCoordintorIO>:
                                        ViewModelProtocol, PhotosessionViewModelIO {
    
    internal init(moduleOutput: coordinator,
                  accountService: AccountService,
                  photosessionService: PhotosessionService,
                  photosession: PhotosessionFullInfo) {
        self.moduleOutput = moduleOutput
        self.photosession = photosession
        self.accountService = accountService
        self.photosessionService = photosessionService
    }
    
    let moduleOutput: coordinator
    let accountService: AccountService
    let photosessionService: PhotosessionService
    var cancellable: AnyCancellable?
    @Published var photosession: PhotosessionFullInfo
    @Published var participantTypeIndex = 0
    @Published var refresh = 1
    
    func isOrganizer() -> Bool {
        return AuthInfo.currentUserEmail.elementsEqual(photosession.organizer.email)
    }
    
    func filterParticipants(index: Int) -> [ParticipantInfo] {
        if let participants = photosession.participants {
            switch index {
            case 0:
                return participants
            case 1:
                return participants.filter({ info in info.profile_type == .stylist })
            case 2:
                return participants.filter({ info in info.profile_type == .model })
            default:
                return participants.filter({ info in info.profile_type == .photographer })
            }
        } else {
            return []
        }
    }
    
    func finishPhotosession() {
        cancellable = photosessionService.finishPhotosessionPublisher(id: photosession.id)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
        }, receiveValue: { [self] response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            }
            else {
                moduleOutput.finishPhotosession(id: photosession.id, participants: photosession.participants!)
            }
        })
    }
    
    func openChat() {
        moduleOutput.openChat(url: photosession.chat_url)
    }
    
    func openAccount(participant: ParticipantInfo) {
        cancellable = accountService.getProfileInfo(email: participant.email, type: participant.profile_type)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        let account = try JSONDecoder().decode(AccountRKO.self, from: response.data)
                        self.moduleOutput.openAccount(account: Account(avaURL: participant.avatar_url,
                                                                              accountRKO: account,
                                                                              type: participant.profile_type))
                    } catch {
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            })
    }
    
    func inviteUsers() {
        moduleOutput.addParticipants(inviteParticipant: { profile in
            let participant = ParticipantInfo(name: profile.name,
                                              email: profile.email,
                                              avatar_url: profile.avatar_url,
                                              profile_type: ProfileType.photographer,
                                              rating: profile.rating,
                                              comments_number: profile.comments_number,
                                              invite_status: .pending)
            if let list = self.photosession.participants, !list.contains(where: { info in info.email.elementsEqual(participant.email)}) {
                self.photosession.participants?.append(participant)
                self.sendInvite(info: InvitationInfo(email: profile.email, profile_type: .photographer))
            } else if self.photosession.participants == nil {
                self.photosession.participants = [participant]
                self.sendInvite(info: InvitationInfo(email: profile.email, profile_type: .photographer))
            }
        })
    }
    
    func sendInvite(info: InvitationInfo) {
        cancellable = photosessionService.inviteParticipant(invitationInfo: info, photosessionID: photosession.id).sink(
            receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            }
        })
    }
    
    func openImages() {
        moduleOutput.openImagesViewer(urls: photosession.photos ?? [])
    }
    
    func hideTabBar() {
        moduleOutput.hideTabBar()
    }
}
