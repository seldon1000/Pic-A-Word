//
//  Whiteboard.swift
//  Test1 iOS
//
//  Created by Nicolas Mariniello & Fabio Friano & Vincenzo Guida on 11/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class Whiteboard: SKScene, MPCManagerDelegate {
    var mpcManager = MPCManager.sharedInstance
    
    private var previousTouchPoint = CGPoint.zero
    private var erase = SKSpriteNode()
    
    private var sheet = SKSpriteNode()
    private var rubButton = SKSpriteNode()
    private var blackColor = SKSpriteNode()
    private var yellowColor = SKSpriteNode()
    private var greenColor = SKSpriteNode()
    private var blueColor = SKSpriteNode()
    private var redColor = SKSpriteNode()
    private var previousChoosen = SKSpriteNode()
    
    private var drawingItem = SKSpriteNode()
    private var erasingItem = SKSpriteNode()
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {

            let scoreScreen = ScoreScreen(fileNamed: "ScoreScreen")
            scoreScreen?.scaleMode = .aspectFit
            scoreScreen?.score = data 
            self.view?.presentScene(scoreScreen)
    }
    
    private func drawLine(location: CGPoint) {
        if previousChoosen.zRotation == 0 {
            erasingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 1.5 + previousTouchPoint.y)
            erase.position = location
            
            for i in Int(erase.position.x - erase.size.width / 2)...Int(erase.position.x + erase.size.width / 2) {
                for j in Int(erase.position.y - erase.size.height / 2)...Int(erase.position.y + erase.size.height / 2) {
                    if !sheet.contains(CGPoint(x: i, y: j)) && !erasingItem.contains(CGPoint(x: i, y: j)) && !erase.contains(CGPoint(x: i, y: j)) {
                        DispatchQueue.main.async {
                            self.removeChildren(in: self.nodes(at: CGPoint(x: i, y: j)))
                        }
                    }
                }
            }
        }
        else {
            drawingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 2.8 + previousTouchPoint.y)
            
            let line = SKShapeNode()
            line.fillColor = previousChoosen.color
            line.strokeColor = previousChoosen.color
            line.lineWidth = 5
            
            let path = UIBezierPath()
            path.move(to: location)
            path.addLine(to: previousTouchPoint)
            line.removeFromParent()
            line.path = path.cgPath
            addChild(line)
        }
        
        previousTouchPoint = location
    }
    
    private func pressButtonActions(button: SKSpriteNode) {
        previousChoosen.size = CGSize(width: previousChoosen.size.width * 0.714286, height: previousChoosen.size.height * 0.714286)
        button.size = CGSize(width: button.size.width * 1.4, height: button.size.height * 1.4)
        previousChoosen = button
        sendColor()
        drawingItem.texture = button.texture
        
        if button != rubButton {
            mpcManager.sendData(text: "rubOff", peer: [mpcManager.getConnectedPeers().first!])
        }
        else{
            mpcManager.sendData(text: "rubOn", peer: [mpcManager.getConnectedPeers().first!])
        }
    }
    
    private func showItem(location : CGPoint) {
        if previousChoosen.zRotation == 0 {
            erasingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 1.5 + previousTouchPoint.y)
            erase.position = location
            addChild(erasingItem)
            addChild(erase)
        }
        else {
            drawingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 2.8 + previousTouchPoint.y)
            addChild(drawingItem)
        }
    }
    
    private func sendColor() {
        switch previousChoosen.color {
        case .init(red: 0, green: 0, blue: 0, alpha: 1):
            mpcManager.sendData(text: "black", peer: [mpcManager.getConnectedPeers().first!])
        case .yellow:
            mpcManager.sendData(text: "yellow", peer: [mpcManager.getConnectedPeers().first!])
        case .green:
            mpcManager.sendData(text: "green", peer: [mpcManager.getConnectedPeers().first!])
        case .blue:
            mpcManager.sendData(text: "blue", peer: [mpcManager.getConnectedPeers().first!])
        case .red:
            mpcManager.sendData(text: "red", peer: [mpcManager.getConnectedPeers().first!])
        default:
            print("clelia codes")
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
        
        sheet = childNode(withName: "sheet") as! SKSpriteNode
        rubButton = childNode(withName: "rubButton") as! SKSpriteNode
        blackColor = childNode(withName: "blackColor") as! SKSpriteNode
        yellowColor = childNode(withName: "yellowColor") as! SKSpriteNode
        greenColor = childNode(withName: "greenColor") as! SKSpriteNode
        blueColor = childNode(withName: "blueColor") as! SKSpriteNode
        redColor = childNode(withName: "redColor") as! SKSpriteNode
        rubButton.color = .white
        blackColor.color = .black
        yellowColor.color = .yellow
        greenColor.color = .green
        blueColor.color = .blue
        redColor.color = .red
        
        drawingItem.texture = SKTexture(imageNamed: "blackIcon")
        drawingItem.size.width = 30
        drawingItem.size.height = 70
        drawingItem.zRotation = 5.5
        drawingItem.zPosition = CGFloat(100)
        erasingItem.texture = SKTexture(imageNamed: "eraserIcon")
        erasingItem.size.width = 70
        erasingItem.size.height = 70
        erasingItem.zRotation = 0
        erasingItem.zPosition = CGFloat(100)
        erase.isHidden = true
        erase.zPosition = CGFloat(100)
        erase.texture = SKTexture(imageNamed: "circle")
        erase.size = CGSize(width: 15, height: 15)
        
        previousChoosen = blackColor
        previousChoosen.size = CGSize(width: previousChoosen.size.width * 1.4, height: previousChoosen.size.height * 1.4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self)
        
        if rubButton.contains(location!) {
            pressButtonActions(button: rubButton)
        }
        else if blackColor.contains(location!) {
//            pressButtonActions(button: blackColor)
            self.view?.window?.rootViewController?.present(mpcManager.getBrowser(), animated: true)
        }
        else if yellowColor.contains(location!) {
            pressButtonActions(button: yellowColor)
        }
        else if greenColor.contains(location!) {
            pressButtonActions(button: greenColor)
        }
        else if blueColor.contains(location!) {
            pressButtonActions(button: blueColor)
        }
        else if redColor.contains(location!) {
            pressButtonActions(button: redColor)
        }
        else if !sheet.contains(location!) {
            previousTouchPoint = location!
            mpcManager.sendData(text: String(format: "coordinates %@", NSCoder.string(for: location!)), peer: [mpcManager.getConnectedPeers().first!])
            
            showItem(location: location!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            if !sheet.contains(location) {
                mpcManager.sendData(text: String(format: "coordinates %@", NSCoder.string(for: location)), peer: [mpcManager.getConnectedPeers().first!])
                drawLine(location: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mpcManager.sendData(text: "ended", peer: [mpcManager.getConnectedPeers().first!])
        drawingItem.removeFromParent()
        erasingItem.removeFromParent()
        erase.removeFromParent()
    }
}
