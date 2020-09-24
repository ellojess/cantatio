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
    
    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
//                self?.imageView.image = image
            }
        })
    }
    
}

//struct TopArtistList: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> Top50VC {
//        let artistList = Top50VC()
//        return artistList
//    }
//
//    func updateUIViewController(_ uiViewController: Top50VC, context: Context) {
//        <#code#>
//    }
//
//
//
//}

struct Artist: Identifiable {
    var id: Int
    let name: String
}

struct Top50View: View {
    
    let artists: [Artist] = [
        // mock data
        .init(id: 0, name: "Bob"),
        .init(id: 1, name: "Tim"),
        .init(id: 2, name: "Kevin")
    ]
    
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
