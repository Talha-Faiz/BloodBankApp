//
//  AllRequestTableViewCell.swift
//  MyBloodBank
//
//  Created by Talha Faiz on 02/02/2020.
//  Copyright © 2020 Talha Faiz. All rights reserved.
//

import UIKit

class AllRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var img_image : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bloodGroupLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.selectionStyle = .none
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 12.0
        cardView.layer.shadowOpacity = 0.7
        img_image.roundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(title: String){
        titleLabel.text = title
    }
    
}
