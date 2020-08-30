//
//  ContentView.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-06-23.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import SwiftUI
import OAuthSwift


struct ContentView: View {
    var spotifyHelper = SpotifyHelper.shared
    
    @State var sliderValue: Double = 0
    var body: some View {
        
        VStack{
            Text("\(spotifyHelper.trackName ?? "--")").frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("\(spotifyHelper.trackArtist ?? "--")").frame(maxWidth: .infinity, maxHeight: .infinity)
            Slider(value: $sliderValue, in: 0...20, step: 1)
            HStack{
                Button("Prev"){
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                Button("Play"){
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                Button("Next"){
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
