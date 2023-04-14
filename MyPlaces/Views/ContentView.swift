//
//  ContentView.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/30/23.
//


import SwiftUI
import MapKit
import Foundation
import CoreData

struct ContentView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var places: [MKPointAnnotation] = []
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    @State private var isLoggedIn = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var searchQuery = ""
    @State private var selectedAnnotation: MKPointAnnotation?
    @State private var showingDetail = false
    
    
    @State var annotations = [MKPointAnnotation]()
    @State var selectedPlace: MKPointAnnotation?
    @State var savedPlaces = [MKPointAnnotation]()
    
    @State private var isSaved = false
    
    @State var text = ""
    
    struct customViewModifier: ViewModifier {
        var roundedCornes: CGFloat
        var startColor: Color
        var endColor: Color
        var textColor: Color

        func body(content: Content) -> some View {
            content
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(roundedCornes)
                .padding(3)
                .foregroundColor(textColor)
                .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                            .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
                .font(.custom("Open Sans", size: 18))

                .shadow(radius: 7)
        }
    }
    
    var body: some View {
        Group {
            if isLoggedIn {
                TabView {
                    NavigationView {
                        ZStack(alignment: .top) {
                            MapView(selectedPlace: $selectedPlace, showingDetail: $showingDetail)
                                .edgesIgnoringSafeArea(.top)
                                .onAppear(perform: addAnnotations)
                            VStack {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    SearchBar(text: $searchText, onSearchButtonClicked: searchButtonClicked)
                                        .modifier(customViewModifier(roundedCornes: 50, startColor: .green, endColor: .blue, textColor: .white))
                                    
                                    Button(action: {
                                        if let selectedPlace = selectedPlace {
                                            if !savedPlaces.contains(selectedPlace) {
                                                savedPlaces.append(selectedPlace)
                                                isSaved.toggle()
                                            }
                                        }
                                    }) {
                                        Text("Save Location")
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(isSaved ? .green : .orange)
                                            .font(.title)
                                            
                                            
                                    }
                                    .foregroundColor(Color.pink)
                                    .padding(.trailing)
                                    .disabled(selectedPlace == nil) // Disable the button if no location is selected
                                    .modifier(customViewModifier(roundedCornes: 50, startColor: .blue, endColor: .green, textColor: .white))
                                    }
                                Spacer()
                            }
                        }
                    }
                    .navigationBarTitle(Text("Map"))
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                    MyPlacesView(myPlaces: $savedPlaces)
                        .tabItem {
                            Label("My Places", systemImage: "list.bullet")
                        }
                        .edgesIgnoringSafeArea(.top)
                }
                
            
                }else {
                    LoginView(isLoggedIn: $isLoggedIn)
            }
            
            
        }
    }
    
    func addAnnotations() {
     
    }

    func searchButtonClicked(searchText: String) {
        print("Search button clicked")
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchText
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, error) in
            if let response = response {
                let mapItems = response.mapItems
                if let firstMapItem = mapItems.first {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = firstMapItem.placemark.coordinate
                    annotation.title = firstMapItem.name
                    selectedPlace = annotation
                    showingDetail = true
                    print("Selected place set to: \(annotation)")
                }
            }
        }
    }
}
        
        
        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    




