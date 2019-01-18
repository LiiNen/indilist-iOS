//
//  sideMenuMain.swift
//  excs
//
//  Created by user on 2018. 9. 16..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class sideMenuMain: UIViewController {
    var userMyPage = "ShowMyPage"
    var artistRegiMenu = "ShowArtistRegiMenu"
    var artistPageMenu = "ShowArtistPageMenu"
    
    var sideMenu1 = "ShowSideMenu201"
    var sideMenu2 = "ShowSideMenu202"
    var sideMenu3 = "ShowSideMenu203"
    var sideMenu4 = "ShowSideMenu204"
    
    var someoneArtist = "someoneArtist"
    
    @IBOutlet weak var menuitem: UIBarButtonItem!
    @IBAction func onMoreTapped(){
        print("Toggle Side Menu")
        
        let temp = UserDefaults.standard.bool(forKey: "isHidden")
        print("result",temp)
        if(!temp){
            NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("tap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onMoreTapped), name: NSNotification.Name("tap"), object: nil)
    }
    
    @objc func showUserInfoMenu(){
        performSegue(withIdentifier: userMyPage, sender: nil)
        hideTheView()
    }
    @objc func showArtistRegiMenu(){
        performSegue(withIdentifier: artistRegiMenu, sender: nil)
        hideTheView()
    }
    @objc func showArtistPageMenu(){
        performSegue(withIdentifier: artistPageMenu, sender: nil)
        hideTheView()
    }
    
    @objc func showSideMenu201() {
        performSegue(withIdentifier: sideMenu1, sender: nil)
        hideTheView()
    }
    
    @objc func showSideMenu202() {
        performSegue(withIdentifier: sideMenu2, sender: nil)
        hideTheView()
    }
    
    @objc func showSideMenu203() {
        performSegue(withIdentifier: sideMenu3, sender: nil)
        hideTheView()
    }
    
    @objc func showSideMenu204() {
        performSegue(withIdentifier: sideMenu4, sender: nil)
        hideTheView()
    }
    
    @objc func someoneArtistFunc(){
        performSegue(withIdentifier: someoneArtist, sender: nil)
        hideTheView()
    }
    
    func hideTheView(){
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "HideTheView" + temp!
        print(str)
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        print("사라지다")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
}
