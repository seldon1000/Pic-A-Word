//
//  File.swift
//  Test1 tvOS
//
//  Created by Fabio Friano on 14/07/2020.
//

import Foundation
import SpriteKit
import MultipeerConnectivity

struct player{
                  var id : MCPeerID!
                  var name : SKLabelNode!
                  var point : SKLabelNode!
                  var avatar : SKSpriteNode!
                  var correct : Bool!
              }
