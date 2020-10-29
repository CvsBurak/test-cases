//
//  UsersCell.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 10/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var fullnameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        usernameLbl.textColor = colorLightGreen
        
    }
}
