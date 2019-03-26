//
//  VideoTagEventsVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class VideoTagEventsVC: UIViewController {

    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let videoTagEventsNavBar = VideoTagEventsNavBar()
    
    private let cellId: String = "cellId"
    lazy var eventsListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(EventCell.self, forCellWithReuseIdentifier: cellId)
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
        self.view.addSubview(videoTagEventsNavBar)
        videoTagEventsNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // events list collection view
        self.view.addSubview(eventsListCollectionView)
        eventsListCollectionView.anchor(withTopAnchor: videoTagEventsNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
    
    func setupChildDelegates() {
        videoTagEventsNavBar.delegate = self
    }
    
    func setupKeyboardDismissTapGesture() {
        let keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardDismissTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    @objc func dismissKeyboard() {
        videoTagEventsNavBar.dismissKeyboard()
    }
}

// collection view delegate and datasource methods
extension VideoTagEventsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        return eventCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = screenWidth - (horizontalPadding * 2)
        return CGSize(width: cellWidth, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: horizontalPadding, bottom: 20.0, right: horizontalPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}


// nav bar delegate methods
extension VideoTagEventsVC: VideoTagEventsNavBarDelegate {
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
        navigateToCategoriesVC()
    }
    
    func nextButtonPressed() {
        navigateToCategoriesVC()
    }
    
    func navigateToCategoriesVC() {
        let tagCategoriesVC = VideoTagCategoriesVC()
        self.navigationController?.pushViewController(tagCategoriesVC, animated: true)
    }
}
