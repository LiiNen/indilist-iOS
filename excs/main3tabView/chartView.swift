//
//  chartView.swift
//  excs
//
//  Created by user on 2018. 9. 11..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class chartView: UIViewController {
    
    @IBOutlet weak var outtouchBtn: UIButton!
    @IBOutlet weak var sideContainer2: UIView!
    
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var selectionView: UIView!
    // side menu
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
     var sideMenuOpen = false
    
    @IBOutlet weak var genreCon: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCon.layer.borderWidth = 0.3
        genreCon.layer.borderColor = UIColor.gray.cgColor
        UserDefaults.standard.setValue(true, forKey: "mainView2")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        
        sideMenuOpen = false
        sideMenuConstraint.constant = self.view.bounds.size.width
        selectionView.layer.borderWidth = 0.2
        selectionView.layer.borderColor = UIColor.gray.cgColor
        
        outtouchBtn.isEnabled = false
        outtouchBtn.isHidden = true
        
     }
    @objc func menuDo2(){
        self.view.bringSubview(toFront: sideContainer2)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("menuDo2"), object: nil)
        sideMenuConstraint.constant = self.view.bounds.size.width
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("tap"), object: nil)
    }
    
    @objc func toggleSideMenu() {
        NotificationCenter.default.addObserver(self, selector: #selector(menuDo2), name: NSNotification.Name("menuDo2"), object: nil)
        
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
                self.view.sendSubview(toBack: sideContainer2)
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
    
    
    // chart
    
    var data = Data()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chartLoad(completion : @escaping ()->()){
        let url = URL(string: "https://indi-list.com/getlist")
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "" : ""]
        Alamofire.request(url!, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            //json return check in console && json to string
            
            print("start parshing chart")
            
            let swiftyJsonVar : JSON
            
            if((response.result.value) != nil) {
                swiftyJsonVar = JSON(response.result.value!)
                
                for i in 0 ..< swiftyJsonVar.count {
                    //print(swiftyJsonVar[i])
                    //print(i, ". title name: " + swiftyJsonVar[i]["title"].string! + " // artist name: " + swiftyJsonVar[i]["artist"].string! + " // music-id: " + swiftyJsonVar[i]["music-id"].string!)
                }
            }
            completion()
            
        }
        
    }
    @objc func hideTheView2(){
        self.sideContainer2.backgroundColor = UIColor.white
    }
    
    @objc func showTheView2(){
        self.sideContainer2.backgroundColor = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("HidTheView2"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ShowTheView2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTheView2),name:NSNotification.Name("HidTheView2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTheView2), name: NSNotification.Name("ShowTheView2"), object: nil)
        self.view.sendSubview(toBack: sideContainer2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.setValue("2", forKey: "mainState")
        UserDefaults.standard.synchronize()
    }
}
