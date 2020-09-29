//
//  Top50VC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
//import Spartan


class Top50VC: AuthVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        
        let controller = UIHostingController(rootView: Top50View())
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    override func loadView() {
        super.loadView()
    }
    
//    func fetchArtwork(for track:SPTAppRemoteTrack) {
//        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
//            if let error = error {
//                print("Error fetching track image: " + error.localizedDescription)
//            } else if let image = image as? UIImage {
////                self?.imageView.image = image
//            }
//        })
//    }
    
}

class Top50ListView: UIView {
//    func fetchArtwork(for track:SPTAppRemoteTrack) {
//        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
//            if let error = error {
//                print("Error fetching track image: " + error.localizedDescription)
//            } else if let image = image as? UIImage {
//                //  self?.imageView.image = image
//            }
//        })
//    }
    
    // testing
    func foo() {
        print("foo called")
    }
    
    
}

struct Top50ListRepresentable: UIViewRepresentable {
    let topListView = Top50ListView()
    
    func makeUIView(context: Context) -> Top50ListView {
        topListView
    }

    func updateUIView(_ uiView: Top50ListView, context: Context) {
    }
    
    func callFoo() {
        topListView.foo()
    }
    
}


struct Artist: Identifiable {
    var id: Int
    let name: String
}

struct Top50View: View {
    
    let top50List = Top50ListRepresentable()
    
    let artists: [Artist] = [
        // mock data
        .init(id: 0, name: "Bob"),
        .init(id: 1, name: "Tim"),
        .init(id: 2, name: "Kevin")
    ]
    
    // TODO: how to update artist image from API to representable view 
    
    var body: some View {
        NavigationView{
            List{
                //                Text($0.name)
                //                Text("First Row")
                ForEach(artists){ artist in
                    // artist row
                    HStack{
                        // mock data of artist image
                        Image("icon_profile")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipped()
                        Text(artist.name).font(.headline)
                        NavigationLink(destination: ArtistInfoView()) {
                            Text("")
                        }
                    }
                }
            }.navigationBarTitle(Text("Top 50 Artists"))
        }
    }
}

struct Top50View_Previews: PreviewProvider {
    static var previews: some View {
        Top50View()
    }
}


// MARK: UI Helpers
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
}
