//
//  DitloPlayerPopupVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/4/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import SPStorkController

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ditloOffWhite

        self.view.addSubview(contentScrollView)
        contentScrollView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        contentScrollView.addSubview(testImageView)
        testImageView.anchor(withTopAnchor: self.contentScrollView.topAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: nil, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: (self.view.frame.height - safeAreaTopPadding))

        contentScrollView.addSubview(infoContentContainerView)
        infoContentContainerView.anchor(withTopAnchor: testImageView.bottomAnchor, leadingAnchor: contentScrollView.leadingAnchor, bottomAnchor: contentScrollView.bottomAnchor, trailingAnchor: contentScrollView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: screenWidth, heightAnchor: self.view.frame.height)
        
        self.updateLayout(with: self.view.frame.size)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
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

extension DitloPlayerPopupVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y < -(self.view.frame.height * 0.20) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
