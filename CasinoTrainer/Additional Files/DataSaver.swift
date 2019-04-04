//
//  DataSaver.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 13.02.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

class DataSaver {
    
    static func saveGuest(guest: Player) {
        UserDefaults.standard.set(guest.playerName, forKey: "PlayerName")
        UserDefaults.standard.set(guest.initialCapital, forKey:"InitialCapital")
        UserDefaults.standard.set(guest.balance, forKey: "Balance")
        UserDefaults.standard.set(guest.arraysToDictionary(), forKey: "PlayerDictionary")
        UserDefaults.standard.set(guest.bjStats.BlackJackStatsToDictionary(), forKey: "BlackJackDictionary")
        UserDefaults.standard.set(guest.rouStats.rouletteStatToDictionary(), forKey: "RouletteDictionary")
        UserDefaults.standard.synchronize()
    }
    static func retrieveGuest() -> Player {
        let name = UserDefaults.standard.string(forKey: "PlayerName")
        if name != nil {
            let initialCapital = UserDefaults.standard.float(forKey: "InitialCapital")
            let balance = UserDefaults.standard.float(forKey: "Balance")
            let playerDictionary = UserDefaults.standard.dictionary(forKey: "PlayerDictionary")
            let blackJackDictionary = UserDefaults.standard.dictionary(forKey: "BlackJackDictionary")
            let rouletteDictionary = UserDefaults.standard.dictionary(forKey: "RouletteDictionary")
            return Player(name: name!, capital: initialCapital, balance: balance, bjStatData: blackJackDictionary as! [String : Int], rouStatData: rouletteDictionary as! [String : [Int]], otherArrays: playerDictionary as! [String : [Float]])
        }
        else {
            return Player()
        }
    }
}
