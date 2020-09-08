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
    @Published public var trackImageString:String?
    @Published public var trackImage:NSImage?
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
    @Published public var activeDevice:String?
    
    var playRecentlyPlayedTrack = true
    
    
    //public functions
    
    //get most recent 50 tracks
    public func getUserRecentlyPlayedTracks() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)", "limit":"1"]
        let headers:HTTPHeaders = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization": "Bearer \(self.accessToken!)"]
        
        AF.request("https://api.spotify.com/v1/me/player/recently-played", method: .get, parameters: parameters as Parameters, encoding:URLEncoding.default,
                          headers: headers)
            .responseJSON { response in
                
                do {
                    let infoJSON = try JSON(data: response.data!)
                    //get active device ID
                    self.getActiveDevice()
                    
                    self.onPlay = false
                    self.onShuffle = false
                    self.repeatState = "off"
                    self.trackImageString = infoJSON["items"][0]["track"]["album"]["images"][0]["url"].stringValue
                    self.getImageData()
                    self.trackName = infoJSON["items"][0]["track"]["name"].stringValue
                    self.trackProgress = 0
                    self.trackDuration = infoJSON["items"][0]["track"]["duration_ms"].intValue
                    self.trackArtist = infoJSON["items"][0]["track"]["artists"][0]["name"].stringValue
                    self.contextURI = infoJSON["items"][0]["context"]["uri"].stringValue
           
                    self.playRecentlyPlayedTrack = true
                    
                }catch {
                    print("something went wrong 2")
                }
                
        }
    }
    
    public func getUserCurrentlyPlayingTrack() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers:HTTPHeaders  = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization": "Bearer \(self.accessToken!)"]
        
        AF.request("https://api.spotify.com/v1/me/player/currently-playing", method: .get, parameters: parameters as Parameters, encoding:URLEncoding.default,
                          headers: headers)
            .responseJSON { response in
                
                do {
                    let infoJSON = try JSON(data: response.data ?? Data())
                    //get active device ID
                    self.getActiveDevice()
                    
                    self.onPlay = infoJSON["is_playing"].boolValue
                    self.onShuffle = infoJSON["shuffle_state"].boolValue
                    self.repeatState = infoJSON["repeat_state"].stringValue
                    self.trackImageString = infoJSON["item"]["album"]["images"][0]["url"].stringValue
                    self.getImageData()
                    self.trackName = infoJSON["item"]["name"].stringValue
                    self.trackProgress = infoJSON["progress_ms"].intValue
                    self.trackDuration = infoJSON["item"]["duration_ms"].intValue
                    self.trackArtist = infoJSON["item"]["artists"][0]["name"].stringValue
                    self.contextURI = infoJSON["context"]["uri"].stringValue
                }catch {
                    if self.activeDevice == nil || self.activeDevice == ""{
                        self.getUserRecentlyPlayedTracks()
                        self.playRecentlyPlayedTrack = true
                    }
                    print("something went wrong")
                }
                
        }

    }
    
    public func startResumeTrack() -> Void {
        //currently playing track, pause
        self.getUserCurrentlyPlayingTrack()
        
        if self.onPlay! {
            let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
            let headers:HTTPHeaders  = ["Authorization": "Bearer \(self.accessToken!)"]
            
            AF.request("https://api.spotify.com/v1/me/player/pause", method: .put, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    //track paused now
                    self.onPlay = false
            }
        }
        //currently on pause, play track
        else {
           
            //if no current track is playing, play the recently played song
            if self.playRecentlyPlayedTrack {
                let semaphore = DispatchSemaphore (value: 0)

                let parameters = "{\"context_uri\":\"\(self.contextURI!)\",\"offset\":{\"position\":5},\"position_ms\":0}"
                let postData = parameters.data(using: .utf8)

                var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player/play?device_id=\(self.activeDevice!)")!,timeoutInterval: Double.infinity)
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")

                request.httpMethod = "PUT"
                request.httpBody = postData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  guard let data = data else {
                    print(String(describing: error))
                    return
                  }
                  print(String(data: data, encoding: .utf8)!)
                  semaphore.signal()
                }

                task.resume()
                semaphore.wait()
                self.playRecentlyPlayedTrack = false
                //track playing now
                self.onPlay = true
                
                
                
            } else{
                //play the current song
                let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
                let headers:HTTPHeaders  = ["Authorization": "Bearer \(self.accessToken!)"]
                
                AF.request("https://api.spotify.com/v1/me/player/play", method: .put, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                                  headers: headers)
                    .responseJSON { response in
                        //track playing now
                        self.onPlay = true
                }
            }
        }
    }
    
    public func skipPlayBackNext() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers:HTTPHeaders  = ["Authorization": "Bearer \(self.accessToken!)"]
        
        AF.request("https://api.spotify.com/v1/me/player/next", method: .post, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                self.getUserCurrentlyPlayingTrack()
        }
    }
    
    public func skipPlayBackPrev() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers:HTTPHeaders  = ["Authorization": "Bearer \(self.accessToken!)"]
        
        AF.request("https://api.spotify.com/v1/me/player/previous", method: .post, parameters: parameters as Parameters, encoding:JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                self.getUserCurrentlyPlayingTrack()
        }
    }
    
    public func toggleShuffle() -> Void {
        
    }
    
    public func toggleRepeat() -> Void {
        
    }
    
    public func seekToPosition(seekPosition position:Int) -> Void {
        
    }
    
    public func saveAuthToken(authAccessToken userAccessToken:String) -> Void {
        self.accessToken = userAccessToken
    }
    
    public func getActiveDevice() -> Void {
        let parameters = ["Authorization" : "Bearer \(self.accessToken!)"]
        let headers:HTTPHeaders  = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization": "Bearer \(self.accessToken!)"]
        
        AF.request("https://api.spotify.com/v1/me/player/devices", method: .get, parameters: parameters as Parameters, encoding:URLEncoding.default,
                          headers: headers)
            .responseJSON { response in
                
                do {
                    let infoJSON = try JSON(data: response.data ?? Data())
                    self.activeDevice = infoJSON["devices"][0]["id"].stringValue
                    print("active device:\(self.activeDevice)")
                }catch {
  
                }
        }

    }
    
    
    //MARK:- Private Functions

    private func getImageData() -> Void {
        if let url = NSURL(string: "\(self.trackImageString!)") {
            if let data = NSData(contentsOf: url as URL) {
                self.trackImage = NSImage(data: data as Data)
            }
        }
    }
    
    
    
    
}

extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        
        print("{\"context_uri\":\"spotify:album:5ht7ItJgpBH7W6vJ5BqpPr\",\"offset\":{\"position\":5},\"position_ms\":0}")
        
        return request
    }

}
