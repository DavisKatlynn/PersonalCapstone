//
//  MyPlacesApp.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/30/23.
//
//
import MapKit
import SwiftUI
import CoreLocation
import Foundation
import CoreData

@main
struct MyPlacesApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
