//
//  AppDelegate.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-06-23.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import Cocoa
import SwiftUI
import SpotifyKit

var spotifyManager = SpotifyManager(
    with: SpotifyManager.SpotifyDeveloperApplication(
        clientId: "17ac21f717f24be7b6d9bf835785da4d",
        clientSecret: "10b27d218e9049789d8f6fb736f5a413",
        redirectUri: "SpotifyMacMenu://callback"
    )
)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    var spotifyHelper = SpotifyHelper.shared
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the SwiftUI view that provides the contents
        let contentView = LaunchView().environmentObject(ViewLaunch())
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentSize = NSSize(width: 250, height: 290)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // Create the Status Bar Item with the above Popover
        statusBar = StatusBarController.init(popover)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        spotifyManager.deauthorize()
        spotifyManager.authorize()
        initEventManager()
    }
    
    func initEventManager() {
        NSAppleEventManager.shared().setEventHandler(self,
        andSelector: #selector(handleURLEvent),
        forEventClass: AEEventClass(kInternetEventClass),
        andEventID: AEEventID(kAEGetURL))
    }
    
    @objc func handleURLEvent(event: NSAppleEventDescriptor,
                        replyEvent: NSAppleEventDescriptor) {
        if    let descriptor = event.paramDescriptor(forKeyword: keyDirectObject),
            let urlString  = descriptor.stringValue,
            let url        = URL(string: urlString) {
            spotifyManager.saveToken(from: url) { (success) in
                self.spotifyHelper.saveAuthToken(authAccessToken: spotifyManager.getAccessToken())
                //self.spotifyHelper.getActiveDevice()
                self.spotifyHelper.getUserCurrentlyPlayingTrack()
            }
        }
    }
    
    


}

