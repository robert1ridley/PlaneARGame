//
//  ViewController.swift
//  ARGame
//
//  Created by Robert Ridley on 05/02/2018.
//  Copyright © 2018 Robert Ridley. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startGame(_ sender: UIButton) {
        gameBegin()
    }
    
    var counter = 0 {
        didSet {
            counterLabel.text = "Score \(counter)"
        }
    }
    
    var gameTimer: Timer!
    
    var currentTime = 20 {
        didSet {
            timerLabel.text = "Time \(currentTime)"
            if currentTime <= 0 {
                finalScoreLabel.text = "Final Score: \(self.counter)"
                finalScoreLabel.isHidden = false
                finalScoreLabel.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1)
                finalScoreLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                gameTimer.invalidate()
                startButton.isHidden = false
            }
        }
    }
    
    func gameBegin(){
        startButton.isHidden = true
        counter = 0
        currentTime = 20
        finalScoreLabel.isHidden = true
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    @objc func runTimedCode() {
        self.currentTime = self.currentTime - 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        addObject()
    }
    
    func addObject() {
        let ship = Spaceship()
        ship.loadModel()
        
        let xPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        let yPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        ship.position = SCNVector3(xPos, yPos, -1)
        sceneView.scene.rootNode.addChildNode(ship)
    }
    
    func randomPosition(lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: sceneView)
            
            let hitlist = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitlist.first {
                let node = hitObject.node
                
                if node.name == "shipMesh", self.currentTime > 0, finalScoreLabel.isHidden == true {
                    counter += 1
                    node.removeFromParentNode()
                    addObject()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

