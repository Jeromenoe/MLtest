//
//  TabBarViewController.swift
//  spotifySDK
//
//  Created by Jerome on 23/01/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    static let shared = TabBarViewController()
    
    let playerView = PlayerView!.shared
//    @IBOutlet var playerView: PlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: playerView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: playerView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: playerView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: -51)
        let heightConstraint = NSLayoutConstraint(item: playerView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([leftConstraint, rightConstraint, bottomConstraint, heightConstraint])
    }

}
