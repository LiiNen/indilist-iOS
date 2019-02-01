//
//  ViewController.swift
//  excs
//
//  Created by user on 2018. 8. 11..
//  Copyright © 2018년 user. All rights reserved.
//

import Alamofire
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outtouchBtn: UIButton!
    @IBOutlet weak var sideContainer1: UIView!
    @IBOutlet weak var scrollContainer: UIView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // login
    override func viewWillAppear(_ animated: Bool) {
        let loginChecker = UserDefaults.standard.bool(forKey: "loginSuccess")
        if(!loginChecker){
            UserDefaults.standard.set(false, forKey: "loginSuccess")
            UserDefaults.standard.synchronize()
            logoutUserInfo()
            self.performSegue(withIdentifier: "goMenu", sender: self)
        }
        else{
            userInfoPrint()
        }
        UserDefaults.standard.setValue("1", forKey: "mainState")
        UserDefaults.standard.synchronize()
        
        //self.view.sendSubview(toBack: sideContainer1)
    }
    
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loginSuccess")
        UserDefaults.standard.synchronize()
        logoutUserInfo()
        self.performSegue(withIdentifier: "goMenu", sender: self)
    }
 
    func logoutUserInfo(){
        UserDefaults.standard.set("", forKey: "loginName")
        UserDefaults.standard.set("", forKey: "loginId")
        UserDefaults.standard.set("", forKey: "loginSignuptime")
        UserDefaults.standard.set("", forKey: "loginPhoto")
        UserDefaults.standard.set("", forKey: "loginEmail")
        UserDefaults.standard.set("", forKey: "loginEmailverify")
        UserDefaults.standard.set("", forKey: "loginIsAritist")
        UserDefaults.standard.set("", forKey: "loginUser_quit")
        UserDefaults.standard.set("", forKey: "loginToken")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("KKK"), object: nil)
    }
    
    // side menu
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    
    
    @IBAction func menuBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("tap"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logOutAction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutBtn(_:)), name: NSNotification.Name("logOutAction"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        
        UserDefaults.standard.setValue(true, forKey: "mainView1")
        UserDefaults.standard.synchronize()

        sideMenuOpen = false
        sideMenuConstraint.constant = self.view.bounds.size.width
        //bottomConstraint.constant = 562
        
        //userInfoPrint()
        UserDefaults.standard.setValue("1", forKey: "mainState")
        
        UserDefaults.standard.synchronize()
        sideMenuConstraint.constant = self.view.bounds.size.width - 316
        sideMenuConstraint.constant = self.view.bounds.size.width
        
        scrollContainer.layer.borderWidth = 0.3
        scrollContainer.layer.borderColor = UIColor.gray.cgColor
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
        
        outtouchBtn.isEnabled = false
        outtouchBtn.isHidden = true
    }
    
    @objc func toggleSideMenu() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuDo1), name: NSNotification.Name("menuDo1"), object: nil)
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = self.view.bounds.size.width
            outtouchBtn.isEnabled = false
            outtouchBtn.isHidden = true
        } else {
            let isslogin = UserDefaults.standard.bool(forKey: "loginSuccess")
            if(!isslogin){
                UserDefaults.standard.set(false, forKey: "loginSuccess")
                UserDefaults.standard.synchronize()
                logoutUserInfo()
                self.performSegue(withIdentifier: "goMenu", sender: self)
                return
            }
            else{
                sideMenuOpen = true
                sideMenuConstraint.constant = self.view.bounds.size.width - 316
                self.view.sendSubviewToBack(sideContainer1)
                outtouchBtn.isEnabled = true
                outtouchBtn.isHidden = false
            }
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func outtouchBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func menuDo1(){
        self.view.bringSubviewToFront(sideContainer1)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("menuDo1"), object: nil)
        sideMenuConstraint.constant = self.view.bounds.size.width
    }
    
    @objc func hideTheView1(){
        self.sideContainer1.backgroundColor = UIColor.white
    }
    
    @objc func showTheView1(){
        self.sideContainer1.backgroundColor = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.sendSubviewToBack(sideContainer1)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("HidTheView1"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ShowTheView1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTheView1),name:NSNotification.Name("HidTheView1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTheView1), name: NSNotification.Name("ShowTheView1"), object: nil)
        UserDefaults.standard.setValue("1", forKey: "mainState")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    func userInfoPrint(){
        
        print(UserDefaults.standard.bool(forKey: "loginSuccess"))
        print(UserDefaults.standard.string(forKey: "loginName")! + "2")
        print(UserDefaults.standard.string(forKey: "loginId")! + "3")
        print(UserDefaults.standard.string(forKey: "loginSignuptime")! + "4")
        print(UserDefaults.standard.string(forKey: "loginPhoto")! + "5")
        print(UserDefaults.standard.string(forKey: "loginEmail")! + "6")
        print(UserDefaults.standard.string(forKey: "loginEmailverify")! + "7")
        print(UserDefaults.standard.string(forKey: "loginIsAritist")! + "8")
        print(UserDefaults.standard.string(forKey: "loginUser_quit")! + "9")
        print(UserDefaults.standard.string(forKey: "loginToken")! + "0")
    }

    
}

