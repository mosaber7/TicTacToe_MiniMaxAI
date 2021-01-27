//
//  ViewController.swift
//  TicTacToe_AI
//
//  Created by Saber on 17/01/2021.
//

import UIKit
import Lottie

class TicTacToeViewController: UIViewController {
    
  //  @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var xScoreLabel: UILabel!
    @IBOutlet weak var oScoreLabel: UILabel!
    @IBOutlet weak var xAnimationView: UIView!
    @IBOutlet weak var oAnimationView: UIView!
    
    var game = Board()
    let oImg: UIImage?                          = UIImage(named: "O.png")
    let xImg: UIImage?                          = UIImage(named: "X.png")
    var xScore: Int                             = 0
    var oScore: Int                             = 0
    var currentState: String                    = ""
    var usedPositions: [UIButton]               = []
    var animationPositionsUsed: [AnimationView] = []
    let hardnessLevel: Int                      = 30
    let xAnimation , oAnimation                 = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xAnimation.animation = Animation.named("sparta2")
        xAnimation.frame = xAnimationView.bounds
        xAnimation.contentMode = .scaleAspectFit
        xAnimationView.addSubview(xAnimation)
        
        oAnimation.animation = Animation.named("sparta")
        oAnimation.frame = oAnimationView.bounds
        oAnimation.contentMode = .scaleAspectFit
        oAnimation.loopMode = .repeat(3)
        oAnimationView.addSubview(oAnimation)
        //intial move
        aiMove()
        
        
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        // o turn
        userMove(sender.tag)
        //x move (ai)
        aiMove()
            
    }
    
    
    
    func userMove(_ tag: Int){
        if game.turn == .O ,game.validMoves.contains(tag-1){
            let tmpButton = view.viewWithTag(tag) as! UIButton
            game = Board(position: game.move(tag-1).position, turn: game.turn.opposite, lastMove: tag-1)
            tmpButton.backgroundColor = .black
            let animationView = animation(player: .O)
            animationView.frame = tmpButton.bounds
            tmpButton.addSubview(animationView)
            
            checkWinner()
        }
        
    }
    
    func aiMove(){
        if game.turn == .X ,game.validMoves.contains(game.findBestMove(game, depth: hardnessLevel)){
            
            let xMove = game.findBestMove(game, depth: hardnessLevel)
            
            if let tmpButton = self.view.viewWithTag(xMove+1) as? UIButton{
                game = Board(position: game.move(xMove).position, turn: game.turn.opposite, lastMove: game.findBestMove(game, depth: hardnessLevel))
                tmpButton.backgroundColor = .black
                let animationView = animation(player: .X)
                animationView.frame = tmpButton.bounds
                tmpButton.addSubview(animationView)
                
            }
            
         
            checkWinner()
        }
        
    }
    func animation(player: piece)-> AnimationView{
        let animationView = AnimationView()
        switch player {
        case .X:
            animationView.animation = Animation.named("robot")
        case .O:
            animationView.animation = Animation.named("person")
        default: break

        }
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .loop
        animationPositionsUsed.append(animationView)
        animationView.play()
        return animationView
    }
    
    func checkWinner() {
        
        
        if game.isWin(){
            game.updateScore(&xScore, &oScore)
            xScoreLabel.text = String(xScore)
            oScoreLabel.text = String(oScore)
            let winner = game.turn.opposite
            clearGameBoard(board: usedPositions)
      
            switch winner {
            case .X:
                xAnimation.play()
            case .O:
                oAnimation.play()
            default:
                break
            }
        }
        else if game.isDraw{
            clearGameBoard(board: usedPositions)
            xAnimation.play()
            oAnimation.play()
            
        }
    }
    
    func clearGameBoard(board array: [UIButton]){
        game =  Board()
        for animationView in animationPositionsUsed {
            animationView.superview?.backgroundColor = .darkGray
            animationView.removeFromSuperview()
        }
    }
    
    
}

