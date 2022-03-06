//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Dante Cesa on 3/5/22.
//

import SwiftUI

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedResorts = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decodedResorts
                return
            }
        }
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        withAnimation {
            objectWillChange.send()
            resorts.insert(resort.id)
        }
        save()
    }
    
    func remove(_ resort: Resort) {
        withAnimation {
            objectWillChange.send()
            resorts.remove(resort.id)
        }
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
