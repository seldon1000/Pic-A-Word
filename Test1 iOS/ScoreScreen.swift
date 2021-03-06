//
//  ScoreScreen.swift
//  Test1 iOS
//
//  Created by utente on 20/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class ScoreScreen: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var loadingIcon = SKSpriteNode()
    private var draw = false
    private var words = [String]()
    private var scoreLabel = SKLabelNode()
    var score = ""
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        if draw {
            words.append(data)
        }
        else if data == "false" {
            let guessScreen = GuessScreen(fileNamed: "GuessScreen")
            guessScreen?.scaleMode = .aspectFit
            self.view?.presentScene(guessScreen!)
        }
        else {
            draw = true
        }
        
        if words.count > 2 {
            let selectWord = SelectWord(fileNamed: "SelectWord")
            selectWord?.scaleMode = .aspectFit
            selectWord?.words = words
            self.view?.presentScene(selectWord!)
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        

        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = score
        
        loadingIcon = childNode(withName: "loadingIcon") as! SKSpriteNode
        loadingIcon.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 2.5)))
    }
}
