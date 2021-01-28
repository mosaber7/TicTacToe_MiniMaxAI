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
    var xScore: Int                             = 0
    var oScore: Int                             = 0
    var currentState: String                    = ""
    var animationPositionsUsed: [AnimationView] = []
    let hardnessLevel: Int                      = 30
    var winner: piece                           = .E
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //intial move
        aiMove()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let xAnimation = animation(player: .X, playingSpot: false)
        xAnimation.frame = xAnimationView.bounds
        let oAnimation = animation(player: .O, playingSpot: false)
        oAnimation.frame = oAnimationView.bounds
        xAnimationView.addSubview(xAnimation)

        oAnimationView.addSubview(oAnimation)
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
            let animationView = animation(player: .O, playingSpot: true)
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
                let animationView = animation(player: .X, playingSpot: true)
                animationView.frame = tmpButton.bounds
                tmpButton.addSubview(animationView)
                
            }
            
         
            checkWinner()
        }
        
    }
    func animation(player: piece, playingSpot: Bool)-> AnimationView{
        let animationView = AnimationView()
        switch player {
        case .X:
            animationView.animation = Animation.named("sparta")
        case .O:
            animationView.animation = Animation.named("sparta2")
        case .E:
            animationView.animation = Animation.named("looser")
        }
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .playOnce
        if playingSpot{
        animationPositionsUsed.append(animationView)
        animationView.play()
        }
        return animationView
    }
    
    func checkWinner() {
        
        
        if game.isWin(){
            winner = game.turn.opposite
            performSegue(withIdentifier: "showWinner", sender: nil)
            switch winner {
            case .X:
                xScore += 1
                xScoreLabel.text = String(xScore)
            case.O:
                oScore += 1
                oScoreLabel.text = String(oScore)

            default:
                preconditionFailure("unexpected winner")
            }
            clearGameBoard()
        }
        else if game.isDraw{
            winner = .E
            performSegue(withIdentifier: "showWinner", sender: nil)
            clearGameBoard()
            
            
        }
    }
    
    func clearGameBoard(){
        game =  Board()
        for animationView in animationPositionsUsed {
            animationView.superview?.backgroundColor = .darkGray
            animationView.removeFromSuperview()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showWinner":
            let winingViewController = segue.destination as! WiningScreenViewController
            winingViewController.winner = winner
            winingViewController.winingAnimation = animation(player: winner, playingSpot: false)
        default:
            preconditionFailure("unexpected segue Identifier")
        }    }
    
    
}

