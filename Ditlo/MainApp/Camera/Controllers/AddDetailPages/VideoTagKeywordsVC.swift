//
//  VideoTagKeywordsNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

class VideoTagKeywordsVC: UIViewController {

    let topPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let videoTagKeywordsNavBar = VideoTagKeywordsNavBar()
    
    let mainContentView = UIView()
    
    let maxLimitLabel: UILabel = {
        let label = UILabel()
        label.font = smallParagraphFont
        label.textAlignment = .right
        return label
    }()
    
    private let selectedKeywordCellId = "selectedKeywordCellId"
    lazy var selectedKeywordsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.canCancelContentTouches = true
        cv.showsVerticalScrollIndicator = false
        cv.register(KeywordSelectorCell.self, forCellWithReuseIdentifier: selectedKeywordCellId)
        return cv
    }()
    
    let noSelectedKeywordsView = NoDataView()
    
    let dismissKeyboardView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    /*-- variables --*/
    var remainingNumber: Int = 5 {
        didSet {
            let maxLimitText = "\(remainingNumber) remaining"
            maxLimitLabel.text = maxLimitText
            maxLimitLabel.textColor = remainingNumber > 0 ? ditloLightGreen : ditloRed
        }
    }
    
    var selectedKeywords: [String] = [] {
        didSet {
            selectedKeywordsCollectionView.reloadData()
            if selectedKeywords.count > 0 {
                noSelectedKeywordsView.hide()
            } else {
                noSelectedKeywordsView.show(withMessage: "No Keywords Added")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        edgesForExtendedLayout = []
        handleChildDelegates()
        anchorSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func animateWithKeyboard(_ notification: NSNotification) {
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        dismissKeyboardView.alpha = moveUp ? 1.0 : 0.0
        
    }
    
    func handleChildDelegates() {
        videoTagKeywordsNavBar.delegate = self
    }
    
    func anchorSubviews() {
        // top padding view
        self.view.addSubview(topPaddingView)
        topPaddingView.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: safeAreaTopPadding)
        
        // nav bar
        self.view.addSubview(videoTagKeywordsNavBar)
        videoTagKeywordsNavBar.anchor(withTopAnchor: topPaddingView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // main content
        self.view.addSubview(mainContentView)
        mainContentView.anchor(withTopAnchor: videoTagKeywordsNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // max limit label - 5 to start
        remainingNumber = 5
        mainContentView.addSubview(maxLimitLabel)
        maxLimitLabel.anchor(withTopAnchor: mainContentView.topAnchor, leadingAnchor: mainContentView.leadingAnchor, bottomAnchor: nil, trailingAnchor: mainContentView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        // results collection view - empty to start
        selectedKeywords = []
        mainContentView.addSubview(selectedKeywordsCollectionView)
        selectedKeywordsCollectionView.anchor(withTopAnchor: maxLimitLabel.bottomAnchor, leadingAnchor: mainContentView.leadingAnchor, bottomAnchor: mainContentView.bottomAnchor, trailingAnchor: mainContentView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        // no keywords view
        mainContentView.addSubview(noSelectedKeywordsView)
        noSelectedKeywordsView.fillSuperview()
        
        // dismiss keyboard view
        self.view.addSubview(dismissKeyboardView)
        dismissKeyboardView.anchor(withTopAnchor: videoTagKeywordsNavBar.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
    }
    
    @objc func dismissKeyboard() {
        videoTagKeywordsNavBar.dismissKeyboard()
    }
}

// nav bar delegate methods
extension VideoTagKeywordsVC: VideoTagKeywordsNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addKeyword(withValue keywordValue: String) {
        if selectedKeywords.count < 5 && !selectedKeywords.contains(keywordValue) {
            selectedKeywords.append(keywordValue)
            remainingNumber = 5 - selectedKeywords.count
        }
    }
    
    func skipButtonPressed() {
        // do something
    }
    
    func nextButtonPressed() {
        // do something
    }
}


// collection view delegate and datasource methods
extension VideoTagKeywordsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedKeywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedKeywordCellId, for: indexPath) as? KeywordSelectorCell else {
            return UICollectionViewCell()
        }
        cell.keyword = selectedKeywords[indexPath.item]
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteKeywordButtonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = screenWidth - (horizontalPadding * 2)
        return CGSize(width: width, height: 32.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12.0, left: horizontalPadding, bottom: 20.0, right: horizontalPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    @objc func deleteKeywordButtonPressed(_ button: UIButton) {
        selectedKeywords.remove(at: button.tag)
        remainingNumber = 5 - selectedKeywords.count
    }
}
