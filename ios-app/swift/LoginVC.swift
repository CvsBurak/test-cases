//
//  LoginVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 27/04/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login_click(_ sender: AnyObject) {
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])

        } else {

            self.view.endEditing(true)

            let username = usernameTxt.text!.lowercased()
            let password = passwordTxt.text!
            
            let url = URL(string: "http://" + ip + "/GProject/login.php")!

            var request = URLRequest(url: url)

            request.httpMethod = "POST"

            let body = "username=\(username)&password=\(password)"

            request.httpBody = body.data(using: .utf8)

            URLSession.shared.dataTask(with: request) { data, response, error in

                if error == nil {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        

                        let id = parseJSON["id"] as? String

                        if id != nil {

                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary

                            DispatchQueue.main.async(execute: {
                                appDelegate.login()
                            })

                        } else {

                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            return
                            
                        }
                        
                    } catch {

                        DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return
                        
                    }
                    
                } else {

                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return
                    
                }
                
                }.resume()
            
        }
        
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    
}

