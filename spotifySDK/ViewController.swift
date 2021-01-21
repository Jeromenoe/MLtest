//
//  ViewController.swift
//  spotifySDK
//
//  Created by Jerome on 21/01/2021.
//

import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Spotify variables
    
    private let SpotifyClientID = "9bc6703113b0414cb999ca241bd97c86"
    private let SpotifyRedirectURI = URL(string: "spotifySDK://callback")!
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/access_token")
        configuration.tokenRefreshURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/refresh_token")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    private var lastPlayerState: SPTAppRemotePlayerState?

    //MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appRemote.delegate = self
            self.appRemote.connect()
//        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Session didFailWith")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session didRenew")
    }
    

    //MARK: - SPTAppRemoteDelegate
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("appRemote : didFailConnectionAttemptWithError")
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("appRemote : didDisconnectWithError")
        lastPlayerState = nil
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("connecting")
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
//        appRemote.playerAPI?.pause({ (status, error) in
//            self.fetchPlayerState()
//        })
//        prepareDateForUI()
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        lastPlayerState = playerState
    }
    
    @IBAction func connectButton(_ sender: Any) {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userReadEmail]
        
        sessionManager.initiateSession(with: scope, options: .clientOnly)
    }
    
    @IBAction func playPauseButton(_ sender: Any) {
        print("app remote : ", appRemote.isConnected)
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    @IBAction func disconnectButton(_ sender: Any) {
        if (appRemote.isConnected) {
            appRemote.playerAPI?.pause(nil)
            appRemote.disconnect()
        }
    }
}

