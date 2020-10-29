//
//  UsersVC.swift
//  GProject
//
//  Created by Burak Çavuşoğlu on 10/05/2018.
//  Copyright © 2018 Burak Çavuşoğlu. All rights reserved.
//

import UIKit

class UsersVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @objc var users = [AnyObject]()
    @objc var avas = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = .white
        searchBar.tintColor = colorLightGreen
        searchBar.showsCancelButton = false
        
        doSearch("")

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch(searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        users.removeAll(keepingCapacity: false)
        avas.removeAll(keepingCapacity: false)
        tableView.reloadData()
        
        doSearch("")
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersCell
        
        let user = users[indexPath.row]
        let ava = avas[indexPath.row]
        let username = user["username"]
        let fullname = user["fullname"]
        
        cell.usernameLbl.text = username as? String
        cell.fullnameLbl.text = fullname as? String
        cell.avaImg.image = ava
        return cell
    }
    
    @objc func doSearch(_ word : String) {
        
        let word = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let username = user!["username"] as! String
        let url = URL(string: "http://" + ip + "/GProject/users.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "word=\(word)&username=\(username)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        self.users.removeAll(keepingCapacity: false)
                        self.avas.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()

                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        guard let parseUSERS = parseJSON["users"] else {
                            print(parseJSON["message"] ?? [NSDictionary]())
                            return
                        }
                        self.users = parseUSERS as! [AnyObject]

                        for i in 0 ..< self.users.count {

                            let ava = self.users[i]["ava"] as? String
                            
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
            
            } .resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let cell = sender as? UITableViewCell {

            let index = tableView.indexPath(for: cell)!.row

            if segue.identifier == "guest" {

                let guestvc = segue.destination as! GuestVC
                guestvc.guest = users[index] as! NSDictionary
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
            }
            
        }
        
    }
    
}
