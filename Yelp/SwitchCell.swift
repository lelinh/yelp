//
//  SwitchCell.swift
//  Yelp
//
//  Created by Linh Le on 2/22/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBAction func switchAction(_ sender: UISwitch) {
        delegate?.switchCell?(switchCell: self, didChangeValue: switchButton.isOn)
    }
    
    
    weak var delegate: SwitchCellDelegate!    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onSwitch(_ sender: UISwitch) {
        
    }

}
