//
//  ProfileCreation.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 09.05.2023.
//

import Foundation

struct ServiceRKO: Codable {
    internal init(name: String, start_price: Int?, end_price: Int?, pay_type: ServicePaymentType) {
        self.name = name
        self.start_price = start_price
        self.end_price = end_price
        self.pay_type = pay_type
    }
    
    init(service: UserServiceInfo) {
        self.name = service.serviceName
        self.start_price = service.startPrice
        self.end_price = service.endPrice
        self.pay_type = service.paymentType
    }
    
    let name: String
    let start_price: Int?
    let end_price: Int?
    let pay_type: ServicePaymentType
}

struct PhotographerProfileRKO: Codable {
    internal init(about_me: String, work_experience: String,
                  extra_info: String, avatar_url: String, tags: [String],
                  services: [ServiceRKO], photos: [String]) {
        self.about_me = about_me
        self.work_experience = work_experience
        self.extra_info = extra_info
        self.avatar_url = avatar_url
        self.tags = tags
        self.services = services
        self.photos = photos
    }
        
    internal init(account: Account) {
        about_me = account.profileInfo?.about ?? ""
        work_experience = account.profileInfo?.experience?.description ?? ""
        extra_info = account.profileInfo?.additionalInfo ?? ""
        avatar_url = account.profileImageURL?.description ?? ""
        tags = account.tags ?? []
        services = []
        if let accountServices = account.services {
            for service in accountServices.userServices {
                services.append(ServiceRKO(service: service))
            }
        }
        photos = []
        if let urls = account.allPhotos {
            for url in urls {
                photos.append(url.description)
            }
        }
    }
    
    let about_me: String
    let work_experience: String
    let extra_info: String
    let avatar_url: String
    let tags: [String]
    var services: [ServiceRKO]
    var photos: [String]
}
