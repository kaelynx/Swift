//
//  GamePiece.swift
//  RandomRectanglesNav
//
//  Created by Kaelyn Campbell on 11/8/18.
//  Copyright © 2018 Kaelyn Campbell. All rights reserved.
//

import UIKit

typealias PairID = Int

class GamePiece : NSObject {
    private var pairId: PairID
    private var pieceId: PieceID
    
    init(pieceId: PieceID, pairId: PairID) {
        self.pieceId = pieceId
        self.pairId = pairId
    }
    
    func setPairId() -> PairID {
        pairId += 1
        return pairId
    }
    
    func getPairId() -> PairID {
        return pairId
    }
    
}
