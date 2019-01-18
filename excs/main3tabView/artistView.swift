//
//  artistView.swift
//  excs
//
//  Created by user on 2018. 9. 17..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class artistView: UIViewController {
    @IBOutlet weak var outtouchBtn: UIButton!
    @IBOutlet weak var sideContainer3: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var wowcon: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenuOpen = false
        sideMenuConstraint.constant = self.view.bounds.size.width
        //bottomConstraint.constant = 562
        wowcon.layer.borderWidth = 0.3
        wowcon.layer.borderColor = UIColor.gray.cgColor
        
        UserDefaults.standard.setValue(true, forKey: "mainView3")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.synchronize()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        
        outtouchBtn.isEnabled = false
        outtouchBtn.isHidden = true
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("tap"), object: nil)
    }
    
    @objc func toggleSideMenu() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuDo3), name: NSNotification.Name("menuDo3"), object: nil)
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = self.view.bounds.size.width
            outtouchBtn.isEnabled = false
            outtouchBtn.isHidden = true
        } else {
            let isslogin = UserDefaults.standard.bool(forKey: "loginSuccess")
            if(!isslogin){
                NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                return
            }
            else{
                sideMenuOpen = true
                sideMenuConstraint.constant = self.view.bounds.size.width-316
                self.view.sendSubview(toBack: sideContainer3)
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
    
    
    @objc func menuDo3(){
        self.view.bringSubview(toFront: sideContainer3)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("menuDo3"), object: nil)
        sideMenuConstraint.constant = self.view.bounds.size.width
    }
    
    @objc func hideTheView3(){
        self.sideContainer3.backgroundColor = UIColor.white
    }
    
    @objc func showTheView3(){
        self.sideContainer3.backgroundColor = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
            self.view.sendSubview(toBack: sideContainer3)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("HidTheView3"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ShowTheView3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTheView3),name:NSNotification.Name("HidTheView3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTheView3), name: NSNotification.Name("ShowTheView3"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.setValue("3", forKey: "mainState")
        UserDefaults.standard.synchronize()
    }
}
