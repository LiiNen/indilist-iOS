//
//  sideMenu201.swift
//  excs
//
//  Created by user on 2018. 10. 4..
//  Copyright © 2018년 user. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit
import AlamofireImage

class sideMenu201: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var modifyBtn: UIButton!
    
    @IBAction func modifyBtn(_ sender: Any) {
        if(emailOk == 0 && nameOk == 0 && imageOk == 0){
            myAlertAction(alertMessage: "중복확인을 진행해주세요")
            return
        }
        else{
            let url = "https://www.indi-list.com/api/ModifyPersonalInfo"
            var headers = ["x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
            var para : Parameters = ["newnick" : UserDefaults.standard.string(forKey: "loginName")!, "newemail" : UserDefaults.standard.string(forKey: "loginEmail")!]
            if(emailOk == 1){
                para["newemail"] = emailText.text!
            }
            if(nameOk == 1){
                para["newnick"] = nameText.text!
            }
            Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString { response in
                let retS = response.result.value!
                print("here is the result")
                print(retS)
                if(retS == "null error" || retS == "error"){
                    self.myAlertAction(alertMessage: "error : 관리자에게 문의해주세요")
                }
                else{
                    var almes = ""
                    if(self.nameOk == 1){
                        almes = almes + "변경 완료"
                    }
                    if(self.emailOk == 1){
                        if(almes != ""){
                            almes = almes + "\n"
                        }
                        almes = almes + "주소 변경은 이메일을 확인해주세요"
                    }
                    let myAlert = UIAlertController(title: "\n다시 로그인해주세요", message: almes, preferredStyle: UIAlertControllerStyle.alert);
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    self.logoutBtn(self)
                }
            }
        }
        if(imageOk == 1){
            var imageHeaders = ["Content-type" : "multipart/form-data", "x-access-token" : UserDefaults.standard.string(forKey: "loginToken")!]
            let imagePara = ["" : ""]
            let uuurl = "https://indi-list.com/api/ChangeProfileImg"
            if let imageData = UIImageJPEGRepresentation(self.userImage.image!, 1){
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in imagePara {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    multipartFormData.append(imageData, withName: "photo", fileName: "image.jpeg", mimeType: "image/*")
                    print("???")
                }, usingThreshold: UInt64.init(), to: uuurl, method: .post, headers: imageHeaders) { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        upload.responseJSON { response in
                            let swiftyJsonVar : JSON
                            if((response.result.value) != nil) {
                                swiftyJsonVar = JSON(response.result.value!)
                                print("origin : ", swiftyJsonVar)
                                if(swiftyJsonVar["err"].exists()){
                                    if(swiftyJsonVar["result"].string! == "update"){
                                        print(swiftyJsonVar["token"].string!)
                                        print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                                        let tok = swiftyJsonVar["token"].string!
                                        imageHeaders["x-access-token"] = tok;
                                        UserDefaults.standard.setValue(tok, forKey: "loginToken")
                                        UserDefaults.standard.synchronize()
                                        self.modifyBtn.sendActions(for: .touchUpInside)
                                    }
                                    else{
                                        self.showToast(message: "다시 로그인해주세요")
                                        self.removeOb()
                                        NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                                        
                                        return;
                                    }
                                }
                                else{
                                    print(">>>", response.result, "<<<")
                                    self.myAlertAction(alertMessage: "이미지 변경 성공\n다시 로그인해주세요")
                                    self.logoutBtn(self)
                                }
                            }
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                            self.myAlertAction(alertMessage: "server error")
                    }
                }
            }
        }
    }
    
    
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loginSuccess")
        UserDefaults.standard.synchronize()
        logoutUserInfo()
        self.performSegue(withIdentifier: "gooMenu", sender: self)
        NotificationCenter.default.post(name: NSNotification.Name("logoutAV"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("KKK"), object: nil)
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
    }
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    let userId = UserDefaults.standard.string(forKey: "loginId")!
    let userName = UserDefaults.standard.string(forKey: "loginName")!
    let userEmail = UserDefaults.standard.string(forKey: "loginEmail")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("menuDo1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo2"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo3"), object: nil)
        nameOk = 0
        emailOk = 0
        imageOk = 0
        userImagePicker.delegate = self
        modifyBtn.layer.cornerRadius = 5
        userNameDupBtn.layer.cornerRadius = 3
        userEmailDupBtn.layer.cornerRadius = 3
        idText.delegate = self
        nameText.delegate = self
        emailText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
        
        
        getImage()
        getUserInfo()
    }
    func getUserInfo(){
        idText.text = userId
        idText.isEnabled = false
        nameText.placeholder = userName
        emailText.placeholder = userEmail
    }
    @IBAction func userNameChanged(_ sender: Any) {
        if(nameText.text == "" || nameText.text == userName){
            
            userNameDupBtn.isEnabled = false
        }
        else{
            if(nameOk == 1){
                nameOk = 0
            }
            userNameDupBtn.backgroundColor = UIColor(red: 157/255, green: 141/255, blue: 204/255, alpha: 1)
            userNameDupBtn.setTitle("중복확인", for: .normal)
            userNameDupBtn.isEnabled = true
        }
    }
    var nameOk = 0
    @IBOutlet weak var userNameDupBtn: UIButton!
    @IBAction func userNameDup(_ sender: Any) {
        let nameString = nameText.text!
        if(nameString == ""){
            return
        }
        let urlN = "https://www.indi-list.com/checkNick/"
        let paraN : Parameters = ["nick" : nameString]
        let headersN = ["Content-Type" : "application/json"]
        dupCheck(url: urlN, para: paraN, headers: headersN, completion: {
            let resD = self.dupchecker
            if(resD == "true"){
                self.myAlertAction(alertMessage: "변경 가능한 닉네임입니다.")
                self.nameOk = 1
                self.userNameDupBtn.backgroundColor = UIColor(red: 163/255, green: 207/255, blue: 147/255, alpha: 1)
                self.userNameDupBtn.setTitle("완료", for: .normal)
                self.userNameDupBtn.isEnabled = false
            }
            else if(resD == "false"){self.myAlertAction(alertMessage: "이미 사용중인 닉네임입니다.")}
            else{self.myAlertAction(alertMessage: "server error")}
        })
    }
    @IBAction func userEmailChanged(_ sender: Any) {
        if(emailText.text == "" || emailText.text == userEmail){
            
            userEmailDupBtn.isEnabled = false
        }
        else{
            if(emailOk == 1){
                self.emailOk = 0
            }
            userEmailDupBtn.backgroundColor = UIColor(red: 157/255, green: 141/255, blue: 204/255, alpha: 1)
            userEmailDupBtn.setTitle("중복확인", for: .normal)
            userEmailDupBtn.isEnabled = true
        }
    }
    var emailOk = 0
    @IBOutlet weak var userEmailDupBtn: UIButton!
    @IBAction func userEmailDup(_ sender: Any) {
        let emailString = emailText.text!
        if(emailString == ""){
            return
        }
        let urlE = "https://www.indi-list.com/checkEmail/"
        let paraE : Parameters = ["email" : emailString]
        let headersE = ["Content-Type" : "application/json"]
        dupCheck(url: urlE, para: paraE, headers: headersE, completion: {
            let resD = self.dupchecker
            if(resD == "true"){
                self.myAlertAction(alertMessage: "변경 가능한 이메일입니다.")
                self.emailOk = 1
                self.userEmailDupBtn.isEnabled = false
                self.userEmailDupBtn.backgroundColor = UIColor(red: 163/255, green: 207/255, blue: 147/255, alpha: 1)
                self.userEmailDupBtn.setTitle("완료", for: .normal)
            }
            else if(resD == "false"){self.myAlertAction(alertMessage: "이미 사용중인 이메일입니다.")}
            else if(resD == "not validated"){self.myAlertAction(alertMessage: "잘못된 이메일 주소입니다.")}
            else{self.myAlertAction(alertMessage: "server error")}
        })
    }
    var dupchecker = String()
    func dupCheck(url: String, para: Parameters, headers: [String : String], completion: @escaping ()->()){
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseString { response in
            let retString = response.value ?? ""
            self.dupchecker = retString
            completion()
        }
    }
    func myAlertAction(alertMessage : String){
        let myAlert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
    @IBAction func byebye(_ sender: Any) {
        
    }
    
    
    
    func getImage(){
        let imageURL = UserDefaults.standard.string(forKey: "loginPhoto")!
        Alamofire.request(imageURL).responseImage { response in
            if let imagel = response.result.value {
                self.userImage.image = imagel
                self.userImage.layer.masksToBounds = true
                self.userImage.layer.cornerRadius = 0.5 * (self.userImage.bounds.size.width)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
    }
    
    var imageOk = 0
    var userImagePicker = UIImagePickerController()
    @IBAction func imagePickBtn(_ sender: Any) {
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.allowsEditing = true
        present(userImagePicker, animated: true, completion: nil)
    }
    @objc func removeOb(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicPlay"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicNext"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("musicBefore"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("addingMusic"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AAA"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("logoutAV"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("KKK"), object: nil)
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - self.view.frame.size.width*0.3, y: self.view.frame.size.height-100, width: self.view.frame.size.width*0.6, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

extension sideMenu201: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImage.layer.masksToBounds = true
            userImage.contentMode = .scaleAspectFit
            print("imageimage")
            userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
            userImage.image = image
            imageOk = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
