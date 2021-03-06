//
//  CharacterLobby.swift
//  Test1 iOS
//
//  Created by Nicolas Mariniello on 11/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class CharacterLobby: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var loadingIcon = SKSpriteNode()
    private var draw = false
    private var words = [String]()
    
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
        
        
        loadingIcon = childNode(withName: "loadingIcon") as! SKSpriteNode
        loadingIcon.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 2.5)))
    }
}
