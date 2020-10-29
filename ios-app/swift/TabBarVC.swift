//
//  TabBarVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 29/04/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .white

        self.tabBar.barTintColor = colorDarkGray
        
        self.tabBar.isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : colorSmoothGray], for: UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageColor(colorSmoothGray).withRenderingMode(.alwaysOriginal)
            }
        }
        
        
    }
}
    
    
extension UIImage {
        
        // in this func, customize UIImage
        @objc func imageColor(_ color : UIColor) -> UIImage {
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            
            let context = UIGraphicsGetCurrentContext()! as CGContext
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
            context.clip(to: rect, mask: self.cgImage!)
            
            color.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            
            return newImage
        }

    
}
