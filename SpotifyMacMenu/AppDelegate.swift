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

    var window: NSWindow!



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
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
                print("IN SUCCESS")
                if success {
                    print(spotifyManager.hasToken)
                    print(spotifyManager.getAccessToken())
                }
                
            }
        }
    }
    
    


}

