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
                    CardView(card: card, fillGradient: viewModel.fillGradient).onTapGesture {
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
    var fillGradient: LinearGradient?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90), clockwise: true).padding(5).opacity(0.4)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        if let fillGradient = fillGradient {
                            RoundedRectangle(cornerRadius: cornerRadius).fill(fillGradient)
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius).fill()
                        }
                    }
                }
            }
            .font(.system(size: fontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
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
