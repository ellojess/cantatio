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

class TopTracksListView: UIView {

    // testing representable
    func foo() {
        print("foo called")
    }
    
    func foo2() {
        print("foo2 called")
    }
    
    func foo3() {
        print("foo3 called")
    }
    
    
}

struct TopTracksRepresentable: UIViewRepresentable {
    
    let topListView = TopTracksListView()
    
    func makeUIView(context: Context) -> TopTracksListView {
        topListView
    }

    func updateUIView(_ uiView: TopTracksListView, context: Context) {
    }
    
    func callFoo() {
        topListView.foo()
    }
    
}


struct TopTracks: Identifiable {
    var id: Int
    var songtitle: String
    var coverphoto: String
    
}

struct ArtistInfoView: View {
    
    @State var imageName: String = "icon_favorite"
    
    let topListView = TopTracksListView()
    
    @State var songs: [TopTracks] = [
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
                    TrackRow(songs: $songs, index: song.id)
                    
                }
                // TODO: replace "Artist" with actual artist name
//            }.navigationBarTitle(Text("Artist"), displayMode: .inline)
            }
            .hiddenNavigationBarStyle()
        }
    }
}

struct TrackRow: View {
    @Binding var songs: [TopTracks]
    let topListView = TopTracksListView()
    let index: Int
    
    @State var imageName: String = "icon_favorite"
    
    var body: some View {
        
        HStack{
            // mock data of artist image
            Image("icon_profile")
                .resizable()
                .frame(width: 70, height: 70)
                .clipped()
            Text(songs[index].songtitle).font(.headline)
                .padding(.leading, 8)
//                .padding(.trailing, 125)
                .lineLimit(nil)
            Spacer()
            
            Buttons(chosenType: .play)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    print(self.topListView.foo())
                })
            Buttons(chosenType: .pause)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    print(self.topListView.foo2())
                })
            Buttons(chosenType: .favorite)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    print(self.topListView.foo3())
                })
            
        }.padding(.leading, 10)
        .buttonStyle(PlainButtonStyle())


        }
    }


struct Buttons: View {
    @State var buttonImage: String = "icon_pause"
    
    enum ImageType: String, CaseIterable {
        case play = "icon_play"
        case pause = "icon_pause"
        case favorite = "icon_favorite"
    }
    
    let chosenType: ImageType
    
    var body: some View {
        Image(chosenType.rawValue)
    }
    
    
}

struct ArtistInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistInfoView()
    }
}
