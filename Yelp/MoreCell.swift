//
//  MoreCell.swift
//  Yelp
//
//  Created by Linh Le on 2/26/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
@objc protocol MoreCellDelegate {
    @objc optional func moreCell(moreCell: MoreCell, didChangeValue value: Bool)
}
class MoreCell: UITableViewCell {

    weak var delegate: MoreCellDelegate!
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBAction func moreActionButton(_ sender: UIButton) {
        delegate?.moreCell!(moreCell: self, didChangeValue: true)
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
