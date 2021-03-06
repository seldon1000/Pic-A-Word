//
//  Whiteboard.swift
//  Test1 tvOS
//
//  Created by Nicolas Mariniello on 17/07/2020.
//

import SpriteKit
import MultipeerConnectivity

class Whiteboard: SKScene, MPCManagerDelegate {
    private var mpcManager = MPCManager.sharedInstance
    
    private var previousTouchPoint = CGPoint.zero
    
    private var ended = false
    private var currentColor = UIColor.black
    
    private var drawingItem = SKSpriteNode()
    private var erasingItem = SKSpriteNode()
    private var erase = SKSpriteNode()
    private var rub = false
    private var sheet = SKSpriteNode()
    
   
    private var timer = SKLabelNode()
    private var ar = [String]()
    private var w1: String = ""
    private var w2: String = ""
    private var w3: String = ""
    private var correct: String = ""
    private var s: String = ""
    private var turn: Int = 0
    private var turnnumber: Int = 0
    private var ok = false
    private var inturn = false
    private var ingame = false
    private var drawingplayer: MCPeerID!
     private var TimerNode = 60
    private var labelround : SKLabelNode!
     private var labeldraw : SKLabelNode!
    private var ti : SKLabelNode!
    private var  ncorrect : Int = 0
    
    let start = SKAction.playSoundFileNamed("Sounds/start.m4a", waitForCompletion: false)
    let stop = SKAction.playSoundFileNamed("Sounds/stop.wav", waitForCompletion: false)
    
    var aplayer = [player]()
    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector(("tapped")))
    
    func connectedDevicesChanged(manager: MPCManager, connectedDevices: [MCPeerID]) {
        //        mpcManager.sendData(text: "ciao", peer: connectedDevices)
    }
    
    func receivedData(data: String, fromPeer: MCPeerID) {
        if TimerNode > 0 {
           
            if fromPeer != drawingplayer {
                if data == correct.lowercased() {
                    point(id: fromPeer)
                   ncorrect+=1
                }
            }
            else {
               switch data {
                case w1, w2, w3:
                    ok = true
                    correct = data
                case "ended":
                    drawingItem.removeFromParent()
                    erasingItem.removeFromParent()
                    erase.removeFromParent()
                    ended = true
                case "black":
                    drawingItem.texture = SKTexture(imageNamed: "blackIcon")
                    currentColor = .black
                case "yellow":
                    drawingItem.texture = SKTexture(imageNamed: "yellowIcon")
                    currentColor = .yellow
                case "green":
                    drawingItem.texture = SKTexture(imageNamed: "greenIcon")
                    currentColor = .green
                case "blue":
                    drawingItem.texture = SKTexture(imageNamed: "blueIcon")
                    currentColor = .blue
                case "red":
                    drawingItem.texture = SKTexture(imageNamed: "redIcon")
                    currentColor = .red
                case "rubOn":
                    erasingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 1.5 + previousTouchPoint.y)
                    rub = true
                case "rubOff":
                    drawingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 2.8 + previousTouchPoint.y)
                    rub = false
                default:
                    if ended == true || previousTouchPoint == CGPoint.zero {
                        previousTouchPoint = NSCoder.cgPoint(for: data)
                        ended = false
                        
                        if rub {
                            erasingItem.position = CGPoint(x: drawingItem.size.width * 2 + previousTouchPoint.x, y: drawingItem.size.height / 2.8 + previousTouchPoint.y)
                            erase.position = previousTouchPoint
                            addChild(erasingItem)
                            addChild(erase)
                        }
                        else {
                            drawingItem.position = CGPoint(x: drawingItem.size.width + previousTouchPoint.x, y: drawingItem.size.height / 2.8 + previousTouchPoint.y)
                            addChild(drawingItem)
                        }
                    }
                    else {
                        drawLine(location: NSCoder.cgPoint(for: data))
                    }
                }
            }
        }
    }
    
    private func drawLine(location: CGPoint) {
        if rub {
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
            line.fillColor = currentColor
            line.strokeColor = currentColor
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
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        mpcManager.delegate = self
//        mpcManager.startAdvertising()
        print(size.width)
        print(size.height)
        

        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SimpleMenuScene.tapScene(_:)))
        DispatchQueue.main.async {
            view.addGestureRecognizer(tapGesture)
        }
        buildWords(ar: &ar)
        
        timer = (childNode(withName: "timer") as!SKLabelNode)
        labeldraw = (childNode(withName: "labeldraw") as!SKLabelNode)
        labelround = (childNode(withName: "labelround") as!SKLabelNode)
        ti = (childNode(withName: "ti") as!SKLabelNode)
        labelround.removeFromParent()
        labeldraw.text = "TAP TO START THE MATCH"
        ti.removeFromParent()
