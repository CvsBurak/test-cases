//
//  PostVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 07/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet var countLbl: UILabel!
    @IBOutlet var textTxt: UITextView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var pictureImg: UIImageView!
    @IBOutlet var postBtn: UIButton!
    
    @objc var uuid = String()
    @objc var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textTxt.layer.cornerRadius = textTxt.bounds.width / 50
        postBtn.layer.cornerRadius = postBtn.bounds.width / 20
        
        textTxt.backgroundColor = colorSmoothGray
        selectBtn.backgroundColor = colorDarkGray
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        postBtn.isEnabled = false
        postBtn.alpha = 0.4
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text.characters.count
        
        let spacing = NSCharacterSet.whitespacesAndNewlines
        countLbl.text = String(300 - chars)
        
        if chars > 300 {
            countLbl.textColor = colorSmoothRed
            postBtn.isEnabled = false
            postBtn.alpha = 0.4
        } else if textView.text.trimmingCharacters(in: spacing).isEmpty {
            postBtn.isEnabled = false
            postBtn.alpha = 0.4
            
        } else {
            countLbl.textColor = colorSmoothGray
            postBtn.isEnabled = true
            postBtn.alpha = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    

    @IBAction func select_click(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pictureImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        if pictureImg.image == info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelected = true
        }
    }
       @objc func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
            
            let body = NSMutableData();
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
            }
        
            var filename = ""
            
            if imageSelected == true {
                filename = "post-\(uuid).jpg"
            }
            
            
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    func uploadPost() {
        
        let id = user!["id"] as! String
        uuid = UUID().uuidString
        let text = textTxt.text.trunc(300) as String
        
        let url = URL(string: "http://" + ip + "/GProject/posts.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let param = [
            "id" : id,
            "uuid" : uuid,
            "text" : text
        ]
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        
        if pictureImg.image != nil {
            imageData = UIImageJPEGRepresentation(pictureImg.image!, 0.5)!
        }
        request.httpBody = createBodyWithParams(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        let message = parseJSON["message"]
                        
                        if message != nil {
                            
                            self.textTxt.text = ""
                            self.countLbl.text = "300"
                            self.pictureImg.image = nil
                            self.postBtn.isEnabled = false
                            self.postBtn.alpha = 0.4
                            self.imageSelected = false
                            self.tabBarController?.selectedIndex = 0
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
                
                
            })
            
            }.resume()
    }
    
    @IBAction func post_click(_ sender: Any) {
        
        if !textTxt.text.isEmpty && textTxt.text.count <= 300 {
            
             uploadPost()
            
        }
        
    }
        
}

extension String {
    
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        
        if self.count > length {
            return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
        
    }
    
}

