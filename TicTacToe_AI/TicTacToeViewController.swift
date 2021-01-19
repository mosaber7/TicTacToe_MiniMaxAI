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
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func buttonTapped(_ sender: UIButton) {

            // o turn
            if game.turn == .O ,game.validMoves.contains(sender.tag){
                sender.setBackgroundImage(UIImage(named: "O.png"), for: .normal)
                game = Board(position: game.move(sender.tag).position, turn: game.turn.opposite, lastMove: sender.tag)
                usedPositions.append(sender)
                
           }
            //x move (ai)
            else if game.validMoves.contains(game.findBestMove(game)){
                
                let xMove = game.findBestMove(game)
                
                
                if let tmpButton = self.view.viewWithTag(xMove) as? UIButton{
                    game = Board(position: game.move(xMove).position, turn: game.turn.opposite, lastMove: game.findBestMove(game))
                    tmpButton.setBackgroundImage(xImg, for: .normal)
                    usedPositions.append(tmpButton)
                
                }else{
                    let tmpindex = game.validMoves.randomElement()!
                    let tmpButton = self.view.viewWithTag(tmpindex) as? UIButton
                    game = Board(position: game.move(tmpindex).position, turn: game.turn.opposite, lastMove: game.findBestMove(game))
                    tmpButton?.setBackgroundImage(xImg, for: .normal)
                    usedPositions.append(tmpButton!)
                    
                }
            
        }
         checkWinner()

    }
    func checkWinner() {
        if game.isWin(){
            stateLabel.text = "\(game.turn.opposite) WINS🔥🔥🔥"
            game.updateScore(&xScore, &oScore)
                xScoreLabel.text = String(xScore)
                oScoreLabel.text = String(oScore)
            clearGameBoard(board: usedPositions)
        }
        else if game.isDraw{
            stateLabel.text = "TIE! 🤝"
        }
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

