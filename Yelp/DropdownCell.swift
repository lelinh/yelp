//
//  DropdownCell.swift
//  Yelp
//
//  Created by Linh Le on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
@objc protocol DropdownCellDelegate {
    @objc optional func dropdownCell(dropdownCell: DropdownCell, didChangeValue value: Bool)
}
class DropdownCell: UITableViewCell,SelectionCellDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropdownButton: UIButton!
    
    @IBAction func isSelected(_ sender: UIButton) {
        
        if (dropdownButton.currentImage?.isEqual(UIImage(named: "dropdownIconClicked")))!{
            dropdownButton.setImage(#imageLiteral(resourceName: "dropdownIcon"), for: .normal)
            delegate?.dropdownCell!(dropdownCell: self, didChangeValue: false)
        }else{
            dropdownButton.setImage(#imageLiteral(resourceName: "dropdownIconClicked"), for: .normal)
            delegate?.dropdownCell!(dropdownCell: self, didChangeValue: true)
        }
    }
    
    weak var delegate: DropdownCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
