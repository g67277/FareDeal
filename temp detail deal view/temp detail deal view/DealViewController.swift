//
//  DealViewController.swift
//  temp detail deal view
//
//  Created by Angela Smith on 8/7/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class DealViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var bestButton: UIButton!
     @IBOutlet var newestButton: UIButton!
     @IBOutlet var oldestButton: UIButton!
    //@IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var collectionCardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
    }
    
    @IBAction func onButtonSelect(sender: UIButton) {
        if sender.tag == 0 {
            bestButton.selected = true
            newestButton.selected = false
            oldestButton.selected = false
        } else if sender.tag == 1 {
            bestButton.selected = false
            newestButton.selected = true
            oldestButton.selected = false
        }  else if sender.tag == 2 {
            bestButton.selected = false
            newestButton.selected = false
            oldestButton.selected = true
        }
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dealCell", forIndexPath: indexPath) as! dealCell
        var pages: Int = Int(collectionView.contentSize.width/collectionView.frame.size.width)
        pageController.numberOfPages = pages
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // get the height of the view
        var height: CGFloat = collectionCardView.bounds.height * 0.75
        var width = height * 1.9
        
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = UIColor.magentaColor()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
      var width: CGFloat  =  collectionCardView.frame.size.width
        if var currentCard = Float(self.cardCollectionView.contentOffset.x / width) {
            if (0.0 != fmodf(currentCard, 1.0)) {
                pageController.currentPage =  Int(currentCard + 1)
            } else {
                pageController.currentPage = Int(currentCard)
            }
        }
    }
    


    
}
