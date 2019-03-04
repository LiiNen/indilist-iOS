//
//  sideMenu.swift
//  excs
//
//  Created by user on 2018. 9. 16..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class sideMenu: UITableViewController {

    @IBOutlet var outletView: UITableView!
    
    @IBOutlet weak var aritistMenuBtn: UIButton!
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var whoAreYou: UILabel!
    @IBOutlet weak var welcomeMes: UILabel!
    
    override func viewDidLoad() {
        outletView.layer.borderWidth = 0.3
        outletView.layer.borderColor = UIColor.gray.cgColor
        print("side menu view will appeare")
        self.userImage.imageView?.layer.cornerRadius = 0.5 * (self.userImage.imageView?.bounds.size.width)!
        let artistBool = UserDefaults.standard.string(forKey: "loginIsAritist")
        let userName = UserDefaults.standard.string(forKey: "loginName")
        if(userName == nil){
            return
        }
        
        welcomeMes.text = userName! + "님, 안녕하세요"
        
        if(artistBool == "1"){
            aritistMenuBtn.setImage(UIImage(named: "artistPage"), for: .normal)
            whoAreYou.text = "Artist"
        }
        else{
            aritistMenuBtn.setImage(UIImage(named: "artistRegister"), for: .normal)
            whoAreYou.text = "Listener"
        }
        
        let userImageURL = UserDefaults.standard.string(forKey: "loginPhoto")!
        print(userImageURL)
        if let url = URL(string: userImageURL) {
            userImage.imageView?.contentMode = .scaleAspectFit
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.userImage.setImage(UIImage(data: data), for: .normal)
                    self.userImage.imageView?.layer.cornerRadius = 0.5 * (self.userImage.imageView?.bounds.size.width)!
                    
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        let sNum = UserDefaults.standard.string(forKey: "mainState")
        
        if(indexPath.row <= 1 ){
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        print("mystate : showsidemenu201 snum : ", sNum!)
        print(indexPath.row)
        switch(indexPath.row){
        case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu201" + sNum!), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu202" + sNum!), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu203" + sNum!), object: nil)
        case 5: NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu204" + sNum!), object: nil)
        default: break
        }
        UserDefaults.standard.synchronize()
    }
    
    //do same thing
    @IBAction func userImage(_ sender: Any) {
        let sNum = UserDefaults.standard.string(forKey: "mainState")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu201" + sNum!), object: nil)
//        let sNum = UserDefaults.standard.string(forKey: "mainState")
//        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("ShowMyPage" + sNum!), object: nil)
    }
    @IBAction func myPageBtn(_ sender: Any) {
        let sNum = UserDefaults.standard.string(forKey: "mainState")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ShowSideMenu201" + sNum!), object: nil)
//
//        let sNum = UserDefaults.standard.string(forKey: "mainState")
//        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("ShowMyPage" + sNum!), object: nil)
    }
    //do same things
    
    
    @IBAction func artistMenuBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        let artistBool = UserDefaults.standard.string(forKey: "loginIsAritist")!
        let sNum = UserDefaults.standard.string(forKey: "mainState")
        print(artistBool, "<<<<<<<<<<<<<<<<<<<<<<")
        print(">><><><>[][][][][]", sNum!)
        UserDefaults.standard.removeObject(forKey: "notME")
        if(artistBool == "1"){
            NotificationCenter.default.post(name: NSNotification.Name("ShowArtistPageMenu" + sNum!), object: nil)
            print(">><><><>[][][][][]", sNum!)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name("ShowArtistRegiMenu" + sNum!), object: nil)
        }
    }
    
    

}
