//
//  Signup.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers
struct Signup: View {
    @State private var isChecked = false
    @State private var selectedItem: PhotosPickerItem? = nil
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    ZStack(alignment: .top) {
                        
                        
                        Image("signup7")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 300 + (offset > 0 ? offset : 0))
                            .clipped()
                            .offset(y: offset > 0 ? -offset : 0)
                        
                        
                        VStack {
                            Spacer()
                            HStack(alignment: .center) {
                                Text("Enter your name")
                                    .padding(.vertical)
                                    .foregroundColor(.white)
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    
                                
                                Spacer()
                                PhotosPicker(
                                    selection: $selectedItem,
                                    matching: .any(of: [.images, .videos]),
                                    photoLibrary: .shared()
                                ) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 50, height: 50)
                                        Image(systemName:"photo.stack")
                                            .font(.title2)
                                            
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                
                                
                                
                            }
                            .offset(y: offset > 0 ? -offset : 0)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                    }
                }
                
            }
            VStack( spacing: 10){
               
                HStack{
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .any(of: [.images, .videos]),
                        photoLibrary: .shared()
                    ) {
                        ZStack {
                            ZStack{
                                Circle()
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame(width: 50, height: 50)
                                Image(systemName:"person.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                            }
                        }
                    }
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                            .padding(.trailing, 1)
                        TextField("Create a Username", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    Image(systemName: "x.circle")
                        .foregroundStyle(.red)
                        
                }
                HStack{
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                        TextField("Enter your Email", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    Image(systemName: "x.circle")
                        .foregroundStyle(.red)
                        
                }
                HStack{
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                        TextField("Create a Password", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    Image(systemName: "x.circle")
                        .foregroundStyle(.red)
                        
                }
                HStack{
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                            .glassEffect()
                            .frame(height: 50)
                            .cornerRadius(25)
                        TextField("Verify Password", text: .constant(""))
                            .padding(.horizontal, 20)
                    }
                    Image(systemName: "x.circle")
                        .foregroundStyle(.red)
                        
                }
                
                Spacer()
                
                Button {
                    print("Next")
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.blue.opacity(1))
                            .glassEffect()
                            .clipShape(Capsule())
                            .frame(width: 100, height: 50)
                        Text("Next")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 300)
        }
        
        
    }
}

#Preview {
    Signup()
}
