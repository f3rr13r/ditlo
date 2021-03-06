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
    
    private let cellId: String = "cellId"
    lazy var userListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
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
        
        // user list collection view
        self.view.addSubview(userListCollectionView)
        userListCollectionView.anchor(withTopAnchor: videoTagFriendsNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
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

// collection view delegate and datasource methods
extension VideoTagFriendsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 93
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (screenWidth - 56) / 3
        let height: CGFloat = width * 1.24
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12.0, left: 20.0, bottom: 24.0, right: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
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
        navigateToEventsVC()
    }
    
    func nextButtonPressed() {
        navigateToEventsVC()
    }
    
    func navigateToEventsVC() {
        let tagEventsVC = VideoTagEventsVC()
        self.navigationController?.pushViewController(tagEventsVC, animated: true)
    }
}
