//
//  LoseScene.swift
//  FlappyBird
//
//  Created by Mark Kinoshita on 1/9/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion
import GameKit
import StoreKit
import UIKit

class LoseScene: SKScene, GKGameCenterControllerDelegate {
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
        
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    var new_highscore = SKLabelNode()
    var highscore_label = SKLabelNode()
    var game_center = SKSpriteNode()
    var restart_button = SKSpriteNode()
    var home_button = SKSpriteNode()
    var score_label = SKLabelNode()
    //    var highscore_label = SKLabelNode()
    override func didMove(to view: SKView) {
        let music = SKAudioNode(fileNamed:"retro.wav")
        addChild(music)
        new_highscore = self.childNode(withName:"new_highscore") as! SKLabelNode
        if score > highscore {
            highscore = score
            saveHighscore(gameScore: highscore)
            HighscoreDefault.set(highscore, forKey: "Highscore")
            new_highscore.text = "New Highscore!"
        }
        highscore_label = self.childNode(withName:"highscore_label") as! SKLabelNode
        score_label = self.childNode(withName: "score_label") as! SKLabelNode
        game_center = self.childNode(withName: "game_center") as! SKSpriteNode
        restart_button = self.childNode(withName: "restart_button") as! SKSpriteNode
        home_button = self.childNode(withName: "home_button") as! SKSpriteNode
        score_label.text = NSString(format: "Score: %i", score) as String
         highscore_label.text = NSString(format: "Highscore: %i", HighscoreDefault.integer(forKey: "Highscore")) as String
        let controller = self.view?.window?.rootViewController as! GameViewController
        if streak >= 2 {
            if streak % 2 == 0 {
            controller.presentAd()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if restart_button.contains(touchLocation){
            score = 0
            self.removeAllChildren()
            let reveal = SKTransition.fade(withDuration: 1.0)
            let scene = GameScene(fileNamed: "GameScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!, transition: reveal)
        }
        if game_center.contains(touchLocation){
            showLeader()
        }
        if home_button.contains(touchLocation) {
            score = 0
            self.removeAllChildren()
            let reveal = SKTransition.fade(withDuration: 1.0)
            let scene = MainMenu(fileNamed: "MainMenu")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!, transition: reveal)
        }
    }
    func saveHighscore(gameScore: Int) {
        print ("You have a high score!")
        print("\n Attempting to authenticating with GC...")
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            print("\n Success! Sending highscore of \(score) to leaderboard")
            let my_leaderboard_id = "airball_leaderboard"
            let scoreReporter = GKScore(leaderboardIdentifier: my_leaderboard_id)
            
            scoreReporter.value = Int64(gameScore)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print("An error has occured:")
                }
            })
        }
    }
}
