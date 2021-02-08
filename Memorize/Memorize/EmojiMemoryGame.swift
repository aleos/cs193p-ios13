//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Alexander Ostrovsky on 07.02.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    @Published private var theme: Theme
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let numberOfPairsOfCards = theme.numberOfPairsOfCards ?? Int.random(in: 2...theme.emojis.count)
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    static func chooseAnotherTheme() -> Theme {
        [
            Theme(name: "Halloween", emojis: ["👻", "🎃", "🕷", "💀", "😱", "🧟", "🦇", "🪦", "🩸", "🔮", "🕯", "🧛"], numberOfPairsOfCards: nil, color: .orange),
            Theme(name: "Animals", emojis: ["🐼", "🐔", "🦄"], numberOfPairsOfCards: 3, color: .white),
            Theme(name: "Sports", emojis: ["🏀", "🏈", "⚾", "🏸"], numberOfPairsOfCards: nil, color: .blue),
            Theme(name: "Faces", emojis: ["😀", "😢", "😉"], numberOfPairsOfCards: 3, color: .yellow),
            Theme(name: "Food", emojis: ["🍏", "🍆", "🍒", "🍇", "🍓"], numberOfPairsOfCards: 5, color: .red),
            Theme(name: "Transport", emojis: ["🚗", "✈️", "🚲", "⛵️", "🚌"], numberOfPairsOfCards: 5, color: .red),
        ].randomElement()!
    }
    
    init() {
        let theme = Self.chooseAnotherTheme()
        model = Self.createMemoryGame(theme: theme)
        self.theme = theme
    }
        
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    struct Theme {
        let name: String
        let emojis: [String]
        let numberOfPairsOfCards: Int?
        let color: Color
    }
}
