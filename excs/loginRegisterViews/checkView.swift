//
//  checkView.swift
//  excs
//
//  Created by user on 2018. 8. 11..
//  Copyright © 2018년 user. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

class checkView: UIViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var texteditconst: NSLayoutConstraint!
    @IBAction func editbegin(_ sender: Any) {
        texteditconst.constant = 220
        print("begin")
    }
    @IBAction func editbegin2(_ sender: Any) {
        texteditconst.constant = 220
    }
    @IBAction func editend(_ sender: Any) {
        texteditconst.constant = 74
        print("end")
    }
    @IBAction func editend2(_ sender: Any) {
        texteditconst.constant = 74
    }
    
    
    
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var pwChkText: UITextField!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!

    @IBOutlet weak var pwWarnLabel: UILabel!
    
    @IBOutlet weak var dupliIdBtn: UIButton!
    @IBOutlet weak var dupliNameBtn: UIButton!
    @IBOutlet weak var dupliEmailBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var idChk = false
    var nameChk = false
    var emailChk = false
    var pwChk = false
    
    let headers    = [ "Content-Type" : "application/json"]
    
    var userImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("", forKey: "non_dupId")
        UserDefaults.standard.setValue("", forKey: "non_dupName")
        UserDefaults.standard.setValue("", forKey: "non_dupEmail")
        UserDefaults.standard.setValue("", forKeyPath: "emailError")
        UserDefaults.standard.synchronize()
        userImagePicker.delegate = self
        
        dupliIdBtn.layer.cornerRadius = 3
        dupliNameBtn.layer.cornerRadius = 3
        dupliEmailBtn.layer.cornerRadius = 3
        registerBtn.layer.cornerRadius = 5
        
        idText.delegate = self
        pwText.delegate = self
        pwChkText.delegate = self
        nameText.delegate = self
        emailText.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePwText(_ sender: Any) {
        let pwStr = pwText.text!
        let pwChkStr = pwChkText.text!
        pwChk = false
        if(!patternChk(str: pwStr)) {
            pwWarnLabel.text = "비밀번호는 영문, 숫자만 가능합니다."
        }
        else if(strlen(pwStr) < 6) {
            pwWarnLabel.text = "비밀번호는 6자 이상이어야 합니다."
        }
        else if(pwChkStr == ""){
            pwWarnLabel.text = "비밀번호를 한번 더 입력해주세요."
        }
        else if(pwStr != pwChkStr) {
            pwWarnLabel.text = "비밀번호가 일치하지 않습니다."
        }
        else{
            pwChk = true
            pwWarnLabel.text = ""
        }
    }
    
    @IBAction func changePwChkText(_ sender: Any) {
        let pwStr = pwText.text!
        let pwChkStr = pwChkText.text!
        if(pwStr != pwChkStr) {
            pwWarnLabel.text = "비밀번호가 일치하지 않습니다."
            pwChk = false
        }
        else{
            pwWarnLabel.text = ""
            pwChk = true
        }
    }
    
    
    //duplicated checking
    @IBAction func changeIdText(_ sender: Any) {
        if(idChk == true){
            self.dupliIdBtn.isEnabled = true
            self.idChk = false
            UserDefaults.standard.setValue("", forKeyPath: "non_dupId")
            UserDefaults.standard.synchronize()
        }
    }
    @IBAction func dupliIdBtn(_ sender: Any) {
        let idStr = idText.text!
        
        //base check
        if(strlen(idStr)<6){
            self.loginAlert(alertMessage: "아이디는 6자 이상이어야 합니다.")
            return
        }
        else if(!patternChk(str: idStr)){
            self.loginAlert(alertMessage: "영문 또는 숫자만 가능합니다.")
            return
        }
        
        let keyStr = "non_dupId"
        dupliChk(str: idStr, post: "checkId/", paraIndex: "id", key_value: keyStr, completion: {
            if(UserDefaults.standard.string(forKey: keyStr) == ""){
                self.loginAlert(alertMessage: "중복된 아이디가 있습니다.")
                print("중복")
            }
            else{
                self.loginAlert(alertMessage: "사용가능한 아이디입니다.")
                print("중복아님")
                self.dupliIdBtn.isEnabled = false
                self.idChk = true
            }
        })
    }
    
    @IBAction func changeNameText(_ sender: Any) {
        if(nameChk == true){
            self.dupliNameBtn.isEnabled = true
            self.nameChk = false
            UserDefaults.standard.setValue("", forKeyPath: "non_dupNick")
            UserDefaults.standard.synchronize()
        }
    }

    @IBAction func dupliNameBtn(_ sender: Any) {
        let nameStr = nameText.text!
        //duplicate check
        let keyStr = "non_dupNick"
        dupliChk(str: nameStr, post: "checkNick/", paraIndex: "nick", key_value: keyStr, completion: {
            if(UserDefaults.standard.string(forKey: keyStr) == ""){
                self.loginAlert(alertMessage: "중복된 닉네임이 있습니다.")
            }
            else{
                self.loginAlert(alertMessage: "사용가능한 닉네임입니다.")
                self.dupliNameBtn.isEnabled = false
                self.nameChk = true
            }
        })
    }
    
    @IBAction func changeEmailText(_ sender: Any) {
        if(emailChk == true){
            self.dupliEmailBtn.isEnabled = true
            self.emailChk = false
            UserDefaults.standard.setValue("", forKeyPath: "non_dupEmail")
            UserDefaults.standard.setValue("", forKeyPath: "emailError")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func dupliEmailBtn(_ sender: Any) {
        let emailStr = emailText.text!
        
        //duplicate check
        let keyStr = "non_dupEmail"
        dupliChk(str: emailStr, post: "checkEmail/", paraIndex: "email", key_value: keyStr, completion: {
            let emailErrorCode = UserDefaults.standard.string(forKey: "emailError")
            if(emailErrorCode != ""){
                switch emailErrorCode{
                case "not validated":
                    self.loginAlert(alertMessage: "올바른 형식이 아닙니다.")
                case "error":
                    self.loginAlert(alertMessage: "오류")
                default:
                    self.loginAlert(alertMessage: "오류")
                }
                UserDefaults.standard.setValue("", forKey: "emailError")
                UserDefaults.standard.synchronize()
            }
            else if(UserDefaults.standard.string(forKey: keyStr) == ""){
                self.loginAlert(alertMessage: "이미 있는 이메일입니다.")
            }
            else{
                self.loginAlert(alertMessage: "사용가능한 이메일입니다.")
                self.dupliEmailBtn.isEnabled = false
                self.emailChk = true
            }
        })
    }
    
    func dupliChk(str: String, post: String, paraIndex: String, key_value: String, completion: @escaping ()->()){
        
        let url = "https://www.indi-list.com/" + post
        let para : Parameters = [ paraIndex : str]
    
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseString { response in
            //json return check in console && json to string
            print(response)
            let retString = (response.value ?? "")
            
            if(retString == "true"){
                UserDefaults.standard.setValue(str, forKey: key_value)
                print("없음")
            }
            else if(retString == "false"){
                UserDefaults.standard.setValue("", forKey: key_value)
                print("이미 있음")
            }
            else if(retString == "not validated"){
                UserDefaults.standard.setValue("not validated", forKeyPath: "emailError")
                print("올바른형식이아님")
            }
            else if(retString == "error"){
                UserDefaults.standard.setValue("error", forKeyPath: "emailError")
                print("오류")
            }
            else{
                print("error why?")
            }
            UserDefaults.standard.synchronize()
            completion()
        }
        return
    }
    
    func patternChk(str: String) -> Bool {
        let patReg = "^[a-zA-Z0-9]+$"
        let patTest = NSPredicate(format:"SELF MATCHES %@", patReg)
        return patTest.evaluate(with: str)
    }
    
    
    //final check
    @IBAction func registerBtn(_ sender: Any) {
        let url = "https://www.indi-list.com/auth/signup/"
        
        let para : Parameters = ["id": idText.text!, "pw": pwText.text!, "email": emailText.text!, "name": nameText.text!]
        //check all things to fill
        if(idChk && nameChk && emailChk && pwChk){
            print("all checked")
            
            let imageHeaders = ["Content-type" : "multipart/form-data"]
            if let imageData = UIImageJPEGRepresentation(self.userImage.image!, 1){
                
                let imagePara = para
                
                //loading overlay
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                loadingIndicator.startAnimating();
                
                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
                //
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in imagePara {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    multipartFormData.append(imageData, withName: "photo", fileName: "image.jpeg", mimeType: "image/*")
                    print("???")
                }, usingThreshold: UInt64.init(), to: url, method: .post, headers: imageHeaders) { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        upload.responseJSON { response in
                            print(">>>", response.result, "<<<")
                            self.dismiss(animated: false, completion: {
                                self.loginAlert(alertMessage: "이메일 인증 완료 후 회원가입이 완료됩니다.")
                            })
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: false, completion: {
                            self.loginAlert(alertMessage: "server error")
                        })
                    }
                }
            }
            else{
                self.loginAlert(alertMessage: "image error")
            }
        }
        else {
            self.loginAlert(alertMessage: "모든 확인을 마쳐주세요.")
        }
        return
    }
    
    //alert
    func loginAlert(alertMessage : String){
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    
    func fill_init(){
        id_init()
        pw_init()
    }
    func id_init(){
        idText.text! = ""
    }
    func pw_init(){
        pwText.text! = ""
        pwChkText.text! = ""
    }
    
    //image load
    @IBAction func imagePickBtn(_ sender: Any) {
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.allowsEditing = true
        present(userImagePicker, animated: true, completion: nil)
    }
}

//image extension
extension checkView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImage.layer.masksToBounds = true
            userImage.contentMode = .scaleAspectFit
            print("imageimage")
            userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
            userImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
