//
//  MapView.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.
//

import MapKit
import SwiftUI
import CoreLocation
import Foundation

struct MapView: UIViewRepresentable {
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingDetail: Bool
    @State private var savedPlaces = Set<String>() // Store coordinates of saved places
    @State private var isSaved = false
    
    let viewModel = MapViewModel()
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if let selectedPlace = selectedPlace {
            let coordinateRegion = MKCoordinateRegion(center: selectedPlace.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            view.setRegion(coordinateRegion, animated: true)

            view.removeAnnotations(view.annotations)
            view.addAnnotation(selectedPlace)
            view.selectAnnotation(selectedPlace, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        @objc func addToMyPlaces(_ sender: UIButton) {
            if let annotationView = sender.superview as? MKAnnotationView,
                   let annotation = annotationView.annotation as? MKPointAnnotation {
                
                let coordinateString = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
                
                // Check if location has already been saved
                if parent?.savedPlaces.contains(coordinateString) == true {
                    print("Location has already been saved.")
                    return
                }
                
                // Save the location
                parent?.savedPlaces.insert(coordinateString)
                print("Added \(annotation) to My Places")

                // Animate the heart button
                UIView.animate(withDuration: 0.1, animations: {
                    sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    sender.setImage(UIImage(systemName: "info.circle.fill"), for: .highlighted)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        sender.transform = CGAffineTransform.identity
                    }
                })
            }
        }

        var parent: MapView?

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(named: "pin")
                            
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                parent?.selectedPlace = annotation
                parent?.showingDetail = true
                print("Selected place set to \(annotation)")
            }
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(selectedPlace: , showingDetail: <#T##Binding<Bool>#>)
//    }
//}



//struct MapView: UIViewRepresentable {
//
//    @Binding var region: MKCoordinateRegion
//    var annotations: [MKPointAnnotation]
//    @Binding var selectedAnnotation: MKPointAnnotation?
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.setRegion(region, animated: true)
//
////        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
////        let span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
////        let region = MKCoordinateRegion(center: coordinate, span: span)
//
//
//        return mapView
//    }
//
//    func updateUIView(_ mapView: MKMapView, context: Context) {
//        mapView.region = region
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotations(annotations)
//
//        if let selectedAnnotation = selectedAnnotation {
//            mapView.selectAnnotation(selectedAnnotation, animated: true)
//        } else {
//            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(selectedAnnotation: $selectedAnnotation)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        @Binding var selectedAnnotation: MKPointAnnotation?
//
//        init(selectedAnnotation: Binding<MKPointAnnotation?>) {
//            _selectedAnnotation = selectedAnnotation
//        }
//
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            if let annotation = view.annotation as? MKPointAnnotation {
//                selectedAnnotation = annotation
//            }
//        }
//
//        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//            if let annotation = view.annotation as? MKPointAnnotation, annotation == selectedAnnotation {
//                selectedAnnotation = nil
//            }
//        }
//    }
//}







// this one works
//struct MapView: View {
//    @State private var searchQuery: String = ""
//
//
//    @State private var searchText = ""
//    @State private var annotations = [MKPointAnnotation]()
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @State private var mapView = MKMapView()
//    @State private var selectedPlace: Place?
//    private let place = Place(name: "", latitude: 0.0, longitude: 0.0)
//    private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//
//
//    var body: some View {
//        ZStack {
//            MapViewContainer(annotations: $annotations, showingAlert: $showingAlert, alertMessage: $alertMessage, mapView: $mapView)
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                }
//                .edgesIgnoringSafeArea(.bottom)
//
//            Color.clear
//                .onTapGesture {
//                    guard let coordinate = annotations.first?.coordinate else { return }
//                    let location = MKPointAnnotation()
//                    location.coordinate = coordinate
//                    location.title = "New Place"
//                    annotations.append(location)
//                }
//        }
//        .onAppear {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
//            annotation.title = place.name
//            annotations.append(annotation)
//        }
//        .navigationTitle("Map")
//        .navigationBarTitleDisplayMode(.inline)
////        .navigationBarItems(trailing: SearchBar(text: $searchText, onSearchButtonClicked: searchLocation))
//    }
//
//    struct MapViewContainer: UIViewRepresentable {
//        @Binding var annotations: [MKPointAnnotation]
//        @Binding var showingAlert: Bool
//        @Binding var alertMessage: String
//        @Binding var mapView: MKMapView
//
//        func makeUIView(context: Context) -> MKMapView {
//            mapView.delegate = context.coordinator
//
//            return mapView
//        }
//
//        func updateUIView(_ mapView: MKMapView, context: Context) {
//            mapView.removeAnnotations(mapView.annotations)
//            mapView.addAnnotations(annotations)
//        }
//
//        func makeCoordinator() -> Coordinator {
//            Coordinator(self, mapView: mapView)
//        }
//
//        class Coordinator: NSObject, MKMapViewDelegate {
//            var parent: MapViewContainer
//            var mapView: MKMapView
//
//            init(_ parent: MapViewContainer, mapView: MKMapView) {
//                self.parent = parent
//                self.mapView = mapView
//            }
//
//            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//                guard let annotation = annotation as? MKPointAnnotation else {
//                    return nil
//                }
//
//                let identifier = "Placemark"
//                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//
//                if annotationView == nil {
//                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                    annotationView?.canShowCallout = true
//                    let button = UIButton(type: .detailDisclosure)
//                    annotationView?.rightCalloutAccessoryView = button
//                } else {
//                    annotationView?.annotation = annotation
//                }
//
//                               annotationView?.glyphImage = UIImage(named: "your_glyph_image_name")
//                                annotationView?.glyphText = "your_glyph_text"
//                annotationView?.markerTintColor = .purple
//
//                return annotationView
//            }
//
//
//            func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//                if let annotation = view.annotation, let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//
//                struct ContentView_Previews: PreviewProvider {
//                    static var previews: some View {
//                        ContentView()
//                    }
//                }
//            }
//        }
//    }
//}


