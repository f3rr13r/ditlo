//
//  CategoriesUtilities.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/27/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

func getCategoryColour(withId id: Int) -> UIColor {
    let parentId: Int = id % 1000
    
    switch parentId {
    case 1:
        // music -- purple
        return ditloPurple
    case 2:
        // arts
        return ditloDarkGreen
    case 3:
        // sports
        return ditloRed
    case 4:
        // outdoors
        return ditloLightGreen
    case 5:
        // social
        return ditloYellow
    case 6:
        // fashion
        return ditloOrange
    case 7:
        // business
        return ditloDarkBlue
    case 8:
        // politics
        return ditloLightBlue
    default: return ditloOffWhite
    }
}


