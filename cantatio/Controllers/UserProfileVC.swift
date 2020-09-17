//
//  ProfileVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/15/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import MapKit

class UserProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
    }
    
}

// Content View
struct ProfileContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                MapView()
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 250)
                
                CircleImage()
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                VStack(alignment: .center) {
                    Text("DJ Boba")
                        .font(.title)
                        .padding()
                    
                    Text("Hometown: San Francisco, CA")
                        .font(.subheadline)
                    Text("Loves to Stargaze")
                        .font(.subheadline)
                }
                .padding()
                .navigationBarTitle(Text("Profile"), displayMode: .inline)
            }
            
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileContentView()
    }
}

// Profile Image
struct CircleImage: View {
    var body: some View {
        
        Image("icon_profile")
            .resizable()
            .scaledToFit()
            .frame(width: 200.0,height:200)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Preview: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}

// Map View
struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 37.773972, longitude: -122.431297)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
