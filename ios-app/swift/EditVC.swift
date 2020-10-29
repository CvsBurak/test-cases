//
//  EditVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 13/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var surnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var aboutTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let username = user!["username"] as? String
        let fullname = user!["fullname"] as? String
        
        let fullnameArray = fullname!.split {$0 == " "}.map(String.init)
        let firstname = fullnameArray[0]
        let lastname = fullnameArray[1]
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        let about = user!["about"] as? String
        
        navigationItem.title = "PROFILE"
        usernameTxt.text = username
        nameTxt.text = firstname
        surnameTxt.text = lastname
        aboutTxt.text = about
        emailTxt.text = email
        fullnameLbl.text = "\(nameTxt.text!) \(surnameTxt.text!)"
        
        if ava != "" {
            let imageURL = URL(string: ava!)!
            DispatchQueue.main.async(execute: {
                let imageData = try? Data(contentsOf: imageURL)
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.avaImg.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
        avaImg.clipsToBounds = true
        saveBtn.layer.cornerRadius = saveBtn.bounds.width / 4.5

        //saveBtn.backgroundColor = colorBrandBlue

        saveBtn.isEnabled = false
        saveBtn.alpha = 0.4

        usernameTxt.delegate = self
        nameTxt.delegate = self
        surnameTxt.delegate = self
        emailTxt.delegate = self
        
        nameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), for: .editingChanged)
        surnameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), for: .editingChanged)
        usernameTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(EditVC.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextView) {
        fullnameLbl.text = "\(nameTxt.text!) \(surnameTxt.text!)"
        if usernameTxt.text!.isEmpty || nameTxt.text!.isEmpty || surnameTxt.text!.isEmpty || emailTxt.text!.isEmpty {
            
            saveBtn.isEnabled = false
            saveBtn.alpha = 0.4
        } else {
            
            saveBtn.isEnabled = true
            saveBtn.alpha = 1
            
        }
        
    }
    
    @IBAction func save_click(_ sender: Any) {
        
        if usernameTxt.text!.isEmpty || emailTxt.text!.isEmpty || nameTxt.text!.isEmpty || surnameTxt.text!.isEmpty || aboutTxt.text!.isEmpty{

            usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            surnameTxt.attributedPlaceholder = NSAttributedString(string: "surname", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            aboutTxt.attributedPlaceholder = NSAttributedString(string: "About me", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])

        } else {

            self.view.endEditing(true)
            
            let username = usernameTxt.text!.lowercased()
            let fullname = fullnameLbl.text!
            let email = emailTxt.text!.lowercased()
            let about = aboutTxt.text!
            let id = user!["id"]!
            
            let url = URL(string: "http://" + ip + "/GProject/update.php")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body = "username=\(username)&fullname=\(fullname)&email=\(email)&about=\(about)&id=\(id)"
            request.httpBody = body.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, response, error in

                if error == nil {
                
                    DispatchQueue.main.async(execute: {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }

                            let id = parseJSON["id"]
                            if id != nil {

                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                DispatchQueue.main.async(execute: {
                                    appDelegate.login()
                                })
                                
                            }
                        } catch {
                            print("Caught an error: \(error)")
                        }
                        
                    })

                } else {
                    print("Error: \(String(describing: error))")
                }
                
                }.resume()
            
            
        }
            
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    

}
