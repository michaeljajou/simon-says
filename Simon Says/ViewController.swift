//
//  ViewController.swift
//  Simon Says
//
//  Created by Michael Jajou on 11/7/18.
//  Copyright © 2018 Michael Jajou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var colorButtons: [CircularButton]!
    
    @IBOutlet var actionButton: UIButton!
    
    @IBOutlet var playerLabels: [UILabel]!
    
    @IBOutlet var scoreLabels: [UILabel]!
    
    var currentPlayer = 0
    var scores = [0,0]
    
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()
    
    var gameEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtons = colorButtons.sorted {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted {
            $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted {
            $0.tag < $1.tag
        }
        
        createNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded == true {
            gameEnded = false
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        for button in colorButtons {
            button.alpha = 0.5
            button.isEnabled = false
        }
        
        currentPlayer = 0
        scores = [0,0]
        playerLabels[0].alpha = 1.0
        playerLabels[1].alpha = 0.75
        scoreLabels[0].alpha = 1.0
        scoreLabels[1].alpha = 0.75
    }
    
    func updateScoreLabels() {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.75
        scoreLabels[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1:0
        playerLabels[currentPlayer].alpha = 1.0
        scoreLabels[currentPlayer].alpha = 1.0
    }
    
    func addNewColor() {
        let randomInt = Int(arc4random_uniform(UInt32(4)))
        colorSequence.append(randomInt)
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flashButton(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the Circles", for: .normal)
            for button in colorButtons {
                button.isEnabled = true
            }
        }
    }
    
    func flashButton(button: CircularButton) {
        UIView.animate(withDuration: 0.7, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (bool) in
            self.playSequence()
        }
    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
    }

    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst() {
            
        } else {
            for button in colorButtons {
                button.isEnabled = false
            }
            endGame()
            return
        }
        if colorsToTap.isEmpty {
            for button in colorButtons {
                button.isEnabled = false
            }
            scores[currentPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }
    
    @IBAction func actionBtnHandler(_ sender: Any) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        addNewColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
}

