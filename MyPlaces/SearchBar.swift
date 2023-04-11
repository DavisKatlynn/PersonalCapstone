//
//  SearchBar.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.
//

import MapKit
import SwiftUI
import CoreLocation
import Foundation

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearchButtonClicked: ((String) -> Void)?

    class Coordinator: NSObject, UISearchBarDelegate {
        let onSearchButtonClicked: ((String) -> Void)?

        init(onSearchButtonClicked: ((String) -> Void)?) {
            self.onSearchButtonClicked = onSearchButtonClicked
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                onSearchButtonClicked?(searchText)
            }
            searchBar.resignFirstResponder()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchBar.text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onSearchButtonClicked: onSearchButtonClicked)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .infinite)
        
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search for a place"
        searchBar.autocapitalizationType = .sentences
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
}



//
//struct SearchBar: UIViewRepresentable {
//    @Binding var text: String
//    
//    var onSearchButtonClicked: (() -> Void)?
//    
//    class Coordinator: NSObject, UISearchBarDelegate {
//        @Binding var text: String
//        var onSearchButtonClicked: (() -> Void)?
//        
//        init(text: Binding<String>, onSearchButtonClicked: (() -> Void)?) {
//            _text = text
//            self.onSearchButtonClicked = onSearchButtonClicked
//        }
//        
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//        }
//        
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            onSearchButtonClicked?()
//            searchBar.resignFirstResponder()
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(text: $text, onSearchButtonClicked: onSearchButtonClicked)
//    }
//    
//    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
//        let searchBar = UISearchBar()
//        searchBar.delegate = context.coordinator
//        searchBar.autocapitalizationType = .none
//        searchBar.autocorrectionType = .no
//        searchBar.searchBarStyle = .minimal
//        
//        return searchBar
//    }
//    
//    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
//        uiView.text = text
//    }
//}
