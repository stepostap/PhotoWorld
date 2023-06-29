//
//  HomePageViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 02.05.2023.
//

import Foundation
import Combine
import Moya

protocol HomePageViewModelIO: ObservableObject {
    var searchRes: [SearchProfileInfo] { get }
    var searchCellButtonInfo: SearchCellButtonInfo? { get }
    var searchQueue: String {get set}
    var isLoading: Bool { get }
    func resendRequest()
    func openSearchFilter()
    func openAccount(info: SearchProfileInfo)
    func openChat(info: SearchProfileInfo)
}

struct SearchCellButtonInfo {
    var title: String
    var buttonAction: (SearchProfileInfo)->Void
}

class HomePageViewModel<coordinator: SearchCoordinator>: ViewModelProtocol, HomePageViewModelIO {
    typealias errorPresenter = coordinator
    
    internal init(output: coordinator,
                  accountService: AccountService,
                  searchService: SearchService) {
        self.moduleOutput = output
        self.accountService = accountService
        self.searchService = searchService
    }
    
    @Published var searchRes: [SearchProfileInfo] = []
    @Published var searchQueue: String = "" {
        didSet {
            sendSearchRequest()
        }
    }
    @Published var isLoading = false
    
    let filter = SearchFilter()
    var searchCellButtonInfo: SearchCellButtonInfo?
    let accountService: AccountService
    let searchService: SearchService
    let moduleOutput: coordinator
    var bag: [AnyCancellable] = []
    var publishers: [AnyPublisher<Response, MoyaError>] = []
    
    func openAccount(info: SearchProfileInfo) {
        accountService.getProfileInfo(email: info.email, type: filter.chosenType)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res)
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        let account = try JSONDecoder().decode(AccountRKO.self, from: response.data)
                        self.moduleOutput.openAccount(account: Account(avaURL: info.avatar_url,
                                                                              accountRKO: account,
                                                                              type: self.filter.chosenType))
                    } catch {
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            }).store(in: &bag)
    }
    
    func openChat(info: SearchProfileInfo) {
        accountService.getChatURL(email: info.email).sink(receiveCompletion: { res in
            self.checkComplition(res: res)
        }, receiveValue: { response in
            if response.statusCode > 299 {
                self.showResponseError(response: response)
            } else {
                do {
                    let url = try JSONDecoder().decode(ChatURL.self, from: response.data)
                    self.moduleOutput.openChat(url: url.chat_url)
                } catch {
                    self.moduleOutput.showAlert(error: .decodingError)
                }
            }
        }).store(in: &bag)
    }
    
    func sendSearchRequest() {
        isLoading = true
        let query = SearchInfo(search_query: searchQueue, tags: filter.chosenTags, start_work_experience: filter.startExp, end_work_experience: filter.endExp, services: [], profile_type: filter.chosenType.networkTitle)
        
        searchService.getSearchPublisher(query: query)
            .receive(on: DispatchQueue.main)
            .throttle(for: .microseconds(500), scheduler: DispatchQueue.main, latest: true)
            //.debounce(for: .microseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { res in
                self.checkComplition(res: res, completion: { self.isLoading = false })
            }, receiveValue: { response in
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        let searchAccounts = try JSONDecoder().decode(SearchResult.self, from: response.data)
                        self.searchRes = searchAccounts.profiles
                        print(self.searchRes)
                    } catch {
                        print(error)
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            }).store(in: &bag)
    }
    
    func openSearchFilter() {
        if let _ = ProfileTypeTags.getTags(forType: .photographer) {} else {
            publishers.append(accountService.getTagsPublisher(forType: .photographer))
        }
        if let _ = ProfileTypeTags.getTags(forType: .model) {} else {
            publishers.append(accountService.getTagsPublisher(forType: .model))
        }
        if let _ = ProfileTypeTags.getTags(forType: .stylist) {} else {
            publishers.append(accountService.getTagsPublisher(forType: .stylist))
        }
        
        if publishers.isEmpty {
            moduleOutput.openSearchFilter(filter: filter)
        } else {
            loadTags()
        }
    }
    
    func loadTags() {
        publishers.publisher.flatMap({$0}).collect().sink(receiveCompletion: { res in
            self.checkComplition(res: res, completion: {
                self.filter.setTags(newTags: ProfileTypeTags.getTags(forType: .photographer) ?? [])
                self.moduleOutput.openSearchFilter(filter: self.filter)
            })
        }, receiveValue: { responses in
            for response in responses {
               
                if response.statusCode > 299 {
                    self.showResponseError(response: response)
                } else {
                    do {
                        var spec: [String] = []
                        let tags = try JSONDecoder().decode(Tags.self, from: response.data)
                        for tag in tags.tags {
                            spec.append(tag)
                        }
                        self.setTags(tags: spec, response: response)
                    } catch {
                        self.moduleOutput.showAlert(error: .decodingError)
                    }
                }
            }
        }).store(in: &bag)
    }
    
    func setTags(tags: [String], response: Response) {
        if let request = response.request, let url = request.url {
            if url.description.contains(ProfileType.photographer.networkTitle) {
                ProfileTypeTags.setTags(forType: .photographer, tags: tags)
            }
            if url.description.contains(ProfileType.model.networkTitle) {
                ProfileTypeTags.setTags(forType: .model, tags: tags)
            }
            if url.description.contains(ProfileType.stylist.networkTitle) {
                ProfileTypeTags.setTags(forType: .stylist, tags: tags)
            }
        }
    }
    
    func resendRequest() {
        if searchCellButtonInfo!.title != "Пригласить" {
            moduleOutput.showTabBar()
        }
        sendSearchRequest()
    }
}
