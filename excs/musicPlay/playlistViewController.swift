//
//  playlistViewController.swift
//  excs
//
//  Created by user on 2018. 12. 1..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class playlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theList.count
    }
    var nowedit = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellT = playlistTable.dequeueReusableCell(withIdentifier: "playlistCell") as! playlistCell
        let tempItem = theList[indexPath.row]
        cellT.artist = tempItem["artist"] as? String
        cellT.title = tempItem["title"] as? String
        cellT.musicid = tempItem["music-id"] as? String
        cellT.imageurl = tempItem["album-img"] as? String
        cellT.like = tempItem["like"] as? Int
        cellT.gerne = tempItem["gerne"] as? String
        cellT.artistimage = tempItem["artistIMG"] as? String
        cellT.time = tempItem["upload-time"] as? String
        
        cellT.musicTitle.text = cellT.title
        cellT.musicArtist.text = cellT.artist
        cellT.albumArt.image = UIImage(named: "defaultMusicImage")
        
        cellT.albumArt.af_setImage(withURL: URL(string: cellT.imageurl
        )!)
        
        if(nowedit == 0){
            cellT.deleteBtn.isEnabled = false
            cellT.deleteBtn.isHidden = true
            cellT.infoBtn.isEnabled = true
            cellT.infoBtn.isHidden = false
            
        }
        else if(nowedit == 1){
            cellT.infoBtn.isHidden = true
            cellT.infoBtn.isEnabled = false
            cellT.deleteBtn.isEnabled = true
            cellT.deleteBtn.isHidden = false
        }
        return cellT
    }

    @IBOutlet weak var playlistTable: UITableView!
    
    var theList = Array<[String:Any?]>()
    
    @IBOutlet weak var tabView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = UserDefaults.standard.string(forKey: "loginId"){
            if(id == ""){
                dismiss(animated: true, completion: nil)
            }
            else{
                theList = UserDefaults.standard.value(forKey: "ownplaylist" + id) as! [[String : Any?]]
                self.playlistTable.reloadData()
                allBtnDis()
                tabView.isHidden = true
            }
        }
        else{
            UserDefaults.standard.setValue("", forKey: "loginId")
            UserDefaults.standard.synchronize()
            dismiss(animated: true, completion: nil)
        }
        //artist, title, music-id, album-img, like, gerne, artistIMG, upload-time
    }
    @IBAction func backBtnPush(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("errorP"), object: nil)
    }
    
    
    
    @IBOutlet weak var listPlayBtn: UIButton!
    @IBAction func listPlay(_ sender: Any) {
        let id = UserDefaults.standard.string(forKey: "loginId")!
        UserDefaults.standard.setValue(selectedRow, forKey: "musicplayindex" + id)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("musicNext"), object: nil)
        playlistTable.deselectRow(at: IndexPath.init(row: selectedRow, section: 0), animated: true)
        selectedRow = -1
        allBtnDis()
    }
    @IBOutlet weak var listUpBtn: UIButton!
    @IBAction func listUp(_ sender: Any) {
        let swapTemp = theList[selectedRow]
        theList[selectedRow] = theList[selectedRow - 1]
        theList[selectedRow - 1] = swapTemp
        let id = UserDefaults.standard.string(forKey: "loginId")!
        UserDefaults.standard.setValue(theList, forKey: "ownplaylist" + id)
        playlistTable.reloadData()
        playlistTable.selectRow(at: IndexPath.init(row: selectedRow-1, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        selectedRow = selectedRow - 1
        if(selectedRow == 0){
            listUpBtn.isEnabled = false
            listUpBtn.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBOutlet weak var listDownBtn: UIButton!
    @IBAction func listDown(_ sender: Any) {
        let swapTemp = theList[selectedRow]
        theList[selectedRow] = theList[selectedRow + 1]
        theList[selectedRow + 1] = swapTemp
        let id = UserDefaults.standard.string(forKey: "loginId")!
        UserDefaults.standard.setValue(theList, forKey: "ownplaylist" + id)
        playlistTable.reloadData()
        playlistTable.selectRow(at: IndexPath.init(row: selectedRow+1, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        selectedRow = selectedRow + 1
        if(selectedRow == theList.count - 1){
            listDownBtn.isEnabled = false
            listDownBtn.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBOutlet weak var listDeleteBtn: UIButton!
    @IBAction func listDelete(_ sender: Any) {
        theList.remove(at: selectedRow)
        let id = UserDefaults.standard.string(forKey: "loginId")!
        UserDefaults.standard.setValue(theList, forKey: "ownplaylist" + id)
        playlistTable.reloadData()
        playlistTable.deselectRow(at: IndexPath.init(row: selectedRow, section: 0), animated: true)
        selectedRow = -1
        allBtnDis()
    }

    var selectedRow = -1
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(selectedRow == indexPath.row){
            allBtnDis()
            playlistTable.deselectRow(at: indexPath, animated: true)
            selectedRow = -1
            return
        }
        else{
            selectedRow = indexPath.row
            allBtnEn()
            if(selectedRow == 0){
                listUpBtn.isEnabled = false
                listUpBtn.setTitleColor(UIColor.gray, for: .normal)
            }
            else if(selectedRow == theList.count - 1){
                listDownBtn.isEnabled = false
                listDownBtn.setTitleColor(UIColor.gray, for: .normal)
            }
            return
        }
    }
    func allBtnDis(){
        listPlayBtn.isEnabled = false
        listUpBtn.isEnabled = false
        listDownBtn.isEnabled = false
        listDeleteBtn.isEnabled = false
        listPlayBtn.setTitleColor(UIColor.gray, for: .normal)
        listUpBtn.setTitleColor(UIColor.gray, for: .normal)
        listDownBtn.setTitleColor(UIColor.gray, for: .normal)
        listDeleteBtn.setTitleColor(UIColor.gray, for: .normal)
    }
    func allBtnEn(){
        let indic = UIColor.init(red: 157/255, green: 141/255, blue: 204/255, alpha: 1)
        listPlayBtn.isEnabled = true
        listUpBtn.isEnabled = true
        listDownBtn.isEnabled = true
        listDeleteBtn.isEnabled = true
        listPlayBtn.setTitleColor(indic, for: .normal)
        listUpBtn.setTitleColor(indic, for: .normal)
        listDownBtn.setTitleColor(indic, for: .normal)
        listDeleteBtn.setTitleColor(indic, for: .normal)
    }
}
