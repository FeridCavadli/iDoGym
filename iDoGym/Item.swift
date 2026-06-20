//
//  Item.swift
//  iDoGym
//
//  Created by Ferid on 20.06.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