//    private func performSearch(searchQuery: String, region: MKCoordinateRegion, completion: @escaping ([MKPointAnnotation]) -> Void) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchQuery
//        request.region = region
//
//        var localAnnotations = annotations
//
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            if let response = response {
//                let items = response.mapItems
//                localAnnotations = items.map { item in
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = item.placemark.coordinate
//                    annotation.title = item.name
//                    return annotation
//                }
//                if let firstItem = items.first {
//                    _ = MKCoordinateRegion(center: firstItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//                    completion(localAnnotations)
//                }
//            }
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "Placemark"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//
//            let button = UIButton(type: .detailDisclosure)
//            annotationView?.rightCalloutAccessoryView = button
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        return annotationView
//    }
//
//            func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//                guard let annotation = view.annotation else { return }
//
//                selectedAnnotation = (annotation as! MKPointAnnotation)
//            }
//
    
 // Working zoom map
   

  


//    struct ContentView: View {
//        @State private var searchText = ""
//        @State private var showingDetail = false
//        @State private var selectedPlace: MKPointAnnotation?

//
//        var body: some View {
//            TabView {
//                NavigationView {
//                    ProfileView()
//                    Form {
//                        List {
//
//                        }
//                    }
//                        .navigationTitle("Profile")
//                }
//                    .tabItem {
//                        Label("Profile", systemImage: "person.fill")
//                    }
//                NavigationView {
//                    VStack {
//                        NavigationView {
//                            ZStack(alignment: .top) {
//                                MapView(selectedPlace: $selectedPlace, showingDetail: $showingDetail)
//                                    .edgesIgnoringSafeArea(.all)
//
//                                VStack {
//                                    SearchBar(text: $searchText, onSearchButtonClicked: searchButtonClicked)
//                                        .padding(.top, 10)
//                                        .padding(.horizontal, 10)
//                                    Spacer()
//
//
//                                }
//                                .tabItem {
//                                    Label("Map", systemImage: "map")
//
//                            }
//                        }
//
//            }
//
//
//            .tabViewStyle(DefaultTabViewStyle())
//            .edgesIgnoringSafeArea(.top)
//
//
//                    }
//                }
//            }
//        }

//        func searchButtonClicked(searchText: String) {
//            print("Search button clicked")
//            let localSearchRequest = MKLocalSearch.Request()
//            localSearchRequest.naturalLanguageQuery = searchText
//
//            let localSearch = MKLocalSearch(request: localSearchRequest)
//            localSearch.start { (response, error) in
//                if let response = response {
//                    let mapItems = response.mapItems
//                    if let firstMapItem = mapItems.first {
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = firstMapItem.placemark.coordinate
//                        annotation.title = firstMapItem.name
//                        self.selectedPlace = annotation
//                        self.showingDetail = true
//                        print("Selected place set to: \(annotation)")
//                    }
//                }
//            }
//        }
//    }
//
//    struct MapView: UIViewRepresentable {
//        @Binding var selectedPlace: MKPointAnnotation?
//        @Binding var showingDetail: Bool
//
//        func makeUIView(context: Context) -> MKMapView {
//            let mapView = MKMapView()
//            mapView.delegate = context.coordinator
//
//            return mapView
//        }
//
//        func updateUIView(_ view: MKMapView, context: Context) {
//            if let selectedPlace = selectedPlace {
//                let coordinateRegion = MKCoordinateRegion(center: selectedPlace.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//                view.setRegion(coordinateRegion, animated: true)
//
//                view.removeAnnotations(view.annotations)
//                view.addAnnotation(selectedPlace)
//                view.selectAnnotation(selectedPlace, animated: true)
//            }
//        }
//
//        func makeCoordinator() -> Coordinator {
//            Coordinator(self)
//        }
//
//        class Coordinator: NSObject, MKMapViewDelegate {
//            var parent: MapView?
//
//            init(_ parent: MapView) {
//                self.parent = parent
//            }
//
//            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//                let identifier = "Placemark"
//                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//                if annotationView == nil {
//                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                    annotationView?.canShowCallout = true
//                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                } else {
//                    annotationView?.annotation = annotation
//                }
//
//                return annotationView
//            }
//            func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//                if let annotation = view.annotation as? MKPointAnnotation {
//                    parent?.selectedPlace = annotation
//                    parent?.showingDetail = true
//                    print("Selected place set to \(annotation)")
//                }
//            }
//        }
//    }
//
//    struct SearchBar: UIViewRepresentable {
//        @Binding var text: String
//        var onSearchButtonClicked: ((String) -> Void)?
//
//        class Coordinator: NSObject, UISearchBarDelegate {
//            let onSearchButtonClicked: ((String) -> Void)?
//
//            init(onSearchButtonClicked: ((String) -> Void)?) {
//                self.onSearchButtonClicked = onSearchButtonClicked
//            }
//
//            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//                if let searchText = searchBar.text {
//                    onSearchButtonClicked?(searchText)
//                }
//                searchBar.resignFirstResponder()
//            }
//
//            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//                searchBar.text = searchText
//            }
//        }
//
//        func makeCoordinator() -> Coordinator {
//            return Coordinator(onSearchButtonClicked: onSearchButtonClicked)
//        }
//
//        func makeUIView(context: Context) -> UISearchBar {
//            let searchBar = UISearchBar(frame: .zero)
//            searchBar.delegate = context.coordinator
//            searchBar.placeholder = "Search for a place"
//            searchBar.autocapitalizationType = .none
//            return searchBar
//        }
//
//        func updateUIView(_ uiView: UISearchBar, context: Context) {
//            uiView.text = text
//        }
//    }
//    struct DetailView: View {
//        let selectedPlace: MKPointAnnotation
//
//        var body: some View {
//            ZStack(alignment: .topTrailing) {
//                MapView(selectedPlace: .constant(selectedPlace), showingDetail: .constant(false))
//                    .ignoresSafeArea(edges: .top)
//                    .frame(height: 200)
//
//                Button(action: {
//                    // Close the detail view
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title)
//                        .foregroundColor(.white)
//                }
//                .padding(.trailing, 10)
//                .padding(.top, 10)
//            }
//        }
//    }

   
    
    
    
    
    
    
    
    
    
    
    
  
