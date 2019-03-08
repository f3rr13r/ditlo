//
//  TaggedEventsSectionView.swift
//  Ditlo
//
//  Created by Harry Ferrier on 3/8/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class TaggedEventsSectionView: BaseView {

    // views
    let taggedEventsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tagged Events"
        label.font = defaultTitleFont
        label.textColor = ditloOffBlack
        return label
    }()
    
    private let eventCellId: String = "eventCellId"
    let taggedEventCollectionViewFlowlayout = UICollectionViewFlowLayout()
    lazy var taggedEventsCollectionView: UICollectionView = {
        taggedEventCollectionViewFlowlayout.scrollDirection = .horizontal
        taggedEventCollectionViewFlowlayout.itemSize.width = min((screenWidth - 20.0) - 20, 400)
        taggedEventCollectionViewFlowlayout.itemSize.height = 60.0
        taggedEventCollectionViewFlowlayout.minimumInteritemSpacing = 0.0
        taggedEventCollectionViewFlowlayout.sectionInset = UIEdgeInsets(top: 0.0, left: horizontalPadding, bottom: 0.0, right: horizontalPadding)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: taggedEventCollectionViewFlowlayout)
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(EventCell.self, forCellWithReuseIdentifier: eventCellId)
        return cv
    }()
    
    // delegate
    var delegate: SectionViewActionDelegate?
    
    // Velocity is measured in points per millisecond.
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }

    override func setupViews() {
        super.setupViews()
        invalidateIntrinsicContentSize()
        addSubview(taggedEventsLabel)
        taggedEventsLabel.anchor(withTopAnchor: topAnchor, leadingAnchor: leadingAnchor, bottomAnchor: nil, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        addSubview(taggedEventsCollectionView)
        taggedEventsCollectionView.anchor(withTopAnchor: taggedEventsLabel.bottomAnchor, leadingAnchor: leadingAnchor, bottomAnchor: bottomAnchor, trailingAnchor: trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 196.0, padding: .init(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
}


// collection view data source
extension TaggedEventsSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        return eventCell
    }
}


// collection view delegate
extension TaggedEventsSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.taggedEventCellSelected(withId: "some event id")
    }
}


// scroll view delegate
extension TaggedEventsSectionView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == taggedEventsCollectionView {
            let layout = taggedEventCollectionViewFlowlayout
            let bounds = scrollView.bounds
            let xTarget = targetContentOffset.pointee.x
            
            // This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge of the last column of cells is at the right edge of the collection view's frame.
            let xMax = (scrollView.contentSize.width) - (scrollView.bounds.width)
            
            if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
                let xCenter = scrollView.bounds.midX
                let poses = layout.layoutAttributesForElements(in: bounds) ?? []
                // Find the column whose center is closest to the collection view's visible rect's center, then minus one section contentInset
                let x = (poses.min(by: { abs($0.center.x - 20.0 - xCenter) < abs($1.center.x - xCenter) })?.frame.origin.x ?? 0) - 20.0
                targetContentOffset.pointee.x = x
            } else if velocity.x > 0 {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the leftmost column beyond the current position, minus one section contentInset.
                let xCurrent = scrollView.contentOffset.x
                let x = (poses.filter({ $0.frame.origin.x > xCurrent}).min(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? xMax) - 20.0
                targetContentOffset.pointee.x = min(x, xMax)
            } else {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the rightmost column minus one section contentInset.
                let x = ((poses.max(by: { $0.center.x < $1.center.x })?.frame.origin.x) ?? 0) - 20.0
                targetContentOffset.pointee.x = max(x, 0)
            }
        }
    }
}
