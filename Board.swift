//
//  Board.swift
//  MIneswifter
//
//  Created by David Bachor on 7/31/17.
//  Copyright © 2017 David Bachor. All rights reserved.
//

import Foundation


class Board {
    let size: Int
    var squares: [[Square]] = []
    var numberBombs: Int = 0
    
    init(size: Int) {
        self.size = size
        
        for row in 0 ..< size {
            var squareRow: [Square] = []
            
            for col in 0 ..< size {
                let square = Square(row: row, col: col)
                squareRow.append(square)
            }
            squares.append(squareRow)
        }
    } // end init
    
    func resetBoard() {
        numberBombs = 0
        for row in 0 ..< size {
            for col in 0 ..< size {
                squares[row][col].isRevealed = false
                self.calculateIsMineLocationForSquare(square: squares[row][col])
                if squares[row][col].isMineLocation {
                    numberBombs += 1
                }
            }
        }
        
        for row in 0 ..< size {
            for col in 0 ..< size {
                self.calculateNumNeighborMinesForSquare(square: squares[row][col])
            }
        }
    }
    
    func calculateIsMineLocationForSquare(square: Square) {
        square.isMineLocation = ((arc4random()%10) == 0) // 1-in-10 chance that each location contains a mine
    }
    
    
    func calculateNumNeighborMinesForSquare(square: Square) {
        let neighbors = getNeighboringSquares(square: square)
        var numNeighboringMines = 0
        
        for neighborSquare in neighbors {
         
            if neighborSquare.isMineLocation {
                numNeighboringMines += 1
            }
        }
        square.numNeighboringMines = numNeighboringMines
    }
    
    
    func getNeighboringSquares(square: Square) ->  [Square] {
        var neighbors: [Square] = []
        let adjacentOffsets = [(-1,-1),(0,-1),(1,-1),
                               (-1,0),(1,0),
                               (-1,1),(0,1),(1,1)]
        
        for (rowOffset, colOffset) in adjacentOffsets {
            let optionalNeighbor: Square? = getTileAtAllocation(row: square.row + rowOffset, col: square.col + colOffset)
            if let neighbor = optionalNeighbor {
                neighbors.append(neighbor)
            }
        }
        
        return neighbors
    }
    
    
    func getTileAtAllocation(row: Int, col: Int) -> Square? {
        if row >= 0 &&
            row < self.size &&
            col >= 0 &&
            col < self.size {
            
            return squares[row][col]
        } else {
            return nil
        }
    }
    
    
    
}
