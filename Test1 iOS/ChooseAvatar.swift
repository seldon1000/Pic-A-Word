//
//  ChooseCharacter.swift
//  sentiproviamo
//
//  Created by Nicolas Mariniello on 09/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class ChooseAvatar: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var avatarPreview = SKSpriteNode()
    private var previousButton = SKSpriteNode()
    private var nextButton = SKSpriteNode()
    
    private var goButton = SKLabelNode()
    
    private var selectedAvatar = 0
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        
        avatarPreview = childNode(withName: "avatarPreview") as! SKSpriteNode
        previousButton = childNode(withName: "previousButton") as! SKSpriteNode
        nextButton = childNode(withName: "nextButton") as! SKSpriteNode
        
        goButton = childNode(withName: "go") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        if goButton.contains(location!) {
            let chooseName = ChooseName(fileNamed: "ChooseName")
            chooseName?.scaleMode = .aspectFit
            chooseName?.selectedAvatar = selectedAvatar
            self.view?.presentScene(chooseName!)
        }
        else if previousButton.contains(location!) {
            if(selectedAvatar == 0){
                selectedAvatar = 9
            }
            else{
                selectedAvatar -= 1
            }
            avatarPreview.texture = SKTexture(imageNamed: String(selectedAvatar))
        }
        else if nextButton.contains(location!) {
            if(selectedAvatar == 9){
                selectedAvatar = 0
            }
            else{
                selectedAvatar += 1
            }
            avatarPreview.texture = SKTexture(imageNamed: String(selectedAvatar))
        }
    }
}
