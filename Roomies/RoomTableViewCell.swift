//
//  RoomTableViewCell.swift
//  Roomies
//
//  Created by Emilija Chona on 8/16/23.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: UIImage, text: String) {
            imgView.image = image
            desc.text = text
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
