//
//  ContentView.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-06-23.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import SwiftUI
import OAuthSwift

let oauthswift = OAuth2Swift(
    consumerKey:    "17ac21f717f24be7b6d9bf835785da4d",
    consumerSecret: "10b27d218e9049789d8f6fb736f5a413",
    authorizeUrl:   "https://accounts.spotify.com/authorize",
    responseType:   "code"
)

struct ContentView: View {
    var body: some View {
        VStack{
            Button("Hello, World!"){
                spotifyManager.myProfile { (me) in
                    print(me)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
