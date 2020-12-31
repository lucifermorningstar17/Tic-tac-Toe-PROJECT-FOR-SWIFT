//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Shriram on 30/12/20.
//  Copyright © 2020 Macco. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var playerNameLbl: UILabel!
    
    @IBOutlet weak var playerScoreLbl: UILabel!
    
    @IBOutlet weak var computerScoreLbl: UILabel!

    @IBOutlet weak var box1: UIImageView!
    @IBOutlet weak var box2: UIImageView!
    @IBOutlet weak var box3: UIImageView!
    @IBOutlet weak var box4: UIImageView!
    @IBOutlet weak var box5: UIImageView!
    @IBOutlet weak var box6: UIImageView!
    @IBOutlet weak var box7: UIImageView!
    @IBOutlet weak var box8: UIImageView!
    @IBOutlet weak var box9: UIImageView!
    
    var playerName: String!
    var lastValue = "o"
    
    var playerChoices: [Box] = []
    var computerChoices: [Box] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerNameLbl.text = playerName + ":"
        
        createTap(on: box1, type: .one)
        createTap(on: box2, type: .two)
        createTap(on: box3, type: .three)
        createTap(on: box4, type: .four)
        createTap(on: box5, type: .five)
        createTap(on: box6, type: .six)
        createTap(on: box7, type: .seven)
        createTap(on: box8, type: .eight)
        createTap(on: box9, type: .nine)
    }
    
    
    func createTap(on imageView:UIImageView,type box:Box){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.boxClicked(sender:)))
        tap.name = box.rawValue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }

    @objc func boxClicked(sender : UITapGestureRecognizer){
        let selectedBox = getBox(from: sender.name ?? "")
        makeChoice(selectedBox: selectedBox)
        playerChoices.append(Box(rawValue:sender.name!)!)
        checkIfWon()
        
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
    self.computerPlay()
    }
    }
    func computerPlay(){
        var availableSpaces = [UIImageView]()
        var availableBoxes = [Box]()
        for name in Box.allCases{
            let box = getBox(from: name.rawValue)
            if box.image == nil{
                availableSpaces.append(box)
                availableBoxes.append(name)
            }
            
        }
        guard availableBoxes.count > 0 else { return }
        let randIndex = Int.random(in:0 ..< availableSpaces.count)
        makeChoice(selectedBox: availableSpaces[randIndex])
        computerChoices.append(availableBoxes[randIndex])
        checkIfWon()
    }
    func makeChoice( selectedBox:UIImageView){
        
        guard selectedBox.image == nil else {return}
        
        if lastValue == "x"{
            selectedBox.image = #imageLiteral(resourceName: "oh")
            lastValue = "o"
        } else {
            selectedBox.image = #imageLiteral(resourceName: "ex")
            lastValue = "x"
        }
     
        
        
    }
    
    func checkIfWon(){
        var correct = [[Box]]()
        let firRow: [Box] = [.one, .two, .three]
        let secRow: [Box] = [.four, .five, .six]
        let thrRow: [Box] = [.seven, .eight, .nine]
        
        let firCol: [Box] = [.one, .four, .seven]
        let secCol: [Box] = [.two, .five, .eight]
        let thrCol: [Box] = [.three, .six, .nine]
        
        let backwardSlash: [Box] = [.one, .five, .nine]
        let forwardSlash: [Box] = [.three, .five, .seven]
        
        correct.append(firRow)
        correct.append(secRow)
        correct.append(thrRow)
        correct.append(firCol)
        correct.append(secCol)
        correct.append(thrCol)
        correct.append(backwardSlash)
        correct.append(forwardSlash)
        
        for valid in correct {
            let userMatch = playerChoices.filter{valid.contains($0)}.count
            let computerMatch = computerChoices.filter{valid.contains($0)}.count
            
            if userMatch == valid.count {
                playerScoreLbl.text = String((Int(playerScoreLbl.text ?? "0") ?? 0) + 1)
                resetGame()
                break;
            }else if computerMatch == valid.count{
                
                computerScoreLbl.text = String((Int(computerScoreLbl.text ?? "0") ?? 0) + 1)
                resetGame()
                break;
            } else if computerChoices.count + playerChoices.count == 9{
                
            }
        }
    }
    
    func resetGame(){
        for name in Box.allCases {
            let box = getBox(from: name.rawValue)
            box.image = nil
        }
        lastValue = "o"
        playerChoices = []
        computerChoices = []
    }
    
   func getBox(from name: String)->UIImageView{
        let box = Box(rawValue: name) ?? .one
        switch box {
        case .one:
            return box1
        case .two:
            return box2
        case .three:
            return box3
        case .four:
            return box4
        case .five:
            return box5
        case .six:
            return box6
        case .seven:
            return box7
        case .eight:
            return box8
        case .nine:
            return box9
        
        }
        
        
        
    }
    
    @IBAction func closeBtnPressed(sender : UIButton){
        dismiss(animated : true, completion : nil)
        
    }
}



enum Box:String,CaseIterable{
    case one,two,three,four,five,six,seven,eight,nine
}
