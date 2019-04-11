//
//  MainMenu.swift
//  FlappyBird
//
//  Created by Mark Kinoshita on 1/8/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion
import GameKit
import StoreKit
import UIKit

class MainMenu: SKScene, GKGameCenterControllerDelegate, UIGestureRecognizerDelegate {
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
        
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    var highscore_label = SKLabelNode()
    var tutorialButton = SKSpriteNode()
    var rate_button = SKSpriteNode()
    var game_center = SKSpriteNode()
    var startButton = SKSpriteNode()
//    var highscore_label = SKLabelNode()
    override func didMove(to view: SKView) {
        let music = SKAudioNode(fileNamed:"retro.wav")
        addChild(music)
        // scene?.scaleMode = SKSceneScaleMode.aspectFill
    //    highscore_label = self.childNode(withName: "highscore_label") as! SKLabelNode
        game_center = self.childNode(withName: "game_center") as! SKSpriteNode
        startButton = self.childNode(withName: "startButton") as! SKSpriteNode
        tutorialButton = self.childNode(withName: "tutorialButton") as! SKSpriteNode
        rate_button = self.childNode(withName: "rate_button") as! SKSpriteNode
        highscore_label = self.childNode(withName: "highscore_label") as! SKLabelNode
       highscore_label.text = NSString(format: "Highscore: %i", HighscoreDefault.integer(forKey: "Highscore")) as String
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if startButton.contains(touchLocation){
            self.removeAllChildren()
            let reveal = SKTransition.fade(withDuration: 1.0)
            let scene = GameScene(fileNamed: "GameScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!, transition: reveal)
        }
        if game_center.contains(touchLocation){
            showLeader()
        }
        if tutorialButton.contains(touchLocation) {
            self.removeAllChildren()
            let reveal = SKTransition.fade(withDuration: 1.0)
            let scene = TutorialScene(fileNamed: "TutorialScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!, transition: reveal)
        }
        if rate_button.contains(touchLocation) {
            SKStoreReviewController.requestReview()
        }
    }
    
}
