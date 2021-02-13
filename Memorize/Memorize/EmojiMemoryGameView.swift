//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Alexander Ostrovsky on 07.02.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        viewModel.choose(card: card)
                    }
                    .padding(5)
                }
                Text("Score: \(viewModel.score)")
                    .padding()
            }
            .padding()
            .foregroundColor(viewModel.foregroundColor)
            .navigationBarTitle(viewModel.themeName)
            .navigationBarItems(trailing: Button("New Game") {
                viewModel.newGame()
            })
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90), clockwise: true).padding(5).opacity(0.4)
                    Text(card.content)
                        .font(.system(size: fontSize(for: geometry.size)))
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
    }
    
    // MARK: - Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.7
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
