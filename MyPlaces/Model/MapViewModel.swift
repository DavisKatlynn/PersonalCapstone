//
//  MapViewModel.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 4/11/23.
//

import Foundation

class MapViewModel {
    var savedLocations: [SavedLocation] {
        get {
            if let data = UserDefaults.standard.data(forKey: "SavedLocations"),
               let savedLocations = try? JSONDecoder().decode([SavedLocation].self, from: data) {
                return savedLocations
            } else {
                return []
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "SavedLocations")
            }
        }
    }
    
    func addSavedLocation(name: String, latitude: Double, longitude: Double) {
        let newLocation = SavedLocation(name: name, latutude: latitude, longitude: longitude)
        savedLocations.append(newLocation)
    }
}
