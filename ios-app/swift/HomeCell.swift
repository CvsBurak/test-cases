//
//  HomeCell.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 13/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

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
        
        self.unlikeBtn.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func like_click(_ sender: Any) {
        
        self.likeBtn.isEnabled = true
        self.likeBtn.isHidden = true
        self.unlikeBtn.isHidden = false
        
    }
    
    @IBAction func unlike_click(_ sender: Any) {
        
        self.unlikeBtn.isEnabled = false
        self.unlikeBtn.isHidden = true
        self.likeBtn.isHidden = false
        
    }
    

}
