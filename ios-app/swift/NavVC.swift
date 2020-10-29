//
//  NavVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 29/04/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.navigationBar.tintColor = .white
        
        self.navigationBar.barTintColor = colorLightGreen
        
        self.navigationBar.isTranslucent = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

  

}
