//
//  MainLobby.swift
//  sentiproviamo
//
//  Created by Nicolas Mariniello on 10/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class MainLobby: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var connectButton = SKLabelNode()
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        let chooseAvatar = ChooseAvatar(fileNamed: "ChooseAvatar")
        chooseAvatar?.scaleMode = .aspectFit
        self.view?.presentScene(chooseAvatar!)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        
        connectButton = childNode(withName: "connectButton") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        if connectButton.contains(location!){
            self.view?.window?.rootViewController?.present(mpcManager.getBrowser(), animated: true)
        }
    }
}
