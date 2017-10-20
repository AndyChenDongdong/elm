//
//  LCCircleLoopView.swift
//  LCCircleLoopView
//
//  Created by z on 16/5/31.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

let LCCircleLoopViewTimeInterval = 2.0

@objc protocol LCCircleLoopViewDelegate: class {
    /**
     LCCircleLoopView tap action delegate
     - parameter currentIndex: the index of current image
     */
    @objc optional
    func clickedImageAction(_ currentIndex: NSInteger)
}

class LCCircleLoopView: UIView, UIScrollViewDelegate {
    
    weak var delegate: LCCircleLoopViewDelegate?
    
    fileprivate var imgNames: [String]!
    fileprivate var containerScrollView: UIScrollView!
    fileprivate  var containerImgViews: [UIImageView]!
    
    fileprivate var currentImgView:     UIImageView!
    fileprivate var nextImgView:        UIImageView!
    fileprivate var previousImgView:    UIImageView!
    
    // index
    fileprivate var currentIndex: NSInteger = 0
    fileprivate var nextIndex: NSInteger = 1
    //need update in setImgNames:
    fileprivate var previousIndex: NSInteger = 0
    
    fileprivate var pageIndicator:      UIPageControl!
    fileprivate var timer: Timer!
    
    //MARK: -
    //MARK: public func
    func startTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: LCCircleLoopViewTimeInterval, target: self, selector: #selector(LCCircleLoopView.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func setImgNames(imgNamesArray: [String]) {
        imgNames = imgNamesArray
        //required  three photos at least
        if imgNames.count < 3 {
            print("error: need three photos at least！")
            return
        }
        //updateUI
        updateUI()
        //update previousIndex to new value
        previousIndex = imgNames.count - 1
        //set pageControl
        pageIndicator.numberOfPages = imgNames.count
        //set timer
        startTimer()
        //update scrollView UI
        updateScrollView()
    }
    
    func updateScrollView()  {
        currentImgView.image = UIImage(named: imgNames[currentIndex])
        nextImgView.image = UIImage(named: imgNames[nextIndex])
        previousImgView.image = UIImage(named: imgNames[previousIndex])
        containerScrollView.setContentOffset(CGPoint(x: bounds.size.width, y: 0), animated: false)
    }
    
    func timerAction()  {
        containerScrollView.setContentOffset(CGPoint(x: bounds.size.width * 2, y: 0), animated: true)
    }
    
    //MARK: -
    //MARK: life cycle
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func  setupUI() {
        //use bounds not frame
        containerScrollView = UIScrollView()

        containerScrollView.isPagingEnabled = true
        containerScrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.delegate = self
        addSubview(containerScrollView)
        
        
        currentImgView = UIImageView()
        currentImgView.isUserInteractionEnabled = true
        currentImgView.contentMode = UIViewContentMode.scaleAspectFill
        currentImgView.clipsToBounds = true
        containerScrollView.addSubview(currentImgView)
        
        nextImgView = UIImageView()
        
        nextImgView.isUserInteractionEnabled = true
        nextImgView.contentMode = UIViewContentMode.scaleAspectFill
        nextImgView.clipsToBounds = true
        containerScrollView.addSubview(nextImgView)
        
        previousImgView = UIImageView()
        previousImgView.isUserInteractionEnabled = true
        previousImgView.contentMode = UIViewContentMode.scaleAspectFill
        previousImgView.clipsToBounds = true
        containerScrollView.addSubview(previousImgView)
        
        //pageIndicator
        pageIndicator = UIPageControl()
       
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = 0
        pageIndicator.backgroundColor = UIColor.clear
        addSubview(pageIndicator)
        
        //add tap action
        let tap = UITapGestureRecognizer(target: self, action: #selector(LCCircleLoopView.tapClicked(_:)))
        containerScrollView.addGestureRecognizer(tap)
        
        //updateUI
        updateUI()
    }
    
    //awake from XIB
    func updateUI() {
        containerScrollView.frame = bounds
        containerScrollView.contentSize = CGSize(width: bounds.size.width * 3, height: bounds.size.height)
        containerScrollView.setContentOffset(CGPoint(x: bounds.size.width, y: 0), animated: false)
        
        currentImgView.frame = CGRect(x: bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
        nextImgView.frame = CGRect(x: bounds.size.width * 2, y: 0, width: bounds.size.width, height: bounds.size.height)
        previousImgView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
        pageIndicator.frame = CGRect(x: 0,y: bounds.size.height - 20, width: bounds.size.width, height: 20)
        pageIndicator.center = CGPoint(x: bounds.size.width / 2.0, y: pageIndicator.center.y)
    }
    
    func tapClicked(_ tapGR: UITapGestureRecognizer) {
        self.delegate?.clickedImageAction!(currentIndex)
    }
    
    //MARK: - 
    //MARK: scroll delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        if offset == 0 {
            previousIndex = getImgIndex(index: previousIndex, left: true)
            currentIndex = getImgIndex(index: currentIndex, left: true)
            nextIndex = getImgIndex(index: nextIndex, left: true)
        }else if offset == self.frame.size.width * 2 {
            previousIndex = getImgIndex(index: previousIndex, left: false)
            currentIndex = getImgIndex(index: currentIndex, left: false)
            nextIndex = getImgIndex(index: nextIndex, left: false)
        }
        //set currentPage
        pageIndicator.currentPage = currentIndex
        //update UI
        updateScrollView()
        //reset timer
        startTimer()
    }
    
    //timer action set contentoffset then take this function
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    fileprivate func getImgIndex(index: NSInteger, left: Bool) -> NSInteger {
        if left == true {
            let tmpIndex = index - 1
            if tmpIndex == -1 {
                return imgNames.count - 1
            } else {
                return tmpIndex
            }
        } else {
            let tmpIndex = index + 1
            if tmpIndex >= imgNames.count {
                return 0
            } else {
                return tmpIndex
            }
        }
    }
    
    //MARK: dealloc(OC), deinit(swift)
    deinit {
        stopTimer()
    }
    
    
}
