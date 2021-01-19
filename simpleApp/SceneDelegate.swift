import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate,
                     SPTAppRemoteDelegate, SPTSessionManagerDelegate {
   
    
    var window: UIWindow?

    private let SpotifyClientID = "87930112081b4dbb84185b9d3a14eee1"
    private let SpotifyRedirectURI = URL(string: "spot://login")!
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/access_token")
        configuration.tokenRefreshURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/refresh_token")
        return configuration
    }()
    
    var playerViewController: ViewController {
        get {
            let navController = self.window?.rootViewController?.children[0] as! UINavigationController
            return navController.topViewController as! ViewController
        }
    }
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

//        let parameters = appRemote.authorizationParameters(from: url);
//
//        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
//            appRemote.connectionParameters.accessToken = access_token
//            self.accessToken = access_token
//        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
//            playerViewController.showError(errorDescription)
//        }

    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("didInitiate SESSION")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("didFailWithError SESSION")
    }
    

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        sessionManager.initiateSession(with: scope, options: .clientOnly)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        appRemote.disconnect()
    }

    // MARK: AppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("appRemoteDidEstablishConnection")
        self.appRemote = appRemote
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
    }

}
