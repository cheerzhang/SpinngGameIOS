//
//  DashboardViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 4/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {
    
    var ref: DatabaseReference? = nil
    var mobileno = ""
    var bkimgs = [UIImage(named: "purple"),UIImage(named: "pink"),UIImage(named: "orange")]
    var count = 0
    var viewcount = 0
    
    @IBOutlet weak var scrollv: UIScrollView!
    
    @objc func buttonClicked(_ sender: AnyObject){
        print("yes you click me,",sender.currentTitle)
        let name = sender.currentTitle as! String
        NotificationCenter.default.post(name: Notification.Name("store"), object: nil, userInfo:["name": name])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSoteInto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //get firebase
    func getSoteInto(){
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref?.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storeID = value?["storeID"] as? String ?? ""
            let StoreArr = storeID.split(separator: "|").map(String.init)
            for c in StoreArr{
                self.getStoreName(storeid: c)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getStoreName(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["name"] as? String ?? ""
            self.addbutton(storeid: storeid,storename:storen)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addbutton(storeid:String,storename:String){
        let buttonc = UIButton()
        let x = 420 * self.viewcount
        let labelc = UILabel()
        labelc.text = storename
        labelc.textColor = UIColor.white
        labelc.font = labelc.font.withSize(35)
        buttonc.frame = CGRect(x: x, y: 0, width: 400, height: 250)
        buttonc.contentMode = .scaleAspectFill
        labelc.frame = CGRect(x: x+25, y: 15, width: 400, height: 50)
        labelc.contentMode = .scaleAspectFit
        buttonc.setTitle(storeid, for: .normal)
        buttonc.titleLabel?.layer.opacity = 0
        let i = Int(arc4random())%3
        buttonc.setBackgroundImage(self.bkimgs[i], for: .normal)
        buttonc.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        self.scrollv.contentSize.width = self.scrollv.frame.size.width * CGFloat(self.viewcount + 1)
        self.scrollv.addSubview(buttonc)
        self.scrollv.addSubview(labelc)
        self.view.updateConstraints()
        self.viewcount = self.viewcount + 1
    }
    
}
