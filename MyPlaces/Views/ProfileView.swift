//
//  ProfileView.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.

import SwiftUI
import Foundation
import CoreData

struct ProfileView: View {
    @State private var aboutMeText = "Tell us about yourself"
    @State private var username = "Username"
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About Me")) {
                    HStack {
                        Image("userImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipped()
                            .cornerRadius(75)
                        
                        if isEditMode {
                            TextField("Username", text: $username)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(alignment: .topLeading)
                        } else {
                            Text(username)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(alignment: .topLeading)
                        }
                        
                        Spacer() // Added spacer
                    }
                    if isEditMode {
                        TextEditor(text: $aboutMeText)
                            .font(.system(size: 15))
                            .font(.body)
                            .frame(width: 400, height: 100, alignment: .center)
                            .lineLimit(100)
                            .padding()
                    } else {
                        Text(aboutMeText)
                            .font(.system(size: 15))
                            .font(.body)
                            .frame(width: 400, height: 100, alignment: .center)
                            .lineLimit(100)
                            .padding()
                    }
                }
                Section(header: Text("Upload Photos")) {
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Text("Select Photo")
                    }
                    .background(Color.indigo)
                    .clipShape(Capsule())
                    .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    .foregroundColor(Color.white)
                    .frame(width: 100, height: 50)
                }
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipped()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Profile")
            .navigationBarItems(trailing:
                Button(action: {
                if self.isEditMode {
                    //save changes
                self.isEditMode.toggle()
                } else {
                self.isEditMode.toggle()
                    //start editing
                }
            }) {
                if isEditMode {
                    Text("Save")
                } else {
                    Text("Edit")
                }
            }
            )
            .sheet(isPresented: $isEditMode) {
                EditProfileView(username: self.$username, aboutMeText: self.$aboutMeText)
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$image)
            }
        }
        .foregroundColor(.indigo)
    }
    struct EditProfileView: View {
        @Binding var username: String
        @Binding var aboutMeText: String
        @Environment(\.presentationMode) var presentationMode
        
            
        var body: some View {
            VStack {
                Image("userImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipped()
                    .cornerRadius(75)
                
                TextField("Username", text: $username)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(alignment: .topLeading)
                    
                TextEditor(text: $aboutMeText)
                    .font(.system(size: 15))
                    .font(.body)
                    .frame(width: 400, height: 100, alignment: .center)
                    .lineLimit(100)
                    .padding()
                
                Button(action: {
                    // Save changes and dismiss this view
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
            .padding()
        }
    }
    
        func loadImage() {
            guard let inputImage = image else { return }
            self.image = inputImage
        }
    }
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        @Environment(\.presentationMode) var presentationMode
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
struct UploadPhotosView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var image: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
            VStack {
                if let image = image {
                Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipped()
                }
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Text("Select Photo")
                    }
                    .background(Color.indigo)
                    .clipShape(Capsule())
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray, radius: 15, x: 15, y: 15)
                    Spacer()
                    Button(action: savePhoto) {
                        Text("Upload Photo")
                    }
                }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$image)
            }
        }
        
        func loadImage() {
            guard image != nil else { return }
                    
                }
        
        func savePhoto() {
            // Save the uploaded photo to the server
        }
        struct ImagePicker: UIViewControllerRepresentable {
            @Environment(\.presentationMode) var presentationMode
            @Binding var image: UIImage?
            
            class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                let parent: ImagePicker
                
                init(_ parent: ImagePicker) {
                    self.parent = parent
                }
                
                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    if let uiImage = info[.editedImage] as? UIImage {
                        parent.image = uiImage
                    }
                    
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
            
            func makeCoordinator() -> Coordinator {
                Coordinator(self)
            }
            
            func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = context.coordinator
                return picker
            }
            
            func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
            
            
        }
        
    }
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
