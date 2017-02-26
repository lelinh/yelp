//
//  BusinessCell.swift
//  Yelp
//
//  Created by Linh Le on 2/22/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking
class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    var business:Business! {
        didSet{
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            ratingImage.setImageWith(business.ratingImageURL!)
            if(business.imageURL != nil){businessImage.setImageWith(business.imageURL!)}
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
