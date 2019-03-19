//
//  EventsVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/19/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController

class EventsVC: UIViewController {

    // views
    let eventsNavBar = EventsNavBar()
    
    private let cellId: String = "cellId"
    lazy var contentSectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.bounces = false
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(SectionCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupChildDelegates()
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomNavigationBarContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyCustomNavigationBarContent()
    }
    
    func setupCustomNavigationBarContent() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationItem.hidesBackButton = true
            navigationController.hidesBarsOnSwipe = true
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.backgroundColor = .white
            navigationController.navigationBar.addSubview(eventsNavBar)
            eventsNavBar.anchor(withTopAnchor: navigationController.navigationBar.topAnchor, leadingAnchor: navigationController.navigationBar.leadingAnchor, bottomAnchor: nil, trailingAnchor: navigationController.navigationBar.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
            navigationController.navigationBar.layoutIfNeeded()
        }
    }
    
    func destroyCustomNavigationBarContent() {
        eventsNavBar.removeFromSuperview()
    }
    
    func setupChildDelegates() {
        eventsNavBar.delegate = self
    }
    
    func anchorSubviews() {
        self.view.addSubview(contentSectionsCollectionView)
        contentSectionsCollectionView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: self.view.centerXAnchor, centreYAnchor: self.view.centerYAnchor)
    }
}

// nav bar delegate methods
extension EventsVC: EventsNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createEventButtonPressed() {
        //
    }
    
    func notificationsButtonPressed() {
        //
    }
}

// collection view delegate and datasource methods
extension EventsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionCell else { return UICollectionViewCell() }
        sectionCell.testColour = ditloRed
        // figure out a better way to do this
        sectionCell.sectionTitle = ""
        sectionCell.delegate = self
        return sectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// section cell delegate methods
extension EventsVC: SectionCellDelegate {
    func ditloItemCellTapped() {
        let controller = DitloPlayerPopupVC()
        controller.delegate = self
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true, completion: nil)
    }
}

// ditlo player delegate methods
extension EventsVC: DitloPlayerPopupActionDelegate {
    func prepareToNavigate(toViewController viewController: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

