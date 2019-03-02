//
//  Game.swift
//  RandomRectanglesNav
//
//  Created by Kaelyn Campbell on 11/8/18.
//  Copyright © 2018 Kaelyn Campbell. All rights reserved.
//

import UIKit

typealias PieceID = Int

class Game: NSObject {
    private var setId = 0
    private var setpairId = 0
    private var countIds = 0
    private var selected = false
    var scoreArray = [Int]()
    // save the pieces
    private var gameDict = [PieceID : GamePiece]()
    
    func createPiece() -> PieceID {
        setId += 1
        countIds += 1
        // game piece
        let setPiece = GamePiece(pieceId: setId, pairId: setpairId)
        gameDict[setId] = setPiece
        // if a pair has been created update pairId
        if countIds % 2 == 0 {
            setpairId += 1
        }
        return setId
    }
    
    func isSelected(pieceID id: PieceID) -> Bool {
        if(selected == true) {
            return true
        }
        else {
            return false
        }
    }
    var tempScore = 0
    func updateScore(score: Int) -> [Int] {
        scoreArray.insert(score, at:0)
        tempScore = score
        return scoreArray
    }
    
    func getLastScore() -> Int {
        return tempScore
    }
    
    func getScores() -> [Int] {
        return scoreArray
    }
    
    func select(pieceID id: PieceID) {
        selected = true
    }
    
    func deselect(pieceID id: PieceID) {
        selected = false
    }
    
    func isSamePair(pieceID id1: PieceID, pieceID id2: PieceID) -> Bool {
        return gameDict[id1]?.getPairId() == gameDict[id2]?.getPairId()
    }
    
}
