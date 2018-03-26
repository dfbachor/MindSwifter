//
//  SquareButton.swift
//  MIneswifter
//
//  Created by David Bachor on 7/31/17.
//  Copyright © 2017 David Bachor. All rights reserved.
//

import UIKit

class SquareButton : UIButton {
    
    let squareSize: CGFloat
    let squareMargin: CGFloat
    var square: Square
    var index: Int = 0;
    
    init(squareModel: Square, squareSize: CGFloat, squareMargin: CGFloat) {
        self.square = squareModel
        self.squareSize = squareSize
        self.squareMargin = squareMargin
       
        let x = CGFloat(self.square.col) * (squareSize + squareMargin)
        let y = CGFloat(self.square.row) * (squareSize + squareMargin)
        let squareFrame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        
        super.init(frame: squareFrame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelText() -> String {
        if !self.square.isMineLocation {
            if self.square.numNeighboringMines == 0 {
                // case 1: there's no mine and no neighboring mines
                return ""
            }else {
                // case 2: there's no mine but there are neighboring mines
                return "\(self.square.numNeighboringMines)"
            }
        }
        return "M"
    }
    
    
} // end class
