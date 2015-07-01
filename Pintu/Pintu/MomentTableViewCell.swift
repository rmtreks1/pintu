//
//  MomentTableViewCell.swift
//  Pintu
//
//  Created by Roshan Mahanama on 19/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

// for new direction



import UIKit
import AVKit

class MomentTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages = [UIImage]()
    var pageViews: [UIImageView?] = []
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    var likeState: Bool?
    
    var playerVC = AVPlayerViewController()
    
    var mediaType: String? // change this to an enum
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpCell(){
        
        // like button images
        let buttonStateLikeImage = UIImage(named: "heart-full")
        let buttonStateNotLikedImage = UIImage(named: "heart-empty")
        
        self.likeButton.setImage(buttonStateLikeImage, forState: UIControlState.Selected)
        self.likeButton.setImage(buttonStateNotLikedImage, forState: UIControlState.Normal)
    }
    
    
    func setUpVideoCell(width: CGFloat){
        self.playerVC.player = DataSource.sharedInstance.videoAssetForTesting
        self.playerVC.showsPlaybackControls = false
        self.playerVC.player.volume = Float(0)
        self.playerVC.view.frame = CGRectMake(0, 0, width, width)
        self.playerVC.view.userInteractionEnabled = false
        
        

        // Invoke after player is created and AVPlayerItem is specified
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: self.playerVC.player.currentItem)
        
        
        self.contentView.addSubview(self.playerVC.view)
        
        self.mediaType = "video"
        
        playerVC.player.play()
    }
    
    
    
    
   
    
    
    //function to restart the video
    func playerItemDidReachEnd(notification: NSNotification) {
        println("restarting video")
        self.playerVC.player.seekToTime(kCMTimeZero)
        self.playerVC.player.play()
    }
    
    
    
    func resetCell(){
        println("reset cell")
        pageImages = []
        pageViews = []
        commentLabel.text = nil
        profileImageView.image = UIImage(named: "placeholder.png")
        self.likeButton.selected = false
        self.playerVC.view.removeFromSuperview()
    }
    
    
    
    
    func setupTheScrollView(width: CGFloat){
        
        self.scrollView.delegate = self

        // circular profile image view
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        
        self.commentLabel.sizeToFit()
        
        // 1
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        scrollView.frame.size = CGSize(width: width, height: width)
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        println("view did load scroll view width is... \(scrollView.frame.size.width)")
        println(scrollView.frame.size.height)
        
        //        self.pageWidth = scrollView.frame.size.width
        //        self.pageHeight = scrollView.frame.size.height
        
        
        
        // 4.1 Content Offset
        
        
        
        
        
        
        // 5
        loadVisiblePages()
        
        
    }
    
    
    
    // MARK: - Content
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            println(frame.size.width)
            println("scroll view width is... \(scrollView.frame.size.width)")
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFill
            newPageView.frame = frame
            newPageView.clipsToBounds = true
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    
    
    
    @IBAction func likeButtonPressed(sender: UIButton) {
        println("like button pressed")

        if self.likeButton.selected {
            println("unlike this")
            self.likeButton.selected = false
        } else {
            println("like this")
            self.likeButton.selected = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
