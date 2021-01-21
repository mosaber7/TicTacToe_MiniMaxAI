//
//  ViewController.swift
//  TicTacToe_AI
//
//  Created by Saber on 17/01/2021.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var xScoreLabel: UILabel!
    @IBOutlet weak var oScoreLabel: UILabel!
    
    var game = Board()
    let oImg: UIImage? = UIImage(named: "O.png")
    let xImg: UIImage? = UIImage(named: "X.png")
    var xScore: Int = 0
    var oScore: Int = 0
    var currentState: String = ""
    var usedPositions: [UIButton] = []
    // 20 for easy level
    // 30 for hard level
    var hardnessLevel: Int = 30
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //intial move
        aiMove()
        
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        // o turn
        userMove(sender)
        //x move (ai)
        aiMove()
            
    }
    
    @IBAction func modeSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            hardnessLevel = 30
        }
        else {
            hardnessLevel = 20
        }
    }
    
    
    func userMove(_ sender: UIButton){
        if game.turn == .O ,game.validMoves.contains(sender.tag-1){
            sender.setBackgroundImage(UIImage(named: "O.png"), for: .normal)
            game = Board(position: game.move(sender.tag-1).position, turn: game.turn.opposite, lastMove: sender.tag-1)
            usedPositions.append(sender)
            checkWinner()
        }
        
    }
    
    func aiMove(){
        if game.turn == .X ,game.validMoves.contains(game.findBestMove(game, depth: hardnessLevel)){
            
            let xMove = game.findBestMove(game, depth: hardnessLevel)
            
            if let tmpButton = self.view.viewWithTag(xMove+1) as? UIButton{
                game = Board(position: game.move(xMove).position, turn: game.turn.opposite, lastMove: game.findBestMove(game, depth: hardnessLevel))
                tmpButton.setBackgroundImage(xImg, for: .normal)
                usedPositions.append(tmpButton)
                
            }
            
         
            checkWinner()
        }
        
    }
    
    func checkWinner() {
        if game.isWin(){
            
            game.updateScore(&xScore, &oScore)
            xScoreLabel.text = String(xScore)
            oScoreLabel.text = String(oScore)
            let winner = game.turn.opposite
            clearGameBoard(board: usedPositions)
            stateLabel.text = "\(winner) WINS🔥🔥🔥"
        }
        else if game.isDraw{
            clearGameBoard(board: usedPositions)
            stateLabel.text = "TIE! 🤝"
        }
        // the normal state when the players still playing
        else{
            if stateLabel.text != nil{
                stateLabel.text = "\(game.turn)'s turn"
            }
        }
    }
    
    func clearGameBoard(board array: [UIButton]){
        game =  Board()
        for button in array{
            button.setBackgroundImage(nil, for: .normal)
        }
    }
    
}

