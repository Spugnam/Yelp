//
//  BusinesCell.swift
//  Yelp
//
//  Created by quentin picard on 10/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinesCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel! // not part of API
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            adressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingsImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width // Apple "bug" on wrapping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width // Apple "bug" on wrapping

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
