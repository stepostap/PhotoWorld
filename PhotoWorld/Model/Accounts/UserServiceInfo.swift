//
//  UserService.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import Foundation

protocol UserService: CaseIterable, Equatable {
    var title: String { get }
}

enum ServicePaymentType: String, Codable {
    case perHour = "BY_HOUR"
    case fixed = "BY_SERVICE"
}

class UserServiceInfo: Equatable, Identifiable, ObservableObject {
    static func == (lhs: UserServiceInfo, rhs: UserServiceInfo) -> Bool {
        return lhs.serviceName == rhs.serviceName
    }
    
    internal init(service: String, startPrice: Int? = nil, endPrice: Int? = nil, paymentType: ServicePaymentType) {
        self.serviceName = service
        self.startPrice = startPrice
        self.endPrice = endPrice
        self.paymentType = paymentType
    }
    
    internal init(serviceInfo: UserServiceInfo) {
        self.endPrice = serviceInfo.endPrice
        self.paymentType = serviceInfo.paymentType
        self.serviceName = serviceInfo.serviceName
        self.startPrice = serviceInfo.startPrice
    }
    
    internal init(rko: ServiceRKO) {
        serviceName = rko.name
        startPrice = rko.start_price
        endPrice = rko.end_price
        paymentType = rko.pay_type
    }
    
    let serviceName: String
    @Published var startPrice: Int?
    @Published var endPrice: Int?
    @Published var paymentType: ServicePaymentType
    
    func priceDescription() -> String? {
        guard let startPrice = startPrice else {
            return nil
        }
        if let endPrice = endPrice {
            return "\(startPrice)-\(endPrice) ₽ \(paymentType == .perHour ? "за час" : "")"
        } else {
            return "\(startPrice) ₽ \(paymentType == .perHour ? "за час" : "")"
        }
    }
}

class UserServices: ObservableObject {
    internal init(userServeices: [UserServiceInfo]) {
        self.userServices = userServeices
    }
    
    @Published var userServices: [UserServiceInfo]
}
