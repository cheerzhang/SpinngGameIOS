//
//  CampaignViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 5/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class CampaignViewController: UIViewController {

    var storeid = ""
    var selectedC = ""
    var viewcount = 0
    var ref: DatabaseReference? = nil
        
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet var centerview: UIView!
    @IBOutlet weak var selectedbtn: UIButton!
    
    @objc func buttonClicked(_ sender: AnyObject){
        print("yes you click me,",sender.currentTitle)
        let name = sender.currentTitle as! String
        NotificationCenter.default.post(name: Notification.Name("campaign"), object: nil, userInfo:["name": name])
        self.setSelectedImg(campaignid: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.storeid != ""){
            getCampaignID()
        }
        if (self.selectedC != ""){
            self.setSelectedImg(campaignid:self.selectedC)
        }
        
        // Do any additional setup after loading the view.
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
    func getCampaignID(){
        ref = Database.database().reference()
        ref?.child("Store").child(self.storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let campaignid = value?["campaign"] as? String ?? ""
            let CampaignArr = campaignid.split(separator: "|").map(String.init)
            for c in CampaignArr{
                self.getThemeFolder(themeno:c)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getThemeFolder(themeno:String){
        ref = Database.database().reference()
        ref?.child("theme").child(themeno).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            self.getImgFromFireBase(themename: theme,filename: "spinicon.png",themeid:themeno)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getImgFromFireBase(themename:String,filename:String,themeid:String){
        //download img from firebase
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = themename+"/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
            } else {
                let buttonc = UIButton()
                let x = 420 * self.viewcount
                buttonc.frame = CGRect(x: x, y: 0, width: 400, height: 250)
                buttonc.contentMode = .scaleAspectFill
                buttonc.setTitle(themeid, for: .normal)
                buttonc.titleLabel?.layer.opacity = 0
                buttonc.setBackgroundImage(UIImage(data: data!), for: .normal)
                buttonc.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
                self.scrollv.contentSize.width = self.scrollv.frame.size.width * CGFloat(self.viewcount + 1)
                self.scrollv.addSubview(buttonc)
                self.view.updateConstraints()
                self.viewcount = self.viewcount + 1
            }
        }
    }
    
    func setSelectedImg(campaignid:String){
        ref = Database.database().reference()
        ref?.child("theme").child(campaignid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            self.getSelectedImgFromFireBase(themename: theme,filename: "spinicon.png",themeid: campaignid)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getSelectedImgFromFireBase(themename:String,filename:String,themeid:String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = themename+"/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
            } else {
                self.selectedbtn.setBackgroundImage(UIImage(data: data!), for: .normal)
            }
        }
    }

}
