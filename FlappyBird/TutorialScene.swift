//
//  TutorialScene.swift
//  FlappyBird
//
//  Created by Mark Kinoshita on 1/10/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import UIKit


class TutorialScene : SKScene {
    override func didMove(to view: SKView) {
        scene?.scaleMode = SKSceneScaleMode.aspectFill
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllChildren()
        let reveal = SKTransition.fade(withDuration: 1.0)
        let scene = MainMenu(fileNamed: "MainMenu")
        scene?.scaleMode = .aspectFill
        self.view?.presentScene(scene!, transition: reveal)
    }
}

