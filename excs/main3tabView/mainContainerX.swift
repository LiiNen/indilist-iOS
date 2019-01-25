//
//  mainContainerX.swift
//  excs
//
//  Created by user on 2018. 11. 30..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class mainContainerX: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var title6: UILabel!
    @IBOutlet weak var title7: UILabel!
    @IBOutlet weak var title8: UILabel!
    @IBOutlet weak var title9: UILabel!
    @IBOutlet weak var artist1: UILabel!
    @IBOutlet weak var artist2: UILabel!
    @IBOutlet weak var artist3: UILabel!
    @IBOutlet weak var artist4: UILabel!
    @IBOutlet weak var artist5: UILabel!
    @IBOutlet weak var artist6: UILabel!
    @IBOutlet weak var artist7: UILabel!
    @IBOutlet weak var artist8: UILabel!
    @IBOutlet weak var artist9: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lateLoad(completion:{
            print("lateload fin")
        })
        // Do any additional setup after loading the view.
    }
    
    func lateLoad(completion: @escaping ()->()){
        let url = "https://www.indi-list.com/getlatemusic"
        let headers = [ "Content-Type" : "application/json" ]
        let para : Parameters = [ "num" : 9]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            //print(">>", response)
            if let json = response.result.value{
                let arrayTemp : NSArray = json as! NSArray
                self.title1.text = ((arrayTemp[0] as AnyObject).value(forKey: "title") as? String)!
                self.title2.text = ((arrayTemp[1] as AnyObject).value(forKey: "title") as? String)!
                self.title3.text = ((arrayTemp[2] as AnyObject).value(forKey: "title") as? String)!
                self.title4.text = ((arrayTemp[3] as AnyObject).value(forKey: "title") as? String)!
                self.title5.text = ((arrayTemp[4] as AnyObject).value(forKey: "title") as? String)!
                self.title6.text = ((arrayTemp[5] as AnyObject).value(forKey: "title") as? String)!
                self.title7.text = ((arrayTemp[6] as AnyObject).value(forKey: "title") as? String)!
                self.title8.text = ((arrayTemp[7] as AnyObject).value(forKey: "title") as? String)!
                self.title9.text = ((arrayTemp[8] as AnyObject).value(forKey: "title") as? String)!
                self.artist1.text = ((arrayTemp[0] as AnyObject).value(forKey: "artist") as? String)!
                self.artist2.text = ((arrayTemp[1] as AnyObject).value(forKey: "artist") as? String)!
                self.artist3.text = ((arrayTemp[2] as AnyObject).value(forKey: "artist") as? String)!
                self.artist4.text = ((arrayTemp[3] as AnyObject).value(forKey: "artist") as? String)!
                self.artist5.text = ((arrayTemp[4] as AnyObject).value(forKey: "artist") as? String)!
                self.artist6.text = ((arrayTemp[5] as AnyObject).value(forKey: "artist") as? String)!
                self.artist7.text = ((arrayTemp[6] as AnyObject).value(forKey: "artist") as? String)!
                self.artist8.text = ((arrayTemp[7] as AnyObject).value(forKey: "artist") as? String)!
                self.artist9.text = ((arrayTemp[8] as AnyObject).value(forKey: "artist") as? String)!
                self.image1.af_setImage(withURL: URL(string: ((arrayTemp[0] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image2.af_setImage(withURL: URL(string: ((arrayTemp[1] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image3.af_setImage(withURL: URL(string: ((arrayTemp[2] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image4.af_setImage(withURL: URL(string: ((arrayTemp[3] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image5.af_setImage(withURL: URL(string: ((arrayTemp[4] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image6.af_setImage(withURL: URL(string: ((arrayTemp[5] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image7.af_setImage(withURL: URL(string: ((arrayTemp[6] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image8.af_setImage(withURL: URL(string: ((arrayTemp[7] as AnyObject).value(forKey: "album-img") as? String)!)!)
                self.image9.af_setImage(withURL: URL(string: ((arrayTemp[8] as AnyObject).value(forKey: "album-img") as? String)!)!)
                
            }
            completion()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
