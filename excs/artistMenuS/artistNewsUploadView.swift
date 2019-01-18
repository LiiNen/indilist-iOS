//
//  artistNewsUploadView.swift
//  excs
//
//  Created by user on 2018. 10. 18..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class artistNewsUploadView: UIViewController {

    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var newsImage : UIImageView!
    @IBOutlet weak var imageUploadBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var outlineView: UIView!
    
    var newsImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTextView.layer.borderWidth = 0.5
        newsTextView.layer.borderColor = UIColor.gray.cgColor
        outlineView.layer.borderWidth = 0.5
        outlineView.layer.borderColor = UIColor.gray.cgColor
        imageUploadBtn.layer.cornerRadius = 5
        uploadBtn.layer.cornerRadius = 5
        newsImagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageUploadBtn(_ sender: Any){
        newsImagePicker.sourceType = .photoLibrary
        newsImagePicker.allowsEditing = true
        present(newsImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtn(_ sender: Any){
        var theaders = ["x-access-token" : "", "Content-type" : "multipart/form-data"]
        theaders["x-access-token"] = UserDefaults.standard.string(forKey: "loginToken")
        let url = "https://indi-list.com/api/AddArtistNews"
        let userId = UserDefaults.standard.string(forKey: "loginId")!
        let contentText = newsTextView.text!
        let para : Parameters = ["id": userId, "content": contentText]
    
        if let imageData = UIImageJPEGRepresentation(self.newsImage.image!, 1){
            
            let imagePara = para
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in imagePara {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                multipartFormData.append(imageData, withName: "IMG", fileName: "image.jpeg", mimeType: "image/*")
                print("???")
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: theaders) { (result) in
                print(">>>>>>>>>>>>>>>>>>>", result, "<<<<<<<<<<")
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        print(">>>", response.result, "<<<")
                        let swiftyJsonVar : JSON
                        swiftyJsonVar = JSON(response.result.value!)
                        if(swiftyJsonVar["err"].exists()){
                            if(swiftyJsonVar["result"].string! == "update"){
                                print(swiftyJsonVar["token"].string!)
                                print("토큰이 교체됩니다. 이하의 토큰으로 진행해주세요.")
                                let tok = swiftyJsonVar["token"].string!
                                theaders["x-access-token"] = tok;
                                UserDefaults.standard.setValue(tok, forKey: "loginToken")
                                UserDefaults.standard.synchronize()
                                self.uploadBtn.sendActions(for: .touchUpInside)
                            }
                            else{
                                self.showToast(message: "다시 로그인해주세요")
                                self.removeOb()
                                NotificationCenter.default.post(name: NSNotification.Name("logOutAction"), object: nil)
                                
                                return;
                            }
                        }
                        else{
                            self.dismiss(animated: false, completion: {
                                self.newsAlert(alertMessage: "소식 업로드에 성공했습니다.")
                            })
                        }

                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.dismiss(animated: false, completion: {
                        self.newsAlert(alertMessage: "server error")
                    })
                }
            }
        }
        else{
            self.newsAlert(alertMessage: "image error")
        }
        
    }
    func newsAlert(alertMessage : String){
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
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



extension artistNewsUploadView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            newsImage.contentMode = .scaleAspectFit
            print("imageimage")
            newsImage.layer.cornerRadius = 0.5 * newsImage.bounds.size.width
            newsImage.image = image
            newsImage.layer.cornerRadius = 0.5 * newsImage.bounds.size.width
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
