//
//  sideMenuMain2.swift
//  excs
//
//  Created by user on 2018. 10. 30..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class sideMenuMain2: sideMenuMain {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("22222222")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.sideMenu1 = "ShowSideMenu2012"
        super.sideMenu2 = "ShowSideMenu2022"
        super.sideMenu3 = "ShowSideMenu2032"
        super.sideMenu4 = "ShowSideMenu2042"
        super.userMyPage = "ShowMyPage2"
        super.artistRegiMenu = "ShowArtistRegiMenu2"
        super.artistPageMenu = "ShowArtistPageMenu2"
        super.someoneArtist = "someoneArtist2"
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.sideMenu1), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.sideMenu2), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.sideMenu3), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.sideMenu4), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.userMyPage), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.artistRegiMenu), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.artistPageMenu), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(super.someoneArtist), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu201), name: NSNotification.Name(super.sideMenu1), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu202), name: NSNotification.Name(super.sideMenu2), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu203), name: NSNotification.Name(super.sideMenu3), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSideMenu204), name: NSNotification.Name(super.sideMenu4), object: nil)
        print(sideMenu1 + UserDefaults.standard.string(forKey: "mainState")!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUserInfoMenu), name: NSNotification.Name(super.userMyPage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showArtistRegiMenu), name: NSNotification.Name(super.artistRegiMenu), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(s2howArtistPageMenu), name: NSNotification.Name(super.artistPageMenu), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(someoneArtistFunc), name: NSNotification.Name(super.someoneArtist), object: nil)
        
        print("2 did appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func s2howArtistPageMenu(){
        performSegue(withIdentifier: "ShowArtistPageMenu2", sender: nil)
        hideTheView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
