//
//  CoreDataManager.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 4/5/23.
//

import Foundation
import CoreData
//
//
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MyPlaces")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}
//
//    
//  
//
//   
