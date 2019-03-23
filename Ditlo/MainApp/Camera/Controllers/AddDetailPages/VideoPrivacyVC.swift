//
//  VideoPrivacyVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/23/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class VideoPrivacyVC: UIViewController {

    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let videoPrivacyNavBar = VideoPrivacyNavBar()
    
    let privateOptionView = PrivacyOptionView(privacyOptionConfiguration: PrivacyOptionViewConfig(privacyOption: ._private, name: PrivacyOption._private.rawValue, description: "Only you will be able to see this ditlo video. You will not be able to tag any friends in this video, and you may only tag this video in private events created by you."))
    let friendsOnlyOptionView = PrivacyOptionView(privacyOptionConfiguration: PrivacyOptionViewConfig(privacyOption: ._friendsOnly, name: PrivacyOption._friendsOnly.rawValue, description: "Only you and your friends will be able to view this video. You can tag friends who feature in this ditlo video, and it will appear on their ditlos also.\n\nYou can also tag this video in any events that you are a member of, but for the purposes of that event, it will be visible to anybody that the event permits viewing access to."))
    let publicOptionView = PrivacyOptionView(privacyOptionConfiguration: PrivacyOptionViewConfig(privacyOption: ._public, name: PrivacyOption._public.rawValue, description: "This video will be visible to everybody in the ditlo community. You can tag friends who feature in this video, and also tag this video in any events that you are a member of."))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        anchorSubviews()
        setupChildDelegates()
    }
    
    func anchorSubviews() {
        // top padding view
        self.view.addSubview(topPaddingView)
        topPaddingView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: safeAreaTopPadding)
        
        // nav bar
        self.view.addSubview(videoPrivacyNavBar)
        videoPrivacyNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // options
        self.view.addSubview(privateOptionView)
        privateOptionView.anchor(withTopAnchor: videoPrivacyNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        self.view.addSubview(friendsOnlyOptionView)
        friendsOnlyOptionView.anchor(withTopAnchor: privateOptionView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        self.view.addSubview(publicOptionView)
        publicOptionView.anchor(withTopAnchor: friendsOnlyOptionView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
    }
    
    func setupChildDelegates() {
        videoPrivacyNavBar.delegate = self
        privateOptionView.delegate = self
        friendsOnlyOptionView.delegate = self
        publicOptionView.delegate = self
    }
}

// nav bar delegate methods
extension VideoPrivacyVC: VideoPrivacyNavBarDelegate {
    func backButtonPressed() {
        print("back button pressed")
        self.navigationController?.popViewController(animated: true)
    }
}

// option view delegate methods
extension VideoPrivacyVC: PrivacyOptionViewActionDelegate {
    func optionViewTapped(withPrivacyOptionType privacyOption: PrivacyOption) {
        switch privacyOption {
        /*-- if friends or public, we can tag friends
             so navigate to the tagFriendsVC --*/
        case ._friendsOnly,
             ._public:
            let tagFriendsVC = VideoTagFriendsVC()
            navigateTo(viewController: tagFriendsVC)
            break
            
        /*-- if private then we cannot tag friends
             check if we have any private groups. If we do,
             then navigate to tagEventsVC. If not then we will
             post the video --*/
        case ._private:
            break
        }
    }
    
    func navigateTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
