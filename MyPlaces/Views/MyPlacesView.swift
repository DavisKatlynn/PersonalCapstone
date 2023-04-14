//
//  MyPlacesView.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.


import MapKit
import SwiftUI

import Foundation

struct MyPlacesView: View {
    @Binding var myPlaces: [MKPointAnnotation]
    

    var body: some View {
        NavigationView {
            List {
                ForEach(myPlaces, id: \.self) { place in
                    Text(place.title ?? "")
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("My Saved Places")
        }
        .onAppear {
            // Load saved places from storage
            self.myPlaces = loadMyPlaces()
        }
        .onDisappear {
            // Save places to storage
            saveMyPlaces(self.myPlaces)
        }
    }

    func loadMyPlaces() -> [MKPointAnnotation] {
        // Load saved places from storage
        
        return myPlaces
    }

    func saveMyPlaces(_ places: [MKPointAnnotation]) {
        // Save places to storage
    }

    func delete(at offsets: IndexSet) {
        myPlaces.remove(atOffsets: offsets)
    }
}
