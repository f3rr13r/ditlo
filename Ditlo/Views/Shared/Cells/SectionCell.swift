//
//  SectionCell.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/7/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

protocol SectionCellDelegate {
    func ditloItemCellTapped()
    func userSwipedContentUp()
    func userSwipedContentDown()
}

extension SectionCellDelegate {
    func userSwipedContentUp() {}
    func userSwipedContentDown() {}
}

class SectionCell: BaseCell {
    
    // injector variables
    var testColour: UIColor = ditloGrey {
        didSet {
            contentViewController.reloadData()
        }
    }
    
    var sectionTitle: String = "" {
        didSet {
            sectionTitleLabel.text = sectionTitle
        }
    }
    
    // views
    private let largeDitloItemCellId: String = "largeDitloItemCellId"
    private let defaultDitloItemCellId: String = "defaultDitloItemCellId"
    lazy var contentViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.register(LargeDitloItemCell.self, forCellWithReuseIdentifier: largeDitloItemCellId)
        cv.register(DefaultDitloItemCell.self, forCellWithReuseIdentifier: defaultDitloItemCellId)
        return cv
    }()
    
    let gradientView: GradientView = {
        let gv = GradientView()
        gv.colors = [ditloOffBlack.withAlphaComponent(0.4), UIColor.clear]
        return gv
    }()
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Section Header"
        label.font = defaultTitleFont
        label.textColor = ditloOffWhite
        return label
    }()
    var sectionTitleLabelTopConstraint: NSLayoutConstraint!
    
    
    // delegate
    var delegate: SectionCellDelegate?
    
    
    // variables
    var previousContentOffset: CGFloat = 0.0
    
    
    // class methods
    override func setupViews() {
        super.setupViews()
        anchorSubviews()
    }
    
    func anchorSubviews() {
        // collection view
        addSubview(contentViewController)
        contentViewController.fillSuperview()
        
        // sectionTitleLabel
        addSubview(gradientView)
        gradientView.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 180.0)
        gradientView.addSubview(sectionTitleLabel)
        sectionTitleLabel.anchor(withTopAnchor: nil, leadingAnchor: gradientView.leadingAnchor, bottomAnchor: nil, trailingAnchor: gradientView.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        sectionTitleLabelTopConstraint = NSLayoutConstraint(item: sectionTitleLabel, attribute: .top, relatedBy: .equal, toItem: gradientView, attribute: .top, multiplier: 1.0, constant: 20.0)
        gradientView.addConstraint(sectionTitleLabelTopConstraint)
    }
    
    func resetCollectionViewPosition() {
        let startIndexPath = IndexPath(item: 0, section: 0)
        contentViewController.scrollToItem(at: startIndexPath, at: .top, animated: false)
    }
}

// collection view data source methods
extension SectionCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // large cell
        if indexPath.item == 0 || indexPath.item % 7 == 0 {
            guard let largeDitloItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: largeDitloItemCellId, for: indexPath) as? LargeDitloItemCell else {
                return UICollectionViewCell()
            }
            largeDitloItemCell.backgroundColor = testColour
            return largeDitloItemCell
        }
        
        // default cell
        guard let defaultDitloItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultDitloItemCellId, for: indexPath) as? DefaultDitloItemCell else {
            return UICollectionViewCell()
        }
        defaultDitloItemCell.backgroundColor = testColour
        return defaultDitloItemCell
    }
}

// collection view delegate and flow layout methods
extension SectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat!
        let height: CGFloat!
        
        if indexPath.item == 0 || indexPath.item % 7 == 0 {
            width = screenWidth
            height = width * 1.44
        } else {
            width = (screenWidth - 2.0) / 2
            height = width * 1.44
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.ditloItemCellTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}


// scroll view delegate methods
extension SectionCell: UIScrollViewDelegate {    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // scroll swipe upwards
        if scrollView.contentOffset.y > previousContentOffset {
            if scrollView.contentOffset.y > 0 {
                delegate?.userSwipedContentUp()
            }
            if scrollView.contentOffset.y > 30.0 {
                if sectionTitleLabelTopConstraint.constant < 50.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.sectionTitleLabelTopConstraint.constant = 50.0
                        self.layoutIfNeeded()
                    })
                }
            }
            
            // scroll swipe downwards
        } else {
            delegate?.userSwipedContentDown()
            if sectionTitleLabelTopConstraint.constant > 20.0 {
                UIView.animate(withDuration: 0.25) {
                    self.sectionTitleLabelTopConstraint.constant = 20.0
                    self.layoutIfNeeded()
                }
            }
        }
        
        previousContentOffset = scrollView.contentOffset.y
    }
}
