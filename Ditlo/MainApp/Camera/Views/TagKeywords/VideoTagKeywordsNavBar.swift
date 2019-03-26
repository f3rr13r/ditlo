//
//  VideoTagKeywordsNavBar.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/26/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol VideoTagKeywordsNavBarDelegate {
    func backButtonPressed()
    func addKeyword(withValue keywordValue: String)
    func skipButtonPressed()
    func nextButtonPressed()
}

class VideoTagKeywordsNavBar: BaseView {

    // views
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "ditlo-logo")
        return iv
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "DITLO"
        label.textColor = ditloOffBlack
        label.font = largeProfileInfoNameFont
        return label
    }()
    
    let topContentRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "back-arrow-icon")
        return iv
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = ditloGrey.cgColor
        button.layer.cornerRadius = 4.0
        button.backgroundColor = .clear
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(ditloGrey, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.backgroundColor = ditloRed
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = smallParagraphFont
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.isHidden = true /*-- hidden by default --*/
        return button
    }()

    let tagKeywordsTitleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.numberOfLines = 1
        label.text = "Tag Keywords"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        label.trailingBuffer = 8.0
        label.fadeLength = 6.0
        return label
    }()
    
    let keywordInputView: UITextField = {
        let input = UITextField()
        input.layer.borderColor = ditloLightGrey.cgColor
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.font = customInputFont
        input.textColor = ditloOffBlack
        input.clearButtonMode = .whileEditing
        input.adjustsFontSizeToFitWidth = true
        input.returnKeyType = .done
        input.keyboardAppearance = .dark
        input.attributedPlaceholder = NSAttributedString(
            string: "Enter your keyword here", attributes: [NSAttributedString.Key.foregroundColor: ditloGrey])
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 12.0, height: 36))
        input.leftView = paddingView
        input.leftViewMode = .always
        input.addTarget(self, action: #selector(keywordInputValueDidChange(_:)), for: .editingChanged)
        return input
    }()
    
    let addKeywordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addKeywordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let addKeywordButtonIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "add-icon").withRenderingMode(.alwaysTemplate)
        iv.tintColor = ditloOffBlack
        return iv
    }()
    
    let bottomContentRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var bottomContentRowViewTopAnchorConstraint: NSLayoutConstraint!
    
    let suggestedKeywordsLabel: UILabel = {
        let label = UILabel()
        label.text = "Suggested Keywords"
        label.font = smallTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let keywordSuggestionsCellId = "keywordSuggestionsCellId"
    lazy var keywordSuggestionsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(KeywordSuggestionCell.self, forCellWithReuseIdentifier: keywordSuggestionsCellId)
        return cv
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = ditloVeryLightGrey
        return view
    }()
    
    // delegate
    var delegate: VideoTagKeywordsNavBarDelegate?
    
    // variables
    var testKeywordSuggestions: [String] = ["Test Footage", "Radyr", "Spring 2019", "Apple", "Penny and Fleurie", "WFH", "Brexit", "Driving", "Euro Qualifiers"]
    var matchingKeywordSuggestions: [String] = []
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        handleChildDelegates()
        anchorSubviews()
    }
    
    func handleChildDelegates() {
        keywordInputView.delegate = self
    }
    
    func anchorSubviews() {
        /*-- top content row --*/
        addSubview(topContentRowView)
        topContentRowView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        /*-- back button --*/
        topContentRowView.addSubview(backButton)
        backButton.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: topContentRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 44.0, heightAnchor: 44.0)
        backButton.addSubview(backButtonImageView)
        backButtonImageView.anchor(withTopAnchor: backButton.topAnchor, leadingAnchor: backButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 26.0, heightAnchor: 26.0, padding: .init(top: 0.0, left: 14.0, bottom: 0.0, right: 0.0))
        
        /*-- logo image view --*/
        topContentRowView.addSubview(logoImageView)
        logoImageView.anchor(withTopAnchor: topContentRowView.topAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: 10.0, heightAnchor: 10.0)
        
        /*-- skip button --*/
        topContentRowView.addSubview(skipButton)
        skipButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: backButton.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        /*-- next button (hidden by default) --*/
        topContentRowView.addSubview(nextButton)
        nextButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: backButton.centerYAnchor, widthAnchor: 60.0, heightAnchor: nil, padding: .init(top: 0.0, left: 0.0, bottom: 0.0, right: -horizontalPadding))
        
        /*-- logo label --*/
        topContentRowView.addSubview(logoLabel)
        logoLabel.anchor(withTopAnchor: nil, leadingAnchor: logoImageView.trailingAnchor, bottomAnchor: nil, trailingAnchor: skipButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: logoImageView.centerYAnchor, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 2.0, bottom: 0.0, right: -12.0))
        
        /*-- title label --*/
        topContentRowView.addSubview(tagKeywordsTitleLabel)
        tagKeywordsTitleLabel.anchor(withTopAnchor: logoImageView.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: nil, trailingAnchor: skipButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 6.0, left: 0.0, bottom: 0.0, right: -12.0))
        
        /*-- search bar --*/
        topContentRowView.addSubview(addKeywordButton)
        addKeywordButton.anchor(withTopAnchor: tagKeywordsTitleLabel.bottomAnchor, leadingAnchor: nil, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: topContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 36.0, padding: .init(top: 10.0, left: 0.0, bottom: -12.0, right: 0.0))
        addKeywordButton.addSubview(addKeywordButtonIcon)
        addKeywordButtonIcon.anchor(withTopAnchor: nil, leadingAnchor: addKeywordButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: addKeywordButton.trailingAnchor, centreXAnchor: nil, centreYAnchor: addKeywordButton.centerYAnchor, widthAnchor: 16.0, heightAnchor: 16.0, padding: .init(top: 0.0, left: 12.0, bottom: 0.0, right: -horizontalPadding))
        
        topContentRowView.addSubview(keywordInputView)
        keywordInputView.anchor(withTopAnchor: tagKeywordsTitleLabel.bottomAnchor, leadingAnchor: backButton.trailingAnchor, bottomAnchor: topContentRowView.bottomAnchor, trailingAnchor: addKeywordButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 36.0, padding: .init(top: 10.0, left: 0.0, bottom: -12.0, right: 0.0))
        
        /*-- bottom content row --*/
        insertSubview(bottomContentRowView, belowSubview: topContentRowView)
        bottomContentRowView.anchor(withTopAnchor: nil, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        /*-- bottom content row view constraint (for animation) --*/
        bottomContentRowViewTopAnchorConstraint = NSLayoutConstraint(item: bottomContentRowView, attribute: .top, relatedBy: .equal, toItem: topContentRowView, attribute: .bottom, multiplier: 1.0, constant: -68.0)
        addConstraint(bottomContentRowViewTopAnchorConstraint)
        
        /*-- suggested keywords label --*/
        bottomContentRowView.addSubview(suggestedKeywordsLabel)
        suggestedKeywordsLabel.anchor(withTopAnchor: bottomContentRowView.topAnchor, leadingAnchor: bottomContentRowView.leadingAnchor, bottomAnchor: nil, trailingAnchor: bottomContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 46.0, bottom: 0.0, right: -horizontalPadding))
        
        /*-- suggested keywords collection view --*/
        bottomContentRowView.addSubview(keywordSuggestionsCollectionView)
        keywordSuggestionsCollectionView.anchor(withTopAnchor: suggestedKeywordsLabel.bottomAnchor, leadingAnchor: bottomContentRowView.leadingAnchor, bottomAnchor: bottomContentRowView.bottomAnchor, trailingAnchor: bottomContentRowView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 32.0, padding: .init(top: 12.0, left: 0.0, bottom: -12.0, right: 0.0))
        
        /*-- bottom border --*/
        addSubview(bottomBorderView)
        bottomBorderView.anchor(withTopAnchor: bottomContentRowView.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 1.0)
    }
    
    @objc func backButtonPressed() {
        delegate?.backButtonPressed()
    }
    
    @objc func keywordInputValueDidChange(_ textField: UITextField) {
        if let searchValue = textField.text,
            !searchValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchMatchingKeyword(withValue: searchValue)
        } else {
            clearMatchingKeywords()
        }
    }
    
    func searchMatchingKeyword(withValue keywordSearchValue: String) {
        matchingKeywordSuggestions = []
        testKeywordSuggestions.forEach { (suggestion) in
            if suggestion.lowercased().contains(find: keywordSearchValue.lowercased()) {
                matchingKeywordSuggestions.append(suggestion)
            }
        }
        keywordSuggestionsCollectionView.reloadData()
        if matchingKeywordSuggestions.count > 0 {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                self.bottomContentRowViewTopAnchorConstraint.constant = 0.0
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            clearMatchingKeywords()
        }
    }
    
    func clearMatchingKeywords() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.bottomContentRowViewTopAnchorConstraint.constant = -(self.bottomContentRowView.frame.height)
            self.layoutIfNeeded()
        }) { (animationComplete) in
            self.matchingKeywordSuggestions = []
            self.keywordSuggestionsCollectionView.reloadData()
        }
    }
    
    @objc func skipButtonPressed() {
        delegate?.skipButtonPressed()
    }
    
    @objc func nextButtonPressed() {
        delegate?.nextButtonPressed()
    }
    
    @objc func addKeywordButtonPressed() {
        if let keywordValue = keywordInputView.text,
            !keywordValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            delegate?.addKeyword(withValue: keywordValue)
        }
    }
}

// text field delegate
extension VideoTagKeywordsNavBar: UITextFieldDelegate {}

// collection view delegate and data source methods
extension VideoTagKeywordsNavBar: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchingKeywordSuggestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keywordSuggestionsCellId, for: indexPath) as? KeywordSuggestionCell else {
            return UICollectionViewCell()
        }
        cell.keyword = matchingKeywordSuggestions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.addKeyword(withValue: matchingKeywordSuggestions[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = matchingKeywordSuggestions[indexPath.item].widthOfString(usingFont: defaultParagraphFont) + 24.0
        return CGSize(width: width, height: 32.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 46.0, bottom: 0.0, right: horizontalPadding)
    }
}

class KeywordSuggestionCell: BaseCell {
    
    // injector variables
    var keyword: String? {
        didSet {
            if let keyword = self.keyword {
                keywordSuggestionLabel.text = keyword
            }
        }
    }
    
    // views
    let keywordSuggestionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = defaultParagraphFont
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        layer.borderWidth = 1.0
        layer.borderColor = ditloGrey.cgColor
        layer.cornerRadius = 4.0
        addSubview(keywordSuggestionLabel)
        keywordSuggestionLabel.fillSuperview()
    }
    
    override func prepareForReuse() {
        keyword = nil
    }
}
