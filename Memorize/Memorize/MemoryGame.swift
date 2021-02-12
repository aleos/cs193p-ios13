//
//  MemoryGame.swift
//  Memorize
//
//  Created by Alexander Ostrovsky on 07.02.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var score = 0
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    private var timeOfLastPairChoice: Date?
    private var scoreTimeMultiplier: Int {
        guard let timeOfLastPairChoice = timeOfLastPairChoice else { return 1 } // without a multiplier at first
        let timeInterval = Date().timeIntervalSince(timeOfLastPairChoice)
        return max(10 - Int(timeInterval.rounded()), 1)
    }
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    incrementScore()
                } else {
                    if cards[chosenIndex].isSeen {
                        decrementScore()
                    }
                    if cards[potentialMatchIndex].isSeen {
                        decrementScore()
                    }
                }
                cards[chosenIndex].isFaceUp.toggle()
                cards[chosenIndex].isSeen = true
                cards[potentialMatchIndex].isSeen = true
                timeOfLastPairChoice = Date()
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    private mutating func incrementScore() {
        score += 2 * scoreTimeMultiplier
        print("Score time multiplier = \(scoreTimeMultiplier)")
    }
    
    private mutating func decrementScore() {
        score -= 1 * scoreTimeMultiplier
        print("Score time multiplier = \(scoreTimeMultiplier)")
    }
        
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen = false
        var content: CardContent
        var id: Int
    }
}
