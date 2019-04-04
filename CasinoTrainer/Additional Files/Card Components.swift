//
//  Card Components.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation

enum Suit: Int {
    case none, diamonds, hearts, spades, clubs
    func description() -> String {
        switch self {
        case .diamonds: return "Diamonds"
        case .hearts: return "Hearts"
        case .spades: return "Spades"
        case .clubs: return "Clubs"
        default: return "None"
        }
    }
}
enum Rank: Int {
    case nothing, ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    func description() -> String {
        switch self {
        case .ace: return "Ace"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "Jack"
        case .queen: return "Queen"
        case .king: return "King"
        default: return "Nothing"
        }
    }
    func giveValue() -> Int {
        switch self {
        case .ace:
            return 11
        case .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten:
            return rawValue
        case .jack, .queen, .king:
            return 10
        default: return 0
        }
    }
}

struct Card {
    let color: Suit
    let picture: Rank
    
    init() {
        color = Suit.none
        picture = Rank.nothing
    }
    init(_ suit: Int,_ rank: Int) {
        color = Suit.init(rawValue: suit)!
        picture = Rank.init(rawValue: rank)!
    }
    func description() -> String {
        return "\(picture.description()) of \(color.description())"
    }
    func imageDescription() -> String {
        return "\(picture.description())\(color.description())"
    }
    func giveValue() -> Int {
        return picture.giveValue()
    }
    
}

class Deck {
    var cardDeck: [Card]
    
    init() {
        cardDeck = Array<Card>(repeating: Card(), count: 52)
        initializeDeck()
    }
    
    func initializeDeck() {
        var counter = 0
        for i in 1...4 {
            for j in 1...13 {
                cardDeck[counter] = Card(i, j)
                counter += 1
            }
        }
    }
    func giveCard(_ number: Int) -> Card {
        if number >= 0 && number < 52 {
            return cardDeck[number]
        }
        else {
            return Card()
        }
    }
}

