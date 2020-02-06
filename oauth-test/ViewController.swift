//
//  ViewController.swift
//  oauth-test
//
//  Created by Tom Rochat on 06/02/2020.
//  Copyright © 2020 Tom Rochat. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    let oauthSwift = OAuth2Swift(
        consumerKey: "...",
        consumerSecret: "...",
        authorizeUrl: "https://accounts.spotify.com/authorize",
        responseType: "token")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func spotifyOauth(_ sender: Any) {
        oauthSwift.authorize(
            withCallbackURL: URL(string: "oauth-test://oauth-callback/spotify"),
            scope: "user-read-email",
            state: "SPOTIFY") { result in
                switch result {
                case .success(let (credential, _, _)):
                    print(credential.oauthToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}

