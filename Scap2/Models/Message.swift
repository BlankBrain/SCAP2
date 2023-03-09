//
//  Message.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var sender: String
    var text: String
    var received: Bool
    var timestamp: Date
}

