//
//  ViewController.swift
//  oauth-test
//
//  Created by Tom Rochat on 06/02/2020.
//  Copyright © 2020 Tom Rochat. All rights reserved.
//

import UIKit
import OAuthSwift
import KeychainSwift

class ViewController: UIViewController {
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!

    private var isConnected: Bool = false

    private let keychain = KeychainSwift()
    private let oauthSwift = OAuth2Swift(
        consumerKey: "...",
        consumerSecret: "...",
        authorizeUrl: "https://accounts.spotify.com/authorize",
        responseType: "token")

    private let TOKEN_KEY = "spotify-oauth-token"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let token = keychain.get(TOKEN_KEY) {
            setConnectedState(with: token)
        } else {
            setDisconnectedState()
        }
    }

    @IBAction func handleSpotifyOauth(_ sender: Any) {
        if !isConnected {
            oauthSwift.authorize(
                withCallbackURL: URL(string: "oauth-test://oauth-callback/spotify"),
                scope: "user-read-email",
                state: "SPOTIFY") { result in
                    switch result {
                    case .success(let (credential, _, _)):
                        self.keychain.set(credential.oauthToken, forKey: self.TOKEN_KEY)
                        self.setConnectedState(with: credential.oauthToken)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            return
        }
        keychain.delete(TOKEN_KEY)
        setDisconnectedState()
    }

    private func setConnectedState(with token: String) -> Void {
        isConnected = true
        authBtn.setTitle("Logout from Spotify", for: .normal)
        stateLabel.text = "You are connected to spotify"
        tokenLabel.isHidden = false
        tokenLabel.text = token
    }

    private func setDisconnectedState() -> Void {
        isConnected = false
        authBtn.setTitle("Login to Spotify", for: .normal)
        stateLabel.text = "You are NOT connected to spotify"
        tokenLabel.isHidden = true
        tokenLabel.text = ""
    }
}

