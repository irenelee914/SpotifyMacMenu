//
//  LaunchView.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-09-05.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    @ObservedObject var spotifyHelper = SpotifyHelper.shared
    
    var body: some View {
        VStack {
            if viewlaunch.currentPage == "ContentView"  {
                ContentView()
            } else if spotifyHelper.activeDevice == "" || spotifyHelper.activeDevice == nil {
                OnboardingView()
            } else {
                ContentView()
            }
//            if spotifyHelper.activeDevice == "" || spotifyHelper.activeDevice == nil {
//                OnboardingView()
//            }else {
//                ContentView()
//            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

class ViewLaunch: ObservableObject {
    
    init() {
        if !UserDefaults.standard.bool(forKey: "LaunchBefore") {
            currentPage = "OnboardingView"
        } else {
            currentPage = "ContentView"
        }
    }
    @Published var currentPage: String
}

