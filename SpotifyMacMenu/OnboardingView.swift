//
//  OnboardingView.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-09-07.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    
    var body: some View {
        VStack {
            Text("Open Spotify App to start").frame(maxWidth: .infinity, maxHeight: .infinity)
            Button("Launch Spotify"){
                NSWorkspace.shared.launchApplication("Spotify")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