//        timer.removeFromParent()
        for i in (0..<aplayer.count){
            aplayer[i].avatar.size = CGSize(width: 200, height: 200)
            aplayer[i].point.color = .orange
            aplayer[i].name.color = .orange
            aplayer[i].correct = false
        }
        rank()
        
        
    }
    
    
    func timerstart() {
        
//        self.addChild(self.timer)
        self.timer.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.TimerNode -= 1
            self.timer.text = "\(self.TimerNode)"
            if self.ncorrect == self.aplayer.count{
                self.TimerNode = 0
            }
            if self.TimerNode <= 0 {
                self.run(self.stop)
                self.aplayer.sort {
                $0.point.text! > $1.point.text!
                }
                self.timer.removeAllActions()
                self.removeAllChildren()
                self.rank ()

//                self.timer.removeAllActions()
//                self.removeAllChildren()
                self.turnnumber += 1
                if self.turnnumber == 4 {
            print("fine \(self.turnnumber)")
                               //            finale
                    self.addChild(self.labelround)
                    self.labelround.text = "THE WINNER IS \(self.aplayer[0].name!)"
                    
                    self.aplayer[0].avatar.position = CGPoint(x: 0, y: 0)
                    self.labelround.position = CGPoint (x: 0, y: self.aplayer[0].avatar.position.y - self.aplayer[0].avatar.size.height)
                    self.addChild(self.aplayer[0].avatar)
                
                                       
                                                   }
                else{
                    for t in self.aplayer {
                        if t.correct == false {
                            self.mpcManager.sendData(text: t.point.text!, peer: [t.id])
                        }
                    }
                
                self.addChild(self.timer)
                self.timer.text = " Time Expired"
                 self.TimerNode = 5
                    self.turn += 1
               
                if (self.turn == self.aplayer.count){
                                self.turn = 0
                            }
                
//                 add lavel
                    self.addChild(self.labelround)
                    self.addChild(self.labeldraw)
                    self.addChild(self.ti)
               
                
                       self.ti.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                                       self.TimerNode -= 1
                        self.ti.text = "\(self.TimerNode)"
                                       if self.TimerNode < 1 {
                                           self.ti.removeAllActions()
                                          self.TimerNode = 60
                                        self.labelround.removeFromParent()
                                        self.labeldraw.removeFromParent()
                                        self.ti.removeFromParent()
                                                         self.match()
                                       }
                                       },SKAction.wait(forDuration: 1)])))
                            
               
                
            }
            }
            },SKAction.wait(forDuration: 1)])))
        
        
    }
  func rank() {

    aplayer[0].avatar.position = CGPoint(x: 850, y: 420)

    aplayer[0].point.position = CGPoint(x: 850, y: aplayer[0].avatar.position.y - aplayer[0].avatar.size.height / 2 - 20 )
    
    
    aplayer[0].point.fontColor = .systemOrange

    aplayer[0].point.fontSize = 32
    aplayer[0].point.fontName = "Helvetica Neue Medium"
    addChild(aplayer[0].avatar)

    addChild(aplayer[0].point)

    

    for i in (1..<aplayer.count){

        

        aplayer[i].avatar.position = CGPoint(x: 850, y: aplayer[i-1].avatar.position.y - aplayer[i-1].avatar.size.height - 20 )

        aplayer[i].point.position = CGPoint(x: 850 ,y: aplayer[i].avatar.position.y - aplayer[i].avatar.size.height / 2 - 35)

        addChild(aplayer[i].avatar)
        aplayer[i].point.fontColor = .systemOrange
//        aplayer[i].point.color = .orange
        aplayer[i].point.fontSize = 32
        aplayer[i].point.fontName = "Helvetica Neue Medium"
        addChild(aplayer[i].point)
        
    

    }
}
    func point(id: MCPeerID) {
        var score = 100 - (60 - TimerNode)
        
        for i in (0..<aplayer.count) {
            if aplayer[i].id == id {
                score += Int(aplayer[i].point.text!)!
                aplayer[i].point.text = String(score)
                mpcManager.sendData(text: String(score), peer: [id])
                aplayer[i].correct = true
            }
        }
    }
    
    func getwords() {
        w1 = ar[Int.random(in: 0 ... ar.count-1 )]
        w2 = ar[Int.random(in: 0 ... ar.count-1 )]
        
        while w2 == w1 {
            w2 = ar[Int.random(in: 0 ... ar.count-1)]
        }
        
        w3 = ar[Int.random(in: 0 ... ar.count-1)]
        while w3 == w1 || w3 == w2 {
            w3 = ar[Int.random(in: 0 ... ar.count-1)]
        }
    }
    
    func match() {

        ingame = true
        inturn = true
        for i in (0..<aplayer.count){
            aplayer[i].correct = false
        }
        getwords()
        while inturn {
           
            inturn = false
          
           print("inturn")
            for i in (0..<aplayer.count) {

                if turn == i {
//                    aplayer[i].isdrawing = true
                    mpcManager.sendData(text: "true", peer: [aplayer[i].id])
                    mpcManager.sendData(text: w1, peer: [aplayer[i].id])
                    mpcManager.sendData(text: w2, peer: [aplayer[i].id])
                    mpcManager.sendData(text: w3, peer: [aplayer[i].id])
                    drawingplayer = aplayer[i].id
                }
                else {
//                    aplayer[i].isdrawing = false
                    mpcManager.sendData(text: "false", peer: [aplayer[i].id!])
                }
            }
            
            while !ok {

            }
      
            run(start, completion: timerstart)
           
//
//                         aggiorno
//
//            aplayer.sort {
//                $0.point.text! < $1.point.text!
//            }
            
            }
            
    
        
    }
    
    @objc func tapScene(_ sender: UITapGestureRecognizer) {
        
        if ingame == false {
            labeldraw.removeFromParent()
            match()
        }
    }
}
