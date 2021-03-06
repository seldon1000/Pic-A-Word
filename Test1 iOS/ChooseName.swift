//
//  ChooseCharacter.swift
//  sentiproviamo
//
//  Created by Nicolas Mariniello on 09/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class ChooseName: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    var selectedAvatar = 0
    
    private var textField = SKLabelNode()
    private var keyboard = Keyboard()
    private var goButton = SKSpriteNode()
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        
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
        
        if goButton.contains(location!) && textField.text!.count > 0 {
            mpcManager.sendData(text: String(selectedAvatar) + textField.text!, peer:  [mpcManager.getConnectedPeers().first!])
            
            let characterLobby = CharacterLobby(fileNamed: "CharacterLobby")
            characterLobby?.scaleMode = .aspectFit
            self.view?.presentScene(characterLobby!)
        }
        else {
            keyboard.checkPress(location: location!, textField: &textField)
        }
    }
}
