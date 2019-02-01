//
//  loginView.swift
//  excs
//
//  Created by user on 2018. 8. 12..
//  Copyright © 2018년 user. All rights reserved.
//

import Alamofire
import UIKit

class loginView: UIViewController, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    let base_url = URL(string: "https://www.indi-list.com/")
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "policySuccess")
        emailText.delegate = self
        passText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indi_login(){
        
        let userEmail = emailText.text!
        let userPass = passText.text!
        
        let url = "https://www.indi-list.com/auth/login/"
        let headers    = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "id" : userEmail, "pw" : userPass]
        
        //로그인중입니다.
        let alert = UIAlertController(title: nil, message: "로그인 중입니다...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        //
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseString { response in
            print(para["id"])
            print(para["pw"])
            print(response)
            if(response.result.isSuccess){
                let retString = (response.value ?? "")
                print(">>>>>>>>>>>",retString)
                if(retString == "There is no correct User or There must be login error"){
                    print("아이디 혹은 비밀번호가 잘못되었습니다.")
                    self.dismiss(animated: false, completion: {
                        self.alertAc(mesAlert: "아이디 혹은 비밀번호가 잘못되었습니다.")
                    })
                }
                else if(retString == "not verify"){
                    print("이메일을 인증해주세요.")
                    self.dismiss(animated: false, completion: {
                        self.alertAc(mesAlert: "이메일을 인증해주세요.")
                    })
                }
                else{
                    print("this si")
                    print("why?")
                    print("로그인 성공")
                    UserDefaults.standard.setValue(true, forKey: "loginSuccess")
                    UserDefaults.standard.synchronize()
                    
                    let retStringArray = retString.components(separatedBy: "\"")
                    
                    self.loginUserInfo(userInfo: retStringArray)
                    
                    self.dismiss(animated: false, completion: {
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    })
                    
                }
            }
            else if(response.result.isFailure){
                self.dismiss(animated: false, completion: {
                    self.alertAc(mesAlert: "서버에 연결되어있지 않습니다.")
                })
                print("서버 연결 안됨")
            }
            
            print(response.result)
        }

    }
    
    func loginUserInfo(userInfo: Array<String>){
        var tempEV : Array<String> = userInfo[22].components(separatedBy: ":")
        tempEV = tempEV[1].components(separatedBy: ",")
        var tempUQ : Array<String> = userInfo[28].components(separatedBy: ":")
        tempUQ = tempUQ[1].components(separatedBy: ",")
        var tempAN : Array<String> = userInfo[30].components(separatedBy: ":")
        tempAN = tempAN[1].components(separatedBy: ",")
        UserDefaults.standard.set(String(userInfo[3]), forKey: "loginName")
        UserDefaults.standard.set(String(userInfo[7]), forKey: "loginId")
        UserDefaults.standard.set(String(userInfo[11]), forKey: "loginSignuptime")
        UserDefaults.standard.set(String(userInfo[15]), forKey: "loginPhoto")
        UserDefaults.standard.set(String(userInfo[19]), forKey: "loginEmail")
        UserDefaults.standard.set(String(tempEV[0]), forKey: "loginEmailverify")
        UserDefaults.standard.set(String(userInfo[25]), forKey: "loginIsAritist")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(String(tempUQ[0]), forKey: "loginUser_quit")
        var index = 31
        let isA = UserDefaults.standard.string(forKey: "loginIsAritist")
        if(isA == "1"){
            index = 33
            UserDefaults.standard.set(String(tempAN[0]), forKey: "loginArtistNum")
            print(tempAN[0])
        }
        UserDefaults.standard.set(String(userInfo[index]), forKey: "loginToken")
        let tempAr = Array<[String:Any?]>()
        let checker = UserDefaults.standard.value(forKey: "ownplaylist" + String(userInfo[7]))
        let ccc = UserDefaults.standard.value(forKey: "dnkdnknkk")
        if(ccc == nil){
            print("it's null!")
        }
        if(checker == nil){
            print("null to init")
            UserDefaults.standard.set(tempAr, forKey: "ownplaylist" + String(userInfo[7]))
        }
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(0, forKey: "musicplayindex" + userInfo[7])
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        indi_login()
        
    }
    
    func alertAc(mesAlert:String){
        let myAlert = UIAlertController(title: "Alert", message: mesAlert, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
