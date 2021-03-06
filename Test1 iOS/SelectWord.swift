//
//  SelectWord.swift
//  Test1 iOS
//
//  Created by Nicolas Mariniello on 16/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class SelectWord: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    var words = [String]()
    private var word1 = SKLabelNode()
    private var word2 = SKLabelNode()
    private var word3 = SKLabelNode()
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        
    }
    
    func selectWord(word: String) {
        mpcManager.sendData(text: word, peer: [mpcManager.getConnectedPeers().first!])
        
        let whiteboard = Whiteboard(fileNamed: "Whiteboard")
        whiteboard?.scaleMode = .aspectFit
        self.view?.presentScene(whiteboard!)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        
        word1 = childNode(withName: "word1") as! SKLabelNode
        word2 = childNode(withName: "word2") as! SKLabelNode
        word3 = childNode(withName: "word3") as! SKLabelNode
        
        word1.text = words[0]
        word2.text = words[1]
        word3.text = words[2]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        if word1.contains(location!){
            selectWord(word: word1.text!)
        }
        else if word2.contains(location!) {
            selectWord(word: word2.text!)
        }
        else if word3.contains(location!) {
            selectWord(word: word3.text!)
        }
    }
}
