//
//  GuessScreen.swift
//  Test1 iOS
//
//  Created by Nicolas Mariniello on 11/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class GuessScreen: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var textField = SKLabelNode()
    private var keyboard = Keyboard()
    private var goButton = SKSpriteNode()
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {

            let scoreScreen = ScoreScreen(fileNamed: "ScoreScreen")
            scoreScreen?.scaleMode = .aspectFit
            scoreScreen?.score = data
            self.view?.presentScene(scoreScreen)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        
        textField = childNode(withName: "textField") as! SKLabelNode
        keyboard.create(currentScene: view.scene!)
        goButton = childNode(withName: "go") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        if goButton.contains(location!) && !textField.text!.isEmpty {
            mpcManager.sendData(text: textField.text!, peer: [mpcManager.getConnectedPeers().first!])
        }
        else {
            keyboard.checkPress(location: location!, textField: &textField)
        }
    }
}
