//
//  DitloPrivacy.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/23/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

enum PrivacyOption: String {
    case _private = "Private"
    case _friendsOnly = "Friends Only"
    case _public = "Public"
}

struct PrivacyOptionViewConfig {
    var privacyOption: PrivacyOption
    var name: String
    var description: String
}
