//
//  findView.swift
//  excs
//
//  Created by user on 2018. 8. 18..
//  Copyright © 2018년 user. All rights reserved.
//
import Alamofire
import UIKit

class findView: UIViewController, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var idEmailText: UITextField!
    @IBOutlet weak var pwIdText: UITextField!
    @IBOutlet weak var pwEmailText: UITextField!
    
    @IBOutlet weak var findIdBtn: UIButton!
    @IBOutlet weak var findPwBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findIdBtn.layer.cornerRadius = 5
        findPwBtn.layer.cornerRadius = 5
        idEmailText.delegate = self
        pwIdText.delegate = self
        pwEmailText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findIdBtn(_ sender: Any) {
        let para : Parameters = [ "email" : idEmailText.text! ]
        findActivity(urlStr: "FindIDbyEmail/", para: para, completion:{
            self.fill_init()
        })
    }
    @IBAction func findPwBtn(_ sender: Any) {
        let para : Parameters = [ "email" : pwEmailText.text!, "id" : pwIdText.text! ]
        findActivity(urlStr: "FindPWbyEmail/", para: para, completion: {
            self.fill_init()
        })
    }
    
    func findActivity(urlStr: String, para: Parameters, completion: @escaping ()->()){
        self.btnDisable()
        loadingAlert()
        let url = "https://www.indi-list.com/" + urlStr
        let headers    = [ "Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseString { response in
            print(response)
            let retString = (response.value ?? "")
            var mesStr = ""
            
            if(urlStr == "FindPWbyEmail/") {
                mesStr = " 아이디 혹은 "
            }
            self.dismiss(animated: true, completion: {
                switch retString{
                case "no data":
                    self.alertAc(mesAlert: "등록되지 않은" + mesStr + "이메일입니다.")
                case "true":
                    self.alertAc(mesAlert: "이메일을 확인해 주세요")
                default:
                    self.alertAc(mesAlert: "에러")
                }
            })
            self.btnAble()
            completion()
        }
    }

    func btnAble(){
        findIdBtn.isEnabled = true
        findPwBtn.isEnabled = true
    }
    
    func btnDisable(){
        findIdBtn.isEnabled = false
        findPwBtn.isEnabled = false
    }
    
    func fill_init(){
        idEmailText.text = ""
        pwEmailText.text = ""
        pwIdText.text = ""
    }
    
    func alertAc(mesAlert:String){
        let myAlert = UIAlertController(title: "처리 완료", message: mesAlert, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    
    func loadingAlert(){
        let myAlert = UIAlertController(title: "잠시만 기다려주세요", message: "서버의 응답을 기다리는 중입니다.", preferredStyle: UIAlertControllerStyle.alert);
    
        present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let height: CGFloat = 100 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        print("ddddddddddd>", bounds)
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
