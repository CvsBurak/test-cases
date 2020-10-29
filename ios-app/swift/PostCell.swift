//
//  PostCell.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 08/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var pictureImg: UIImageView!
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        usernameLbl.textColor = colorDarkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
