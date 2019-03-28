//
//  NotificationName.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/28/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    /*-- app delegate life cycle notifications --*/
    static let appDidReturnToForeground = Notification.Name("appDidReturnToForeground")
    static let appDidReturnToActiveState = Notification.Name("appDidReturnToActiveState")
}
