//
//  SearchFilter.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.05.2023.
//

import Foundation

class SearchFilter: ObservableObject {
    internal init() {
        self.tags = []
        setTags(newTags: ProfileTypeTags.getTags(forType: .photographer) ?? [])
    }
    
    internal init(filter: SearchFilter) {
        self.tags = filter.tags
        self.chosenType = filter.chosenType
        self.endExp = filter.endExp
        self.startExp = filter.startExp
        self.startingRating = filter.startingRating
        self.chosenUsersOnly = filter.chosenUsersOnly
    }
    
    @Published var chosenType: ProfileType = .photographer
    @Published var startExp: Int? = nil
    @Published var endExp: Int? = nil
    @Published var chosenUsersOnly: Bool = false
    @Published var startingRating: Double? = nil
    @Published var tags: [(tag: String, present: Bool)]
    
    var chosenTags: [String] {
        var chosen: [String] = []
        for tag in tags {
            if tag.present {
                chosen.append(tag.tag)
            }
        }
        return chosen
    }
    
    func setTags(newTags: [String]) {
        self.tags.removeAll()
        for tag in newTags {
            tags.append((tag, false))
        }
    }
}
