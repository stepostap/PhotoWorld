//
//  MutableData+.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 08.05.2023.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
