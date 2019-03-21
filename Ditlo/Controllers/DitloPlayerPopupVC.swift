//
//  DitloPlayerPopupVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/4/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController
import DGCollectionViewLeftAlignFlowLayout

protocol DitloPlayerPopupActionDelegate {
    func prepareToNavigate(toViewController viewController: UIViewController)
}

class DitloPlayerPopupVC: UIViewController {

    // views
    lazy var contentScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        return sv
    }()
    
    let testImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        let testImage = #imageLiteral(resourceName: "example-screenshot-1")
        iv.image = testImage
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoContentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloOffWhite
        return view
    }()
    
    let taggedFriendsSectionView = TaggedFriendsSectionView()
    let taggedEventsSectionView = TaggedEventsSectionView()
    let taggedCategoriesSectionView = TaggedCategoriesSectionView()
    let taggedKeywordsSectionView = TaggedKeywordsSectionView()
    let taggedLocationSectionView = TaggedLocationSectionView()
    
    // delegate
    var delegate: DitloPlayerPopupActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ditloOffWhite
        handleChildDelegates()
        anchorSubviews()
    }
    
    func handleChildDelegates() {
        taggedFriendsSectionView.delegate = self
        taggedEventsSectionView.delegate = self
        taggedCategoriesSectionView.delegate = self
        taggedKeywordsSectionView.delegate = self
        taggedLocationSectionView.delegate = self
    }
    
    func anchorSubviews() {
        // scroll view
        self.view.addSubview(contentScrollView)
        contentScrollView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // top
        contentScrollView.addSubview(testImageView)
        testImageView.anchor(withTopAnchor: self.contentScrollView.topAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: nil, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: (self.view.frame.height - safeAreaTopPadding))
        
        // bottom
        contentScrollView.addSubview(infoContentContainerView)
        infoContentContainerView.anchor(withTopAnchor: testImageView.bottomAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: contentScrollView.bottomAnchor, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: nil)
        
        // tagged friends
        infoContentContainerView.addSubview(taggedFriendsSectionView)
        taggedFriendsSectionView.anchor(withTopAnchor: infoContentContainerView.topAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 42.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // tagged events
        infoContentContainerView.addSubview(taggedEventsSectionView)
        taggedEventsSectionView.anchor(withTopAnchor: taggedFriendsSectionView.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 42.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // tagged categories
        infoContentContainerView.addSubview(taggedCategoriesSectionView)
        taggedCategoriesSectionView.anchor(withTopAnchor: taggedEventsSectionView.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 42.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // tagged keywords
        infoContentContainerView.addSubview(taggedKeywordsSectionView)
        taggedKeywordsSectionView.anchor(withTopAnchor: taggedCategoriesSectionView.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: nil, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 42.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // tagged location
        infoContentContainerView.addSubview(taggedLocationSectionView)
        taggedLocationSectionView.anchor(withTopAnchor: taggedKeywordsSectionView.bottomAnchor, leadingAnchor: infoContentContainerView.leadingAnchor, bottomAnchor: infoContentContainerView.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: infoContentContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 42.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        self.updateLayout(with: self.view.frame.size)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    @available(iOS 11.0, *)
    override public func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        self.updateLayout(with: self.view.frame.size)
    }
    
    func updateLayout(with size: CGSize) {
        self.contentScrollView.frame = CGRect.init(origin: CGPoint.zero, size: size)
    }
}



// scroll view delegate methods
extension DitloPlayerPopupVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y < -(self.view.frame.height * 0.18) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// section views delegate
extension DitloPlayerPopupVC: SectionViewActionDelegate {
    func taggedFriendCellSelected(withId taggedFriendId: String) {
        let otherUserProfileVC = OtherUserProfileVC()
        navigateTo(viewController: otherUserProfileVC, withLoadingMessage: "Loading Profile...")
    }
    
    func taggedEventCellSelected(withId taggedEventId: String) {
        let eventProfileVC = EventProfileVC()
        navigateTo(viewController: eventProfileVC, withLoadingMessage: "Loading Event...")
    }
    
    func taggedCategoryCellSelected(withId taggedCategoryId: String) {
        let taggedCategoryVC = TaggedCategoryVC()
        navigateTo(viewController: taggedCategoryVC, withLoadingMessage: "Loading Tagged Category...")
    }
    
    func taggedKeywordCellSelected(withValue keywordValue: String) {
        let taggedKeywordVC = TaggedKeywordVC()
        navigateTo(viewController: taggedKeywordVC, withLoadingMessage: "Loading Tagged Keyword...")
    }
    
    func taggedLocationSelected(withLocationValue locationValue: Any) {
        let taggedLocationVC = TaggedLocationVC()
        navigateTo(viewController: taggedLocationVC, withLoadingMessage: "Loading Tagged Location...")
    }
    
    func navigateTo(viewController: UIViewController, withLoadingMessage loadingMessage: String) {
        SharedModalsService.instance.showCustomOverlayModal(withMessage: loadingMessage)
        self.dismiss(animated: true) {
            self.delegate?.prepareToNavigate(toViewController: viewController)
        }
    }
}
