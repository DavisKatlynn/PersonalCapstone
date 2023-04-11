//
//  Place.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.
//

import MapKit
import SwiftUI
import CoreLocation
import Foundation


/// First: Use this struct throughout your app
///

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}
