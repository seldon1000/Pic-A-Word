//
//  SimpleMenuScene.swift
//  Test1 tvOS
//
//  Created by Fabio Friano & Vincenzo Guida on 14/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class SimpleMenuScene: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var count = 0
    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector(("tapped")))
    private var button1 : SKLabelNode!
    private var aplayer  = [player]()
    private var index = 0
    private var  aronline = [SKSpriteNode] ()
    let start = SKAction.playSoundFileNamed("Sounds/song.mp3", waitForCompletion: false)
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        for i in (0..<connectedDevices.count) {
            aronline[i].texture = SKTexture(imageNamed: "green")
        }
        if connectedDevices.count >= 3 {
            button1.text = "TAP TO START THE MATCH"
        }
        if  connectedDevices.count > 5 {
            mpcManager.sendData(text: "clelia codes", peer: connectedDevices)
            
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene:SKScene = Whiteboard(fileNamed: "Whiteboard")!
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        let nam = data.suffix(data.count - 1)
        let av = data [data.startIndex]
        
        let a = player(id: fromPeer, name: SKLabelNode(text: "\(nam)"), point:SKLabelNode(text: "0") , avatar: SKSpriteNode(imageNamed: "\(av)"))
        aplayer.append(a)
        
        if aplayer.count == mpcManager.getConnectedPeers().count {
            trans()
        }
    }
    
    private func trans() {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let whiteboard = Whiteboard(fileNamed: "Whiteboard")
        whiteboard?.aplayer = aplayer
        self.view?.presentScene(whiteboard!, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        mpcManager.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SimpleMenuScene.tapScene(_:)))
        view.addGestureRecognizer(tapGesture)
        let pulse = SKAction(named: "Pulse")!
        button1 = (childNode(withName: "tap" )as!SKLabelNode)
        
        button1.run(SKAction.repeatForever(pulse))
        
        //        run(start, completion: {
        //            self.run(self.start)
        //        } )
        
        for i in (0...5){
            aronline.append(childNode(withName: "p\(i)") as!SKSpriteNode)
        }
    }
    
    @objc func tapScene(_ sender: UITapGestureRecognizer) {
        if count == 0 {
            mpcManager.startAdvertising()
            button1.text = "WAITING FOR PLAYERS TO CONNECT"
            count += 1
        }
        else if count == 1 {
            if mpcManager.getConnectedPeers().count < 3 {
                //              messaggio
                //        print("clelia zitta")
                button1.text = "WAITING FOR PLAYERS TO CONNECT: 3 players minimum required"
            }
            else {
                mpcManager.sendData(text: "schermatascelta", peer: mpcManager.getConnectedPeers())
                button1.text = "CHOOSE YOUR AVATAR"
            }
        }
    }
}
