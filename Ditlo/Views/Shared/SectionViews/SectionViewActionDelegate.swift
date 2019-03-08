//
//  SectionViewActionDelegate.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

protocol SectionViewActionDelegate {
    func taggedFriendCellSelected(withId taggedFriendId: String)
    func taggedEventCellSelected(withId taggedEventId: String)
    func taggedCategoryCellSelected(withId taggedCategoryId: String)
    func taggedKeywordCellSelected(withValue keywordValue: String)
    func taggedLocationSelected(withLocationValue locationValue: Any)
}
