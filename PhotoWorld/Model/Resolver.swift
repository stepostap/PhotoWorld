//
//  Resolver.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.04.2023.
//

import Foundation

class Resolver {
    private var objects: [String:Any] = [:]
    
    public func register<Service>(type: Service.Type = Service.self, _ factory: () -> Service) {
        let res = factory()
        objects[String(describing: type)] = res
    }
    
    public func resolve<T>(type: T.Type) -> Any? {
        return objects[String(describing: type)]
    }
    
    public func clear() {
        objects.removeAll()
    }
}
