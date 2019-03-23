//
//  VideoTagFriendsVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/23/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class VideoTagFriendsVC: UIViewController {

    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let videoTagFriendsNavBar = VideoTagFriendsNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        anchorSubviews()
        setupChildDelegates()
        setupKeyboardDismissTapGesture()
    }
    
    func anchorSubviews() {
        // top padding view
        self.view.addSubview(topPaddingView)
        topPaddingView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: safeAreaTopPadding)
        
        // nav bar
        self.view.addSubview(videoTagFriendsNavBar)
        videoTagFriendsNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
    
    func setupChildDelegates() {
        videoTagFriendsNavBar.delegate = self
    }
    
    func setupKeyboardDismissTapGesture() {
        let keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardDismissTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    @objc func dismissKeyboard() {
        videoTagFriendsNavBar.dismissKeyboard()
    }
}

// nav bar delegate methods
extension VideoTagFriendsVC: VideoTagFriendsNavBarDelegate {
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchValueChanged(withValue searchValue: String) {
        // do stuff here
    }
    
    func searchValueCleared() {
        // do stuff here
    }
    
    func skipButtonPressed() {
        // do stuff here
    }
    
    func nextButtonPressed() {
        // do stuff here
    }
}
