//
//  ViewController.swift
//  LGLinearFlowViewSwift
//
//  Created by Mohamed BOUMANSOUR on 6/7/17.
//  Copyright © 2017 Mohamed. All rights reserved.
//

import UIKit




public class CollectionViewCell: UICollectionViewCell {
    
    public var pageLabel: UILabel!
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup()
    {
        self.pageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(self.pageLabel);
    }
}


private let cellId = "CollectionViewCell"

class CarouselView: UIView {
    
    // MARK: Vars
    
    private var collectionViewLayout: LGHorizontalLinearFlowLayout!
    private var dataSource: Array<String>!
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    
    private var animationsCount = 0
    
    private var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.configureDataSource()
        self.configureCollectionView()
        self.configurePageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configureDataSource() {
        self.dataSource = Array()
        for index in 1...10 {
            self.dataSource.append("Page \(index)")
        }
    }
    
    private func configureCollectionView() {
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 250) , collectionViewLayout: UICollectionViewLayout())
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: 180, height: 180), minimumLineSpacing: 0)
        self.addSubview(self.collectionView)
        
    }
    
    private func configurePageControl() {
        
        let y = self.collectionView.frame.origin.y + self.collectionView.frame.size.height //self.frame.size.height-20
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: y, width: self.frame.size.width, height: 20) )
        self.pageControl.backgroundColor = UIColor.gray
        self.addSubview(self.pageControl)
        self.pageControl.numberOfPages = self.dataSource.count
        self.pageControl.addTarget(self, action:#selector(pageControlValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    // MARK: Actions
    
    @objc private func pageControlValueChanged(sender: AnyObject) {
        self.scrollToPage(page: self.pageControl.currentPage, animated: true)
    }

    private func scrollToPage(page: Int, animated: Bool) {
        self.collectionView.isUserInteractionEnabled = false
        self.animationsCount += 1
        let pageOffset = CGFloat(page) * self.pageWidth - self.collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: true)
        self.pageControl.currentPage = page
    }
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        collectionViewCell.pageLabel.text = self.dataSource[indexPath.row]
        collectionViewCell.backgroundColor = UIColor.green
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
        
        let selectedPage = indexPath.row
        
        if selectedPage == self.pageControl.currentPage {
            NSLog("Did select center item")
        }
        else {
            self.scrollToPage(page: selectedPage, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.animationsCount -= 1;
        if self.animationsCount == 0 {
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
}


