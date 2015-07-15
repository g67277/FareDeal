//
//  ViewController.swift
//  inAppPurchase for FD
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var tableView = UITableView()
    let productIdenifiers = Set(["com.snastek.testTier1C", "com.snastek.testTier2C"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: self.view.frame)
        
        tableView.separatorColor = UIColor.clearColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductData()
    }
    
    
    func requestProductData(){
        
        if SKPaymentQueue.canMakePayments(){
            let request = SKProductsRequest(productIdentifiers: self.productIdenifiers as Set<NSObject>)
            request.delegate = self
            request.start()
        }else {
            var alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
        var products = response.products
        
        if (products.count != 0){
            for var i = 0; i < products.count; i++ {
                self.product = products[i] as? SKProduct
                self.productsArray.append(product!)
            }
            self.tableView.reloadData()
        }else{
            println("No products found")
        }
        
        products = response.invalidProductIdentifiers
        
        for product in products {
            println("Product not found: \(product)")
        }
        
    }
    
    func buyProduct(sender: UIButton){
        let payment = SKPayment(product: productsArray[sender.tag])
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                println("Transaction Approved")
                println("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                println("Transation Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "com.snastek.testTier1C" {
            
            println("$10 purchased")
            // Unlock feature or add credits
        }else if transaction.payment.productIdentifier == "com.snastek.testTier2C" {
            
            println("$15 purchased")
            // Add credits
            
        }
        
    }
    
    
    
    
    // Screen Layout Methods

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.productsArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellFrame = CGRectMake(0, 0, self.tableView.frame.width, 52.0)
        var retCell = UITableViewCell(frame: cellFrame)
        
        if self.productsArray.count != 0
        {
            if indexPath.row == 2
            {
                var restoreButton = UIButton(frame: CGRectMake(10.0, 10.0, UIScreen.mainScreen().bounds.width - 20.0, 44.0))
                restoreButton.titleLabel!.font = UIFont (name: "HelveticaNeue-Bold", size: 20)
                restoreButton.addTarget(self, action: "restorePurchases:", forControlEvents: UIControlEvents.TouchUpInside)
                restoreButton.backgroundColor = UIColor.blackColor()
                restoreButton.setTitle("Restore Purchases", forState: UIControlState.Normal)
                retCell.addSubview(restoreButton)
            }
            else
            {
                var singleProduct = productsArray[indexPath.row]
                
                var titleLabel = UILabel(frame: CGRectMake(10.0, 0.0, UIScreen.mainScreen().bounds.width - 20.0, 25.0))
                titleLabel.textColor = UIColor.blackColor()
                titleLabel.text = singleProduct.localizedTitle
                titleLabel.font = UIFont (name: "HelveticaNeue", size: 20)
                retCell.addSubview(titleLabel)
                
                var descriptionLabel = UILabel(frame: CGRectMake(10.0, 10.0, UIScreen.mainScreen().bounds.width - 70.0, 40.0))
                descriptionLabel.textColor = UIColor.blackColor()
                descriptionLabel.text = singleProduct.localizedDescription
                descriptionLabel.font = UIFont (name: "HelveticaNeue", size: 12)
                retCell.addSubview(descriptionLabel)
                
                var buyButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60.0, 5.0, 50.0, 20.0))
                buyButton.titleLabel!.font = UIFont (name: "HelveticaNeue", size: 12)
                buyButton.tag = indexPath.row
                buyButton.addTarget(self, action: "buyProduct:", forControlEvents: UIControlEvents.TouchUpInside)
                buyButton.backgroundColor = UIColor.blackColor()
                var numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                numberFormatter.locale = NSLocale.currentLocale()
                buyButton.setTitle(numberFormatter.stringFromNumber(singleProduct.price), forState: UIControlState.Normal)
                retCell.addSubview(buyButton)
            }
        }
        
        return retCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 52.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {	return 64.0
        }
        
        return 32.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let ret = UILabel(frame: CGRectMake(10, 0, self.tableView.frame.width - 20, 32.0))
        ret.backgroundColor = UIColor.clearColor()
        ret.text = "In-App Purchases"
        ret.textAlignment = NSTextAlignment.Center
        return ret
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

