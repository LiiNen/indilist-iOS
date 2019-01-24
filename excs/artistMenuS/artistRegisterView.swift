//
//  artistRegisterView.swift
//  excs
//
//  Created by user on 2018. 10. 18..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire

class artistRegisterView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.genreText = pickerData[row]
        return pickerData[row]
    }
    @IBAction func pickerEnd(_ sender: Any) {
        self.gernePicker.endEditing(true)
        gernePickerHead.isHidden = true
        gernePicker.isHidden = true
    }
    

    var introText : String!
    var genreText : String!
    var pickerData: [String] = [String]()
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var gernePicker: UIPickerView!
    @IBOutlet weak var gernePickerHead: UIView!
    @IBOutlet weak var pickerEnd: UIButton!
    @IBOutlet weak var gernePickBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introTextView.layer.borderWidth = 0.5
        introTextView.layer.borderColor = UIColor.white.cgColor
        pickerEnd.layer.borderWidth = 1
        pickerEnd.layer.borderColor = UIColor.black.cgColor
        pickerEnd.layer.cornerRadius = 5
        gernePickerHead.isHidden = true
        gernePicker.isHidden = true
        
        gernePickBtn.layer.cornerRadius = 5
        registerBtn.layer.cornerRadius = 5
        
        self.gernePicker.delegate = self
        self.gernePicker.dataSource = self
        pickerData = ["Ballad", "Dance", "EDM", "Hip-hop", "R&B", "POP", "New Age", "Jazz", "Rock", "Fork", "JPOP", "CCM", "기타"]
        NotificationCenter.default.post(name: NSNotification.Name("menuDo1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo2"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("menuDo3"), object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func gernePickBtn(_ sender: Any) {
        self.gernePickerHead.isHidden = false
        self.gernePicker.isHidden = false
    }
    @IBAction func registerBtn(_ sender: Any){
        introTextIn(completion:{
            self.genreTextIn(completion: {
                print(self.genreText, self.introText)
                //self.registerAction()
            })
        })
    }
    
    func introTextIn(completion: @escaping ()->()){
        introText = introTextView.text
        completion()
    }
    func genreTextIn(completion: @escaping ()->()){
        
        completion()
    }
    
    func registerAction(){
        let url = "https://www.indi-list.com/api/registerArtist"
        let headers    = [ "x-access-token" : UserDefaults.standard.string(forKey: "loginToken")! ]
        let para : Parameters = [ "intro" : introText!, "genre" : genreText!]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseString { response in
            let letstring = response.value ?? ""
            print(letstring)
            switch(letstring){
            case "true":
                self.alertAc(mesAlert: "아티스트 등록이 완료되었습니다", titleName: "Success")
                break
            case "null error":
                self.alertAc(mesAlert: "서버 에러", titleName: "Alert")
                break
            case "error":
                self.alertAc(mesAlert: "서버 에러", titleName: "Alert")
                break
            case "Already artist error":
                self.alertAc(mesAlert: "이미 아티스트로 등록되어 있습니다.", titleName: "Alert")
                break
            default:
                self.alertAc(mesAlert: "확인되지 않은 에러입니다.", titleName: "Alert")
            }
        }
    }
    
    func alertAc(mesAlert:String, titleName:String){
        let myAlert = UIAlertController(title: titleName, message: mesAlert, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuClose"), object: nil)
        
        let temp = UserDefaults.standard.string(forKey: "mainState")
        let str = "ShowTheView" + temp!
        NotificationCenter.default.post(name: NSNotification.Name(str), object: nil)
        print("생기다")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
}
