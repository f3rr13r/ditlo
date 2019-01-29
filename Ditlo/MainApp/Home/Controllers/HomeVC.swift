//
//  HomeVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // views
    let homeNavBar = MainDitloNavBar()
    
    let homeLoadingContentView = UIView()
    
    let loadingContentView: LoadingContentView = {
        let loadingView = LoadingContentView()
        loadingView.loadingContentMessage = "LOADING YOUR PROFILE"
        return loadingView
    }()
    
    // variables
    var currentUserData: ProfileUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildDelegates()
        anchorChildViews()
    }
    
    func appHasCurrentUserData() {
        // get the current user data
        currentUserData = UserService.instance.currentUser
        
        // set the profile picture
        homeNavBar.profilePictureImageView.profilePicture = currentUserData?.profileImage
        
        // update the loading message
        loadingContentView.loadingContentMessage = "RETRIEVING DITLO CONTENT"
        
        // attempt to get home ditlo data
        getHomeDitloContent()
    }
    
    func getHomeDitloContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadingContentView.isHidden = true
            self.loadingContentView.loadingContentMessage = ""
            self.homeNavBar.areButtonsEnabled = true
        }
    }
    
    func setupChildDelegates() {
        homeNavBar.delegate = self
    }

    func anchorChildViews() {
        // top nav
        self.view.addSubview(homeNavBar)
        homeNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: nil)
        
        
        // loading content view
        self.view.addSubview(homeLoadingContentView)
        homeLoadingContentView.anchor(withTopAnchor: homeNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        homeLoadingContentView.addSubview(loadingContentView)
        loadingContentView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: homeLoadingContentView.centerXAnchor, centreYAnchor: homeLoadingContentView.centerYAnchor)
    }
}

// navbar delegate methods
extension HomeVC: MainDitloNavBarDelegate {
    func goHomeButtonPressed() {
        // do something here
    }
    
    func openCalendarButtonPressed() {
        SharedModalsService.instance.showCalendar()
    }
    
    func profileIconButtonPressed() {
        // go something here
    }
}
