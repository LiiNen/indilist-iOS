//
//  gerneScrollViewController.swift
//  excs
//
//  Created by user on 2018. 12. 3..
//  Copyright © 2018년 user. All rights reserved.
//

import UIKit

class gerneScrollViewController: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn13: UIButton!
    @IBOutlet weak var btn14: UIButton!
    @IBOutlet weak var btn15: UIButton!
    
    @IBAction func btn1t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn1)
        UserDefaults.standard.setValue("인기차트", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
        
    }
    @IBAction func btn2t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn2)
        UserDefaults.standard.setValue("최신차트", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn3t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn3)
        UserDefaults.standard.setValue("Ballad", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
        
    }
    @IBAction func btn4t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn4)
        UserDefaults.standard.setValue("Dance", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn5t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn5)
        UserDefaults.standard.setValue("EDM", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn6t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn6)
        UserDefaults.standard.setValue("Hip-hop", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn7t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn7)
        UserDefaults.standard.setValue("R&B", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn8t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn8)
        UserDefaults.standard.setValue("POP", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn9t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn9)
        UserDefaults.standard.setValue("New Age", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn10t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn10)
        UserDefaults.standard.setValue("Jazz", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn11t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn11)
        UserDefaults.standard.setValue("Rock", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn12t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn12)
        UserDefaults.standard.setValue("Fork", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn13t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn13)
        UserDefaults.standard.setValue("JPOP", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn14t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn14)
        UserDefaults.standard.setValue("CCM", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    @IBAction func btn15t(_ sender: Any) {
        btnNonSelect()
        btnBack(btn: btn15)
        UserDefaults.standard.setValue("기타", forKey: "chartgenres")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("chartChange"), object: nil)
    }
    
    func backgroundColor() -> UIColor{
        return UIColor(
            red: CGFloat((UInt(0xE3E1F7) & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((UInt(0xE3E1F7) & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(UInt(0xE3E1F7) & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func btnBack(btn : UIButton){
        btn.setImage(nil, for: .normal)
        btn.backgroundColor = backgroundColor()
    }
    func btnNonSelect(){
        btn1.setImage(UIImage(named: "popularchart"), for: .normal)
        btn2.setImage(UIImage(named: "newchart"), for: .normal)
        btn3.setImage(UIImage(named: "ballad"), for: .normal)
        btn4.setImage(UIImage(named: "dance"), for: .normal)
        btn5.setImage(UIImage(named: "edm"), for: .normal)
        btn6.setImage(UIImage(named: "hiphop"), for: .normal)
        btn7.setImage(UIImage(named: "rnb"), for: .normal)
        btn8.setImage(UIImage(named: "pop"), for: .normal)
        btn9.setImage(UIImage(named: "newage"), for: .normal)
        btn10.setImage(UIImage(named: "jazz"), for: .normal)
        btn11.setImage(UIImage(named: "rock"), for: .normal)
        btn12.setImage(UIImage(named: "fork"), for: .normal)
        btn13.setImage(UIImage(named: "jpop"), for: .normal)
        btn14.setImage(UIImage(named: "ccm"), for: .normal)
        btn15.setImage(UIImage(named: "etc"), for: .normal)
        btn1.backgroundColor = nil
        btn2.backgroundColor = nil
        btn3.backgroundColor = nil
        btn4.backgroundColor = nil
        btn5.backgroundColor = nil
        btn6.backgroundColor = nil
        btn7.backgroundColor = nil
        btn8.backgroundColor = nil
        btn9.backgroundColor = nil
        btn10.backgroundColor = nil
        btn11.backgroundColor = nil
        btn12.backgroundColor = nil
        btn13.backgroundColor = nil
        btn14.backgroundColor = nil
        btn15.backgroundColor = nil
    }
    
    func btnRound(){
        btn1.layer.cornerRadius = btn1.layer.bounds.size.width / 2
        btn2.layer.cornerRadius = btn2.layer.bounds.size.width / 2
        btn3.layer.cornerRadius = btn3.layer.bounds.size.width / 2
        btn4.layer.cornerRadius = btn4.layer.bounds.size.width / 2
        btn5.layer.cornerRadius = btn5.layer.bounds.size.width / 2
        btn6.layer.cornerRadius = btn6.layer.bounds.size.width / 2
        btn7.layer.cornerRadius = btn7.layer.bounds.size.width / 2
        btn8.layer.cornerRadius = btn8.layer.bounds.size.width / 2
        btn9.layer.cornerRadius = btn9.layer.bounds.size.width / 2
        btn10.layer.cornerRadius = btn10.layer.bounds.size.width / 2
        btn11.layer.cornerRadius = btn11.layer.bounds.size.width / 2
        btn12.layer.cornerRadius = btn12.layer.bounds.size.width / 2
        btn13.layer.cornerRadius = btn13.layer.bounds.size.width / 2
        btn14.layer.cornerRadius = btn14.layer.bounds.size.width / 2
        btn15.layer.cornerRadius = btn15.layer.bounds.size.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRound()
        btnNonSelect()
        btn1t(self)
        // Do any additional setup after loading the view.
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
