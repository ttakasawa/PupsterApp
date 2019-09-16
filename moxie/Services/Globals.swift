//
//  Globals.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

let defs = UserDefaults.standard

class UNIX {
    static let minute: TimeInterval = 60.0
    static let hour = minute * 60.0
    static let day = hour * 24
    static let week = day * 7
    static let month = day * 30
    static let year = day * 365
}
