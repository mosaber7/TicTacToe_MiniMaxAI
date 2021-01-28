//
//  WiningViewController.swift
//  TicTacToe_AI
//
//  Created by Saber on 28/01/2021.

import UIKit
import Lottie

class WiningScreenViewController: UIViewController{
    @IBOutlet var winingAnimationView: UIView!
    @IBOutlet var winingLabel: UILabel!
    
    var winner : piece!
    var winingAnimation: AnimationView!
    
    override func viewWillAppear(_ animated: Bool) {
        switch winner {
        case .E:
            winingLabel.text = "DRAW 🤝🤝🤝"
        default:
            winingLabel.text = "\(winner!) WINS 🔥🔥🔥"
        }
        
        winingAnimation.frame = winingAnimationView.bounds
        winingAnimationView.addSubview(winingAnimation!)
        winingAnimation.play()
    }
   
    
    
}
