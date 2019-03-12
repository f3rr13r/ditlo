//
//  ProfileHeaderCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/12/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class ProfileHeaderCell: BaseCollectionReusableView {

    let userProfileHeader = OtherUserProfileNavBar()

    override func setupViews() {
        super.setupViews()
        addSubview(userProfileHeader)
        userProfileHeader.fillSuperview()
    }
}
