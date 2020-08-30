//
//  SpotifyHelper.swift
//  SpotifyMacMenu
//
//  Created by Hojoon Lee on 2020-08-30.
//  Copyright © 2020 Irene Lee. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class SpotifyHelper: ObservableObject {
    
//    static let sharedInstance: (String) -> SpotifyHelper = {
//        authAccessToken in
//        return SpotifyHelper(userAccessToken: authAccessToken)
//    }
    
    static let shared = SpotifyHelper()
    
    //variables
    @Published public var trackImage:String?
    @Published public var trackName:String?
    @Published public var trackArtist:String?
    @Published public var trackDuration:Int?
    @Published public var trackProgress:Int?
    @Published public var volume:Int?
    @Published public var onPlay:Bool?
    @Published public var trackType:String?
    @Published public var repeatState:String?
    @Published public var onShuffle:Bool?
    @Published public var accessToken:String?
    @Published public var contextURI:String?
    
    
    //public functions
    
    //get most recent 50 tracks
    public func getUserRecentlyPlayedTracks() -> Void {
        
    }
    
    public func getUserCurrentlyPlayingTrack() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization": "Bearer \(self.accessToken!)"]
        
        Alamofire.request("https://api.spotify.com/v1/me/player/currently-playing", method: .get, parameters: parameters as Parameters, encoding:URLEncoding.default,
                          headers: headers)
            .responseJSON { response in
                
                do {
                    let infoJSON = try JSON(data: response.data!)
                    self.onPlay = infoJSON["is_playing"].boolValue
                    self.onShuffle = infoJSON["shuffle_state"].boolValue
                    self.repeatState = infoJSON["repeat_state"].stringValue
                    self.trackImage = infoJSON["item"]["album"]["images"][0]["url"].stringValue
                    self.trackName = infoJSON["item"]["name"].stringValue
                    self.trackProgress = infoJSON["progress_ms"].intValue
                    self.trackDuration = infoJSON["item"]["duration_ms"].intValue
                    self.trackArtist = infoJSON["item"]["artists"][0]["name"].stringValue
                    self.contextURI = infoJSON["context"]["uri"].stringValue
                }catch {
                    print("something went wrong")
                }
                
        }

    }
    
    public func startResumeTrack() -> Void {
        //currently playing track, pause
        if self.onPlay! {
            let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
            let headers = ["Authorization": "Bearer \(self.accessToken!)"]
            
            Alamofire.request("https://api.spotify.com/v1/me/player/pause", method: .put, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    //track paused now
                    self.onPlay = false
            }
        }
        //currently on pause, play track
        else {
           let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
            let headers = ["Authorization": "Bearer \(self.accessToken!)"]
            
            Alamofire.request("https://api.spotify.com/v1/me/player/play", method: .put, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    //track playing now
                    self.onPlay = true
            }
        }
    }
    
    public func skipPlayBackNext() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers = ["Authorization": "Bearer \(self.accessToken!)"]
        
        Alamofire.request("https://api.spotify.com/v1/me/player/next", method: .post, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                self.getUserCurrentlyPlayingTrack()
        }
    }
    
    public func skipPlayBackPrev() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers = ["Authorization": "Bearer \(self.accessToken!)"]
        
        Alamofire.request("https://api.spotify.com/v1/me/player/previous", method: .post, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                self.getUserCurrentlyPlayingTrack()
        }
    }
    
    public func toggleShuffle() -> Void {
        
    }
    
    public func toggleRepeat() -> Void {
        
    }
    
    public func saveAuthToken(authAccessToken userAccessToken:String) -> Void {
        self.accessToken = userAccessToken
    }
    
    //MARK:- Private Functions
    
//    init(userAccessToken:String) {
//        self.accessToken = userAccessToken
//    }
}
