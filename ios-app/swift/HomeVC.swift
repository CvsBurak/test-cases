//
//  HomeVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 29/04/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
   
    @IBOutlet var tableView: UITableView!
    @objc var posts = [AnyObject]()
    @objc var images = [UIImage]()
    @objc var avas = [UIImage]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let username = (user!["username"] as AnyObject).uppercased
        self.navigationItem.title = username
        
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
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
        
    }
    
    @IBAction func logout_click(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "parseJSON")
        UserDefaults.standard.synchronize()
        
        let loginvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginvc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeCell
        
        let pos = posts[indexPath.row]
        let image = images[indexPath.row]
        let username = pos["username"] as? String
        let ava = avas[indexPath.row]
        let text = pos["text"] as? String
        let date = pos["date"] as! String
        
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormater.date(from: date)!

        let from = newDate
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from, to: now, options: [])

        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.second))s." 
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.minute))m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.hour))h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(String(describing: difference.day))d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(String(describing: difference.weekOfMonth))w."
        }
        
        cell.usernameLbl.text = username
        cell.textLbl.text = text
        cell.pictureImg.image = image
        cell.avaImg.image = ava
        
        DispatchQueue.main.async {

            if image.size.width == 0 && image.size.height == 0 {
                cell.textLbl.frame.origin.x = self.view.frame.size.width / 16
                cell.textLbl.frame.size.width = self.view.frame.size.width -
                    self.view.frame.size.width / 8
                cell.textLbl.sizeToFit()
            }
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    @objc func loadPosts() {
        
        let id = user!["id"] as! String
        let url = URL(string: "http://" + ip + "/GProject/posts.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "id=\(id)&uuid=&text="
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        self.posts.removeAll(keepingCapacity: false)
                        self.images.removeAll(keepingCapacity: false)
                        self.avas.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        guard let post = parseJSON["posts"] as? [AnyObject] else {
                            print("Error while parseJSONing")
                            return
                        }
                        
                        self.posts = post
                        
                        for i in 0 ..< self.posts.count {
                            
                            let path = self.posts[i]["path"] as? String
                            
                            if !path!.isEmpty {
                                let url = URL(string: path!)!
                                let imageData = try? Data(contentsOf: url)
                                let image = UIImage(data: imageData!)!
                                self.images.append(image)
                            } else {
                                let image = UIImage()
                                self.images.append(image)
                            }
                            let ava = self.posts[i]["ava"] as? String
                            
                            if !ava!.isEmpty {
                                let url = URL(string: ava!)!
                                let imageData = try? Data(contentsOf: url)
                                let image = UIImage(data: imageData!)!
                                self.avas.append(image)
                            } else {
                                let image = UIImage(named: "ava.jpg")
                                self.avas.append(image!)
                            }
                            
                        }
                        self.tableView.reloadData()
                        
                        
                    } catch {
                        /* DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return */
                    }
                    
                } else {
                    /* DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return */
                }
                
            })
            
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}











