//
//  ArtistInfoVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

class ArtistInfoVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
    }
    
}


struct TopTracks: Identifiable {
    var id: Int
    var songtitle: String
    var coverphoto: String
    
}

struct ArtistInfoView: View {
    
    let songs: [TopTracks] = [
        // mock data
        .init(id: 0, songtitle: "do", coverphoto: "Bob"),
        .init(id: 1, songtitle: "re", coverphoto: "Tim"),
        .init(id: 2, songtitle: "me", coverphoto: "Kevin")
    ]
    
    var body: some View {
        NavigationView{
            List{
                Text("Top Tracks").font(.largeTitle)
                ForEach(songs){ song in
                    // artist row
                    TrackRow(song: song)
                }
                // TODO: replave "Artist" with actual artist name
//            }.navigationBarTitle(Text("Artist"), displayMode: .inline)
            }
            .hiddenNavigationBarStyle()
        }
    }
}

struct TrackRow: View {
    let song: TopTracks
    @State private var buttonTapped = false
    
    var body: some View {
        HStack{
            // mock data of artist image
            Image("icon_profile")
                .resizable()
                .frame(width: 70, height: 70)
                .clipped()
            Text(song.songtitle).font(.headline)
                .padding(.leading, 8)
                .padding(.trailing, 125)
                .lineLimit(nil)
            Spacer()
            
//            Button {
//                print("button tapped")
//                self.buttonTapped.toggle()
//            }{Image(self.buttonTapped ? "icon_play":"icon_pause")}
            
            if buttonTapped {
                Button(action: {
                    print("button tapped")
                    self.buttonTapped.toggle()
                    Image("icon_play")

                }){
                    Image("icon_pause")

                }
            }
            
            Image("icon_play")
            Image("icon_pause")
            Image("icon_favorite")
        }.padding(.leading, 10)
            .buttonStyle(PlainButtonStyle())
    }
}

struct ArtistInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistInfoView()
    }
}

//// MARK: UI Helpers
//struct HiddenNavigationBar: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//        .navigationBarTitle("")
//        .navigationBarHidden(true)
//    }
//}
//
//extension View {
//    func hiddenNavigationBarStyle() -> some View {
//        modifier( HiddenNavigationBar() )
//    }
//}
