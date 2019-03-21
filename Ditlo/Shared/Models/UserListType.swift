//
//  UserListType.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

enum UserListType: String {
    case friends = "Friends"
    case following = "Following"
    case followers = "Followers"
    case members = "Members"
}

struct UserListConfiguration {
    var userId: String
    var isOwnProfile: Bool
    var userListType: UserListType
}
