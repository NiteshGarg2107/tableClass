//
//  cellClass.swift
//  testtableview
//
//  Created by Nitesh Garg on 20/03/21.
//

import UIKit

class cellClass: UITableViewCell {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var detailText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
