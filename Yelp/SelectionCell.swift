//
//  SelectionCell.swift
//  Yelp
//
//  Created by Linh Le on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
@objc protocol SelectionCellDelegate {
    @objc optional func selectionCell(selectionCell: SelectionCell, didChangeValue value: Bool)
}
class SelectionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBAction func isSelectButton(_ sender: UIButton) {
        if (selectButton.currentImage?.isEqual(UIImage(named: "switchIcon")))!{
            selectButton.setImage(#imageLiteral(resourceName: "switchIconClicked"), for: .normal)
            delegate?.selectionCell!(selectionCell: self, didChangeValue: true)

        }else{
            selectButton.setImage(#imageLiteral(resourceName: "switchIcon"), for: .normal)
            delegate?.selectionCell!(selectionCell: self, didChangeValue: false)
        }

    }
    
    weak var delegate: SelectionCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
