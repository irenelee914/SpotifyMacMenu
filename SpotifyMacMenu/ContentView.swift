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
    @ObservedObject var spotifyHelper = SpotifyHelper.shared
    
    @State var sliderValue: Double = 0
    var body: some View {
        
        VStack{
            Image(nsImage: spotifyHelper.trackImage ?? NSImage())
            Text("\(spotifyHelper.trackName ?? "--")").frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("\(spotifyHelper.trackArtist ?? "--")").frame(maxWidth: .infinity, maxHeight: .infinity)
            Slider(value: $sliderValue, in: 0...20, step: 1)
            HStack{
                Button("Prev"){
                    self.spotifyHelper.skipPlayBackPrev()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                Button("Play"){
                    print(self.spotifyHelper.activeDevice)
                    self.spotifyHelper.startResumeTrack()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                Button("Next"){
                    self.spotifyHelper.skipPlayBackNext()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.onAppear{
            self.spotifyHelper.getActiveDevice()
            self.spotifyHelper.getUserRecentlyPlayedTracks()
            print(self.spotifyHelper.activeDevice)
        }
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
