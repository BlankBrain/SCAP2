//
//  cell.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit

class cell: UITableViewCell {

    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
