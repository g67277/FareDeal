//
//  DealsCell.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import AssetsLibrary
import RealmSwift

class DealsCell: UITableViewCell {
    
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealDesc: UILabel!
    @IBOutlet weak var timeLimit: UILabel!
    @IBOutlet weak var dealValue: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var dealImg: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func getUIImagefromAsseturl (url: NSURL) {
        var asset = ALAssetsLibrary()
        
        asset.assetForURL(url, resultBlock: { asset in
            if let ast = asset {
                let assetRep = ast.defaultRepresentation()
                let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                let image = UIImage(CGImage: iref)
                dispatch_async(dispatch_get_main_queue(), {
                    self.dealImg.image = image
                })
            }
            }, failureBlock: { error in
                println("Error: \(error)")
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refreshCell(title: String, desc: String, time: Int, value: String, tier: Int){
        
        dealTitle.text = title
        dealDesc.text = desc
        if time < 2 {
            timeLimit.text = "\(time)hr limit"
        }else{
            timeLimit.text = "\(time)hrs limit"
        }
        dealValue.text = value
        tierLabel.text = "Tier \(tier)"
        
        var data = Realm().objectForPrimaryKey(ProfileModel.self, key: "will change")
        var path = data?.imgUri
        var imgURL = NSURL(string: path!)
        getUIImagefromAsseturl(imgURL!)
        
        dealImg.layer.masksToBounds = false
        dealImg.layer.borderColor = UIColor.blackColor().CGColor
        dealImg.layer.cornerRadius = dealImg.frame.height/2
        dealImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
