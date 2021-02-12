//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Alexander Ostrovsky on 07.02.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    private var theme: Theme
    
    private static let themes: [Theme] = [
        Theme(name: "Halloween", emojis: ["👻", "🎃", "🕷", "💀", "😱", "🧟", "🦇", "🪦", "🩸", "🔮", "🕯", "🧛"], numberOfPairsOfCards: 5, foregroundColor: .orange, fillGradient: LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)),
        Theme(name: "Animals", emojis: ["🐼", "🐔", "🦄", "🐶", "🐱", "🐭", "🐽", "🐍", "🐒"], numberOfPairsOfCards: 6, foregroundColor: .gray, fillGradient: nil),
        Theme(name: "Sports", emojis: ["🏀", "🏈", "⚾", "🏸", "🥎", "🏐", "🎱", "🥊", "🥋", "⛷", "🏂"], numberOfPairsOfCards: nil, foregroundColor: .blue, fillGradient: LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)),
        Theme(name: "Faces", emojis: ["😀", "😢", "😉", "😂", "😊", "🤪", "😍", "🥳", "🤩"], numberOfPairsOfCards: 5, foregroundColor: .yellow, fillGradient: nil),
        Theme(name: "Food", emojis: ["🍏", "🍆", "🍒", "🍇", "🍓", "🫐", "🌽", "🥩", "🍝", "🍔"], numberOfPairsOfCards: nil, foregroundColor: .green, fillGradient: LinearGradient(gradient: Gradient(colors: [.green, .yellow]), startPoint: .top, endPoint: .bottom)),
        Theme(name: "Transport", emojis: ["🚗", "✈️", "🚲", "⛵️", "🚌", "🚁", "🚀", "🛸", "🚇"], numberOfPairsOfCards: 5, foregroundColor: .red, fillGradient: nil),
    ]
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let numberOfPairsOfCards = theme.numberOfPairsOfCards ?? Int.random(in: 2...theme.emojis.count)
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    static func chooseAnotherTheme() -> Theme {
        themes.randomElement()!
    }
    
    init() {
        let theme = Self.chooseAnotherTheme()
        model = Self.createMemoryGame(theme: theme)
        self.theme = theme
    }
        
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    var score: Int {
        model.score
    }
    var foregroundColor: Color {
        theme.foregroundColor
    }
    var fillGradient: LinearGradient? {
        theme.fillGradient
    }
    var themeName: String {
        theme.name
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func newGame() {
        theme = Self.chooseAnotherTheme()
        model = Self.createMemoryGame(theme: theme)
    }
    
    struct Theme {
        let name: String
        let emojis: [String]
        let numberOfPairsOfCards: Int?
        let foregroundColor: Color
        let fillGradient: LinearGradient?
    }
}
