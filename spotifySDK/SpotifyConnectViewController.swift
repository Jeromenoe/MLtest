//
//  SpotifyConnectViewController.swift
//  spotifySDK
//
//  Created by Jerome on 23/01/2021.
//

import UIKit

class SpotifyConnectViewController: UIViewController {

    let tabBarViewController = TabBarViewController.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func spotifyConnect(_ sender: Any) {
//        if (tabBarViewController.playerView.spotifyConnect() == true) {
//            // faire segue
//            self.performSegue(withIdentifier: "spotifyConnected", sender: self)
//        } else {
//            print("connexion failed")
//        }
        self.performSegue(withIdentifier: "spotifyConnected", sender: self)

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "spotifyConnected" {
            _ = segue.destination as! TabBarViewController
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
