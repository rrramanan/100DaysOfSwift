//
//  PhotoCell.swift
//  Project10-12 CL
//
//  Created by R R on 07/01/21.
//

import UIKit

class PhotoCell: UITableViewCell {
   
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
