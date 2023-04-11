//
//  LoginView.swift
//  MyPlaces
//
//  Created by Katlynn Davis on 3/31/23.


import SwiftUI
import Foundation
import CoreData

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var password = ""
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
            
                .shadow(radius: 10)
        }
    }
    
    var body: some View {
        VStack {
            Text("Adventure Awaits!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .shadow(color: .blue, radius: 15, x: 0, y: 15)
                .padding(.bottom, 100)
            Image("userImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 75)
                .shadow(color: .green, radius: 15, x: 0, y: 15)
            
            HStack {
                TextField("Username", text: $username)
            }.modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .blue, textColor: .white))
        }.padding()
        HStack {
            SecureField("Password", text: $password)
        }.modifier(customViewModifier(roundedCornes: 6, startColor: .blue, endColor: .green, textColor: .white))
            .padding()
        HStack {
            Button("Login") {
                isLoggedIn = true
        }}.modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .blue, textColor: .white))
            .padding()
    }
    
}
            
            
//                .padding()
//                    .background(Color.blue)
//                    .foregroundColor(Color.white)
//                    .clipShape(Capsule())
//                    .shadow(color: .green, radius: 15, x: 0, y: 15)
            
//                .padding()
//                    .background(Color.blue)
//                    .foregroundColor(Color.white)
//                    .clipShape(Capsule())
//                    .shadow(color: .green, radius: 15, x: 0, y: 15)
//                    .padding(30)
        
//
            
//            }
//            .padding()
//                .background(Color.white)
//                .clipShape(Capsule())
//                .shadow(color: .blue, radius: 15, x: 0, y: 15)
//                .edgesIgnoringSafeArea(.all)
//        }
//        .padding(.all, 0)
//        .background(Color.white)
//        .edgesIgnoringSafeArea(.all)
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(isLoggedIn: )
//    }
//}
