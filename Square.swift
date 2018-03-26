//
//  Square.swift
//  MIneswifter
//
//  Created by David Bachor on 7/31/17.
//  Copyright © 2017 David Bachor. All rights reserved.
//

import Foundation


class Square {
    let row: Int
    let col: Int
    
    var numNeighboringMines = 0
    var isMineLocation = false
    var isRevealed = false
    var index: Int = 0;

    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
}
