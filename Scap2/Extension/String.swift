//
//  String.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//

import Foundation
import UIKit

extension String {
    
    // Returns a string with the first letter capitalized.
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
 
    
    // Returns a string with all leading and trailing whitespaces removed.
    var trimmingWhitespace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Returns a boolean value indicating whether the string contains only digits.
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    // Returns a boolean value indicating whether the string contains only letters.
    var isAlphabetic: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    // Returns a boolean value indicating whether the string is a valid email address.
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    // Returns a boolean value indicating whether the string is a valid URL.
    var isValidURL: Bool {
        return URL(string: self) != nil
    }
    
    // Returns a boolean value indicating whether the string is a valid phone number.
    func isValidPhoneNumber(minLength: Int = 8, maxLength: Int = 15) -> Bool {
        let phoneNumberRegex = "^[0-9]{\(minLength),\(maxLength)}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: self)
    }
    
//    // Returns a substring starting from the specified index with the specified length.
//    func substring(fromIndex index: Int, length: Int) -> String? {
//        if index < 0 || index + length > count {
//            return nil
//        }
//        return String(self[index..<index+length])
//    }
    
    // Returns a string with the specified suffix removed.
    func removingSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            let endIndex = self.index(self.endIndex, offsetBy: -suffix.count)
            return String(self[..<endIndex])
        }
        return self
    }
    
    // Returns a string with the specified prefix removed.
    func removingPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            let startIndex = self.index(self.startIndex, offsetBy: prefix.count)
            return String(self[startIndex...])
        }
        return self
    }
    
    // Returns a string with the specified character removed.
    func removingCharacter(_ character: Character) -> String {
        return filter { $0 != character }
    }
    
//    // Returns a string with the specified character at the specified index removed.
//    func removingCharacter(at index: Int) -> String? {
//        if index < 0 || index >= count {
//            return nil
//        }
//        let endIndex = self.index(self.startIndex, offsetBy: index)
//        return self.replacingCharacters(at: endIndex, with: "")
//    }
//
//    // Returns a string with the specified string added at the specified index.
//    func inserting(_ string: String, at index
//
    
    
    //Truncate string to a specified length, adding "..." at the end if it's longer than the specified length:
    func truncated(to length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return "\(self[..<index])..."
        } else {
            return self
        }
    }
    
    //Remove all whitespace characters from a string:
    func removingWhitespace() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    //Return a random string of a specified length:
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //Check if a string contains only alphanumeric characters:
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    // Convert a string to title case:
    func titleCased() -> String {
        let source = self.lowercased()
        var result = ""
        var nextIsCap = true
        for char in source {
            if char == " " || char == "-" || char == "_" || char == "." {
                nextIsCap = true
                result.append(char)
            } else if nextIsCap {
                nextIsCap = false
                result.append(char.uppercased())
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    
    
    //toBase64() - Encodes the string to Base64 format.
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    // fromBase64() - Decodes a Base64 encoded string.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    //reversedWords() - Reverses the order of words in the string.
    func reversedWords() -> String {
        let words = self.components(separatedBy: " ")
        let reversedWords = words.reversed().joined(separator: " ")
        return reversedWords
    }
    
    // capitalizedFirst() - Returns the string with the first letter capitalized.
    func capitalizedFirst() -> String {
        guard let firstChar = first else { return self }
        return String(firstChar).capitalized + dropFirst()
    }
    
}

// static function that accepts a string and returns an attributed string with any email or phone number underlined:
extension NSAttributedString {
    static func underlineEmailsAndPhoneNumbers(in string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .link]
        let detector = try? NSDataDetector(types: types.rawValue)
        let range = NSRange(location: 0, length: string.utf16.count)
        
        detector?.enumerateMatches(in: string, options: [], range: range) { (match, _, _) in
            guard let matchRange = match?.range else { return }
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: matchRange)
        }
        
        return attributedString
    }
}

