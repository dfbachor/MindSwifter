//
//  ViewController.swift
//  MIneswifter
//
//  Created by David Bachor on 7/31/17.
//  Copyright © 2017 David Bachor. All rights reserved.
//
//
// https://www.makeschool.com/online-courses/tutorials/learn-swift-by-example
//

import UIKit

class ViewController: UIViewController {
    
    let BOARD_SIZE: Int = 12
    var board: Board
    var squareButtons:[SquareButton] = []
    var oneSecondTimer: Timer?
    
    var bombs: Int = 0 {
        didSet {
            self.bombsLable.text = "Bombs : \(bombs)"
            self.bombsLable.sizeToFit()
        }
    }
    
    var moves: Int = 0 {
        didSet {
            self.movesLabel.text = "Moves: \(moves)"
            self.movesLabel.sizeToFit()
        }
    }

    var timeTaken:Int = 0  {
        didSet {
            self.timeLabel.text = "Time: \(timeTaken)"
            self.timeLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet var bombsLable: UILabel!
    
    @IBAction func newGamePressed() {
        self.endCurrentGame()
        print("new game")
        self.startNewGame()
    }

    func oneSecond() {
        self.timeTaken += 1
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
        self.timeTaken = 0
        self.moves = 0
        
        startTimer()
        bombs = board.numberBombs
    }
    
    func startTimer() {
        if self.oneSecondTimer == nil {
            self.oneSecondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.oneSecond), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if self.oneSecondTimer != nil {
            self.oneSecondTimer?.invalidate()
            self.oneSecondTimer = nil
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.board = Board(size: BOARD_SIZE)
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeBoard()
        self.startNewGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMines() {
        for row in 0 ..< board.size {
            for col in 0 ..< board.size {
                let square = board.squares[row][col]
                if square.isMineLocation {
                    square.isRevealed = true
                    squareButtons[ row * board.size + col].setTitle("\(squareButtons[row * board.size + col].getLabelText())", for: .normal)
                    squareButtons[ row * board.size + col].backgroundColor = UIColor.red
                }
            
            }
        }
    }
    
    func minePressed() {
        // show an alert when you tap on a mine
        showMines()
        self.endCurrentGame()
        let alertView = UIAlertController()
        alertView.addAction(UIAlertAction(title: "New Game",
                                          style: .default,
                                          handler:{
                                            (action: UIAlertAction!) in
                                                print("Alert: New Game")
                                                self.startNewGame()
                                            }))
        
        
        alertView.title = "BOOM!"
        alertView.message = "You tapped on a mine."
        //alertView.show()
        //alertView.delegate = self
        self.present(alertView, animated: true){}
    }
    
    func squareButtonPressed(sender: SquareButton, recursive: Bool = false) {
        print("Pressed row:\(sender.square.row), col:\(sender.square.col)")
        
        if(!sender.square.isRevealed) {
            self.moves += 1
            sender.square.isRevealed = true
            sender.setTitle("\(sender.getLabelText())", for: .normal)
        } else {
            print("unrevealed square clicked")
            return // no action when asn already revealed square is clicked
        }
        
        if recursive == false && sender.square.isMineLocation {
            self.minePressed()
            return
        }

        
        // go to the board to get the neighboring squares
        // returns an array of squares
        let neighboringSquares = self.board.getNeighboringSquares(square: sender.square) // the sender here is the button

        // this is a list of squares that are around the currently clicked square
        print("squareButtonPressed recursive: \(recursive)")
        for neighboringSquare in neighboringSquares {
            
            if neighboringSquare.isRevealed  == false {
                print("neighboringSquare sender index: \(squareButtons[neighboringSquare.index].getLabelText())")
                
                let labelText = squareButtons[neighboringSquare.index].getLabelText()
                switch  labelText {
                    case "":
                        squareButtonPressed(sender: squareButtons[neighboringSquare.index], recursive: true)
                    default:
                        break
                        //do nothing
                }
                
                
                
            } else {
                
            }
        }
        
    }
    
    func initializeBoard() {
        var index: Int = 0 // set the value for the squares and squareButton index's
        
        for row in 0 ..< board.size {
            for col in 0 ..< board.size {
                
                let square = board.squares[row][col]
                let squareSize:CGFloat = self.boardView.frame.width / CGFloat(BOARD_SIZE)
                let squareButton = SquareButton(squareModel: square, squareSize: squareSize, squareMargin: 0.0);
                
                squareButton.setTitleColor(UIColor.darkGray, for: .normal)
                squareButton.addTarget(self, action: #selector(squareButtonPressed(sender:recursive:))
                    , for: .touchUpInside)
                
                squareButton.index = index
                square.index = index
                index += 1
                self.boardView.addSubview(squareButton)
                self.squareButtons.append(squareButton)
            }
        }
    }
    
    

    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetBoard()
        // iterates through each button and resets the text to the default value
        for squareButton in self.squareButtons {
            squareButton.setTitle("[X]", for: .normal)
            squareButton.backgroundColor = UIColor.white

        }
    }
    
    func endCurrentGame() {
        self.oneSecondTimer!.invalidate()
        self.oneSecondTimer = nil
        stopTimer()
    }
}

