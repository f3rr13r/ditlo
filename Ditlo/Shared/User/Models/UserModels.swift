//
//  UserModels.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

struct ProfileUser {
    var id: String?
    var name: String?
    var profileImage: UIImage?
    var isLocationPermissionGranted: Bool?
    var job: String?
    var favouriteCategoryIds: [Int]?
    var friends: [String]?
    var friendsCount: Int?
    var following: [String]?
    var followingCount: Int?
    var followers: [String]?
    var followersCount: Int?
    var notificationsCount: Int?
    var unreadNotificationsCount: Int?
    var eventsCount: Int?
    var unreadEventNotificationsCount: Int?
    var hasNewDitlos: Bool?
    
    init(
        id: String? = nil,
        name: String? = nil,
        profileImage: UIImage? = nil,
        isLocationPermissionGranted: Bool? = nil,
        job: String? = nil,
        favouriteCategoryIds: [Int]? = nil,
        friends: [String]? = nil,
        friendsCount: Int? = nil,
        following: [String]? = nil,
        followingCount: Int? = nil,
        followers: [String]? = nil,
        followersCount: Int? = nil,
        notificationsCount: Int? = nil,
        unreadNotificationsCount: Int? = nil,
        eventsCount: Int? = nil,
        unreadEventNotificationsCount: Int? = nil,
        hasNewDitlos: Bool? = nil
        ) {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.isLocationPermissionGranted = isLocationPermissionGranted
        self.job = job
        self.favouriteCategoryIds = favouriteCategoryIds
        self.friends = friends
        self.friendsCount = friendsCount
        self.followers = followers
        self.followersCount = followersCount
        self.following = following
        self.followingCount = followingCount
        self.notificationsCount = notificationsCount
        self.unreadNotificationsCount = unreadNotificationsCount
        self.eventsCount = eventsCount
        self.unreadNotificationsCount = unreadNotificationsCount
        self.hasNewDitlos = hasNewDitlos
    }
}
