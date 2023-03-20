//
//  RandomNumberGenerator.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 11/3/23.
//

import Foundation
import CryptoSwift

class Crypto{
    public static let randomNumber = Int(arc4random_uniform(100)) + 1
    public static let randomDouble = Double.random(in: 0.0...1.0)
    
    public static var letters = (0..<128).compactMap { UnicodeScalar($0).map(Character.init) }
    public static var randomLetter = letters.randomElement()!

    
    
    
    
    
   public static func shuffleChar(array: inout [Character]) {
        for i in 0..<array.count {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            array.swapAt(i, randomIndex)
        }
    }
    public static func shuffleInt(array: inout [Int]) {
        for i in 0..<array.count {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            array.swapAt(i, randomIndex)
        }
    }


}

public extension Array where Element == Int {
    static func generateNonRepeatedRandom(size: Int) -> [Int] {
        guard size > 0 else {
            return [Int]()
        }
        return Array(0..<size).shuffled()
    }
}


