//
//  RouletteComponents.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation
enum RouletteColor {
    case green, red, black
    func description() -> String {
        switch self {
        case .green:
            return "green"
        case .red:
            return "red"
        case .black:
            return "black"
        }
    }
}
struct RouletteNumber {
    let number: Int
    let color: RouletteColor
    
    init(_ n: Int) {
        if n >= 0 && n <= 36 {
            number = n
        }
        else {
            number = 0
        }
        switch number {
        case 0:
            color = .green
        case 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36:
            color = .red
        case 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35:
            color = .black
        default:
            color = .green
        }
    }
    func giveColor() -> RouletteColor {
        return color
    }
    func giveNumberAndColor() -> String {
        return "\(number), \(color.description())"
    }
}
struct RouletteWheel {
    var wheel: [RouletteNumber]
    init() {
        self.wheel = Array<RouletteNumber>(repeating: RouletteNumber(0), count: 37)
        for i in 0...36 {
            self.wheel[i] = RouletteNumber(i)
        }
    }
    func whatNumber(random: Int) -> RouletteNumber {
        return wheel[random]
    }
}

class RouletteBet {
    let numbers: [Int]
    let payout: Int
    init() {
        numbers = [0]
        payout = 36
    }
    init(numbers: [Int],_ payout: Int) {
        self.numbers = numbers
        self.payout = payout
    }
}
enum Outside {
    case even, odd, red, black, low, high
    func description() -> String {
        switch self {
        case .even:
            return "EVEN"
        case .odd:
            return "ODD"
        case .black:
            return "BLACK"
        case .red:
            return "RED"
        case .low:
            return "LOW"
        case .high:
            return "HIGH"
        }
    }
}
enum Inside {
    case straightUp, split, street, firstThree, firstFour, corner, sixLine, dozen, column
    func description() -> String {
        switch self {
        case .straightUp:
            return "Straight Up"
        case .split:
            return "Split"
        case .column:
            return "Column"
        case .dozen:
            return "Dozen"
        case .corner:
            return "Corner"
        case .firstFour:
            return "First Four"
        case .firstThree:
            return "First Three"
        case .sixLine:
            return "Six Line"
        case .street:
            return "Street"
        }
    }
}
class OutsideBet : RouletteBet {
    let type: Outside
    init(type: Outside) {
        self.type = type
        switch type {
        case .even:
            super.init(numbers: [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36],2)
        case .odd:
            super.init(numbers: [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35],2)
        case .black:
            super.init(numbers: [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35],2)
        case .red:
            super.init(numbers: [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36],2)
        case .low:
            super.init(numbers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],2)
        case .high:
            super.init(numbers: [19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36],2)
        }
    }
    func description() -> String {
        return type.description()
    }
}
class InsideBet: RouletteBet {
    let type: Inside
    init(type: Inside, number: Int, def: Int) {
        self.type = type
        if type == .column {
            switch number {
            case 1:
                super.init(numbers: [1,4,7,10,13,16,19,22,25,28,31,34],3)
            case 2:
                super.init(numbers: [2,5,8,11,14,17,20,23,26,29,32,35],3)
            case 3:
                super.init(numbers: [3,6,9,12,15,18,21,24,27,30,33,36],3)
            default:
                super.init(numbers: [0],36)
            }
        }
        else if type == .firstThree {
            super.init(numbers: [0,1,2], 12)
        }
        else if type == .firstFour {
            super.init(numbers: [0,1,2,3], 9)
        }
        else if type == .dozen {
            switch number {
            case 1:
                super.init(numbers: [1,2,3,4,5,6,7,8,9,10,11,12], 3)
            case 2:
                super.init(numbers: [13,14,15,16,17,18,19,20,21,22,23,24], 3)
            case 3:
                super.init(numbers: [25,26,27,28,29,30,31,32,33,34,35,36], 3)
            default:
                super.init(numbers: [0], 36)
            }
        }
        else if type == .corner {
            super.init(numbers: [number,number+1,number+3, number+4], 9)
        }
        else if type == .sixLine {
            super.init(numbers: [number,number+1,number+2,number+3,number+4,number+5], 6)
        }
        else if type == .street {
            super.init(numbers: [number,number+1,number+2], 12)
        }
        else if type == .split {
            switch def {
            case 1:
                super.init(numbers: [number, number+1], 18)
            case 2:
                super.init(numbers: [number, number+3], 18)
            default:
                super.init(numbers: [0], 36)
            }
        }
        else {
            super.init(numbers: [number],36)
        }
    }
    func description() -> String {
        switch type {
        case .straightUp:
            return "\(type.description()) \(numbers[0])"
        case .firstThree, .firstFour:
            return type.description()
        case .dozen:
            return "\(type.description()) \(numbers[0]) to \(numbers[11])"
        case .column:
            return "\(type.description()) \(numbers[0])"
        case .sixLine:
            return "\(type.description()) \(numbers[0]) to \(numbers[5])"
        case .street:
            return "\(type.description()) \(numbers[0]) to \(numbers[2])"
        case .corner:
            return "\(type.description()) \(numbers[0]) to \(numbers[3])"
        case .split:
            return "\(type.description()) \(numbers[0]) / \(numbers[1])"
        }
    }
}
