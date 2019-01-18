//
//  artistMusicUploadView.swift
//  excs
//
//  Created by user on 2018. 10. 18..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import MediaPlayer

class artistMusicUploadView: UIViewController, MPMediaPickerControllerDelegate {

    @IBOutlet weak var musicUploadBtn: UIButton!
    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var musicSelectBtn: UIButton!
    
    var albumImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicUploadBtn.layer.cornerRadius = 5
        albumImagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("MenuOpen"), object: nil)
    }
    
    @IBAction func albumArtBtn(_ sender: Any) {
        albumImagePicker.sourceType = .photoLibrary
        albumImagePicker.allowsEditing = true
        present(albumImagePicker, animated: true, completion: nil)
    }
    @IBAction func musicSelectBtn(_ sender: Any) {
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.allowsPickingMultipleItems = false
        mediapicker1 = mediaPicker
        mediaPicker.delegate = self
        self.present(mediapicker1, animated: true, completion: nil)
    }
    let imageHeaders = ["Content-type" : "multipart/form-data"]
    let url = "https://indi-list.com/api/addmusic"
    var mediapicker1: MPMediaPickerController!
    @IBAction func musicUploadBtn(_ sender: Any) {
        let imagePara : Parameters = ["ID" : "", "NICKNAME" : "", "GENRE" : "", "TITLE" : "", "lyrics" : ""]
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        if let imageData = UIImageJPEGRepresentation(self.albumArtImage.image!, 1){
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in imagePara {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                multipartFormData.append(imageData, withName: "ART", fileName: "image.jpeg", mimeType: "image/*")
                multipartFormData.append((self.musicData as Data?)!, withName: "ART", fileName: "image.jpeg", mimeType: "image/*")
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
                            self.loginAlert(alertMessage: "잠시 후 음악이 업로드됩니다.")
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
    }
    var musicData = Data()
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismiss(animated: true, completion: nil)
        print("you picked: \(mediaItemCollection)")
        let itemq = mediaItemCollection.items[0] as? MPMediaItem ?? MPMediaItem()
        let urlq: URL? = itemq.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        exportiTunesSong(assetURL: urlq!)
        {
            (response) in
            print(response ?? "responce")
        }
        
        //self.dismiss(animated: true, completion: nil)
        
        //  If you allow picking multiple media, then mediaItemCollection.items will return array of picked media items(MPMediaItem)
    }
    
    func exportiTunesSong(assetURL: URL, completionHandler: @escaping (_ fileURL: URL?) -> ()) {
        
        let songAsset = AVURLAsset(url: assetURL, options: nil)
        
        let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetAppleM4A)
        
        exporter?.outputFileType =   AVFileType(rawValue: "com.apple.m4a-audio")
        
        exporter?.metadata = songAsset.commonMetadata
        
        let filename = AVMetadataItem.metadataItems(from: songAsset.commonMetadata, withKey: AVMetadataKey.commonKeyTitle, keySpace: AVMetadataKeySpace.common)
        var songName = "Unknown"
        
        if filename.count > 0  {
            songName = ((filename[0] as AVMetadataItem).value?.copy(with: nil) as? String)!
        }
        
        //Export mediaItem to temp directory
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(songName)
            .appendingPathExtension("mp3")
        
        exporter?.outputURL = exportURL
        do
        {
            self.musicData = try Data.init(contentsOf: exportURL)
            print("here audio data is \(self.musicData)")
        } catch {
            print(">><><<<>")
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loginAlert(alertMessage : String){
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        present(myAlert, animated: true, completion: nil)
    }

}



extension artistMusicUploadView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            albumArtImage.contentMode = .scaleAspectFit
            print("imageimage")
            albumArtImage.layer.cornerRadius = 0.5 * albumArtImage.bounds.size.width
            albumArtImage.image = image
            albumArtImage.layer.cornerRadius = 0.5 * albumArtImage.bounds.size.width
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
