//
//  Spaceship.swift
//  ARGame
//
//  Created by Robert Ridley on 05/02/2018.
//  Copyright © 2018 Robert Ridley. All rights reserved.
//

import ARKit

class Spaceship: SCNNode {
    func loadModel(){
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
    }
}
