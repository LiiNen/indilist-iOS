//
//  sideMenu201_PW.swift
//  excs
//
//  Created by user on 2018. 11. 27..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class sideMenu201_PW: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pw1: UITextField!
    @IBOutlet weak var pw2: UITextField!
    @IBOutlet weak var pw3: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pw1.delegate = self
        pw2.delegate = self
        pw3.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    @IBAction func finBtn(_ sender: Any) {
        if(pw2.text != pw3.text){
            alertAc(mesAlert: "새 비밀번호가 일치하지 않습니다")
        }
        if(!patternChk(str: pw2.text!)) {
            alertAc(mesAlert: "비밀번호는 영문, 숫자만 가능합니다")
        }
        else if(strlen(pw2.text!) < 6) {
            alertAc(mesAlert: "비밀번호는 6자 이상이어야 합니다")
        }
        else if(pw3.text! == ""){
            alertAc(mesAlert: "비밀번호를 한번 더 입력해주세요.")
        }
        else{
            let url = "https://indi-list.com/api/ChangePassword"
            let para : Parameters = ["currentpw" : pw1.text!, "newpw" : pw2.text!]
            Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString { response in
                let ret = response.result.value!
                if(ret == "true"){
                    let myAlert2 = UIAlertController(title: "완료", message: "비밀번호 변경에 성공하였습니다", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction2 = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    
                    myAlert2.addAction(okAction2)
                    
                    self.present(myAlert2, animated: true, completion: nil)
                }
                else if(ret == "no data"){
                    self.alertAc(mesAlert: "현재 비밀번호를 잘못 입력하셨습니다")
                }
                else if(ret == "error"){
                    self.alertAc(mesAlert: "server error")
                }
            }
        }
    }
    func alertAc(mesAlert:String){
        let myAlert = UIAlertController(title: "오류", message: mesAlert, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    func patternChk(str: String) -> Bool {
        let patReg = "^[a-zA-Z0-9]+$"
        let patTest = NSPredicate(format:"SELF MATCHES %@", patReg)
        return patTest.evaluate(with: str)
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
