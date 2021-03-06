//
//  Keyboard.swift
//  Test1 iOS
//
//  Created by Nicolas Mariniello on 11/07/2020.
//

import SpriteKit

class Keyboard {
    private var delButton: SKSpriteNode!
    private var spaceButton: SKSpriteNode!
    private var qButton: SKSpriteNode!
    private var wButton: SKSpriteNode!
    private var eButton: SKSpriteNode!
    private var rButton: SKSpriteNode!
    private var tButton: SKSpriteNode!
    private var yButton: SKSpriteNode!
    private var uButton: SKSpriteNode!
    private var iButton: SKSpriteNode!
    private var oButton: SKSpriteNode!
    private var pButton: SKSpriteNode!
    private var aButton: SKSpriteNode!
    private var sButton: SKSpriteNode!
    private var dButton: SKSpriteNode!
    private var fButton: SKSpriteNode!
    private var gButton: SKSpriteNode!
    private var hButton: SKSpriteNode!
    private var jButton: SKSpriteNode!
    private var kButton: SKSpriteNode!
    private var lButton: SKSpriteNode!
    private var zButton: SKSpriteNode!
    private var xButton: SKSpriteNode!
    private var cButton: SKSpriteNode!
    private var vButton: SKSpriteNode!
    private var bButton: SKSpriteNode!
    private var nButton: SKSpriteNode!
    private var mButton: SKSpriteNode!
    
    func create(currentScene: SKScene){
        delButton = currentScene.childNode(withName: "DEL") as? SKSpriteNode
        spaceButton = currentScene.childNode(withName: "space") as? SKSpriteNode
        qButton = currentScene.childNode(withName: "Q") as? SKSpriteNode
        wButton = currentScene.childNode(withName: "W") as? SKSpriteNode
        eButton = currentScene.childNode(withName: "E") as? SKSpriteNode
        rButton = currentScene.childNode(withName: "R") as? SKSpriteNode
        tButton = currentScene.childNode(withName: "T") as? SKSpriteNode
        yButton = currentScene.childNode(withName: "Y") as? SKSpriteNode
        uButton = currentScene.childNode(withName: "U") as? SKSpriteNode
        iButton = currentScene.childNode(withName: "I") as? SKSpriteNode
        oButton = currentScene.childNode(withName: "O") as? SKSpriteNode
        pButton = currentScene.childNode(withName: "P") as? SKSpriteNode
        aButton = currentScene.childNode(withName: "A") as? SKSpriteNode
        sButton = currentScene.childNode(withName: "S") as? SKSpriteNode
        dButton = currentScene.childNode(withName: "D") as? SKSpriteNode
        fButton = currentScene.childNode(withName: "F") as? SKSpriteNode
        gButton = currentScene.childNode(withName: "G") as? SKSpriteNode
        hButton = currentScene.childNode(withName: "H") as? SKSpriteNode
        jButton = currentScene.childNode(withName: "J") as? SKSpriteNode
        kButton = currentScene.childNode(withName: "K") as? SKSpriteNode
        lButton = currentScene.childNode(withName: "L") as? SKSpriteNode
        zButton = currentScene.childNode(withName: "Z") as? SKSpriteNode
        xButton = currentScene.childNode(withName: "X") as? SKSpriteNode
        cButton = currentScene.childNode(withName: "C") as? SKSpriteNode
        vButton = currentScene.childNode(withName: "V") as? SKSpriteNode
        bButton = currentScene.childNode(withName: "B") as? SKSpriteNode
        nButton = currentScene.childNode(withName: "N") as? SKSpriteNode
        mButton = currentScene.childNode(withName: "M") as? SKSpriteNode
    }
    
    func checkPress(location: CGPoint, textField: inout SKLabelNode){
        if (delButton.contains(location) && textField.text!.count > 0){
            textField.text?.removeLast()
        }
        else if (textField.text!.count < 14){
            if (spaceButton.contains(location) && textField.text?.last != " " && textField.text!.count > 0){
                textField.text! += " "
            }
            else if (qButton.contains(location)){
                textField.text! += "q"
            }
            else if (wButton.contains(location)){
                textField.text! += "w"
            }
            else if (eButton.contains(location)){
                textField.text! += "e"
            }
            else if (rButton.contains(location)){
                textField.text! += "r"
            }
            else if (tButton.contains(location)){
                textField.text! += "t"
            }
            else if (yButton.contains(location)){
                textField.text! += "y"
            }
            else if (uButton.contains(location)){
                textField.text! += "u"
            }
            else if (iButton.contains(location)){
                textField.text! += "i"
            }
            else if (oButton.contains(location)){
                textField.text! += "o"
            }
            else if (pButton.contains(location)){
                textField.text! += "p"
            }
            else if (aButton.contains(location)){
                textField.text! += "a"
            }
            else if (sButton.contains(location)){
                textField.text! += "s"
            }
            else if (dButton.contains(location)){
                textField.text! += "d"
            }
            else if (fButton.contains(location)){
                textField.text! += "f"
            }
            else if (gButton.contains(location)){
                textField.text! += "g"
            }
            else if (hButton.contains(location)){
                textField.text! += "h"
            }
            else if (jButton.contains(location)){
                textField.text! += "j"
            }
            else if (kButton.contains(location)){
                textField.text! += "k"
            }
            else if (lButton.contains(location)){
                textField.text! += "l"
            }
            else if (zButton.contains(location)){
                textField.text! += "z"
            }
            else if (xButton.contains(location)){
                textField.text! += "x"
            }
            else if (cButton.contains(location)){
                textField.text! += "c"
            }
            else if (vButton.contains(location)){
                textField.text! += "v"
            }
            else if (bButton.contains(location)){
                textField.text! += "b"
            }
            else if (nButton.contains(location)){
                textField.text! += "n"
            }
            else if (mButton.contains(location)){
                textField.text! += "m"
            }
        }
    }
}
