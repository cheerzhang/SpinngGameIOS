//
//  BaseViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 5/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {
    
    var mobileno = ""
    var selectedStore = ""
    var selectedCampaign = ""
    var menuopen = false
    var dashboardViewController = DashboardViewController()
    var campaignViewController = CampaignViewController()
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference? = nil
    
    @IBOutlet weak var settingbtn: UIButton!
    @IBOutlet weak var topbarview: UIView!
    @IBOutlet weak var hambugerbtn: UIButton!
    @IBOutlet weak var giftbtn: UIButton!
    @IBOutlet weak var selectstorebtn: UIButton!
    @IBOutlet weak var selectcampaignbtn: UIButton!
    
    @IBOutlet weak var sidebarview: UIView!
    @IBOutlet weak var centerview: UIView!
    @IBOutlet weak var sidemenuleading: NSLayoutConstraint!
    @IBOutlet weak var centerviewleading: NSLayoutConstraint!
    @IBOutlet weak var launchview: UIView!
    
    @IBOutlet weak var luanch: UIButton!
    @IBOutlet weak var logoutbtn: UIButton!
    
    @IBAction func hambugerfunc(_ sender: Any) {
        if(self.menuopen == false){
            self.sidemenuleading.constant = 0
            self.menuopen = true
        }
        else{
            self.sidemenuleading.constant = -120
            self.menuopen = false
        }
        UIView.animate(withDuration: 0.3,delay:0.0,options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }){(animationComplete) in
            print("The animation is complete!")
        }
    }
    
    @IBAction func giftfunc(_ sender: Any) {
        super.viewDidLoad()
        self.menuopen = true
        self.sidemenuleading.constant = 0
        self.centerviewleading.constant = 0
        // load default View
        if(self.selectedStore == ""){
            self.selectstorebtn.setTitle("   Select Store", for: .normal)
            self.selectstorebtn.setTitleColor(UIColor.red, for: .normal)
            self.selectcampaignbtn.setTitleColor(UIColor.gray, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.luanch.isEnabled = false
            self.addDashboard()
        }
        else if(self.selectedCampaign == ""){
            self.getStoreNameByID(storeid:self.selectedStore)
            self.selectstorebtn.setTitleColor(UIColor.gray, for: .normal)
            self.selectcampaignbtn.setTitle("   Select Campaign", for: .normal)
            self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.luanch.isEnabled = false
            self.addCampaignPick()
        }
        else{
            self.getStoreNameByID(storeid:self.selectedStore)
            self.selectstorebtn.setTitleColor(UIColor.gray, for: .normal)
            self.getCampaignNameByID(campaignid:self.selectedCampaign)
            self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.launchview.backgroundColor = UIColor.red
            self.luanch.isEnabled = true
            self.addCampaignPick()
        }
    }
    @IBAction func pickstorefunc(_ sender: Any) {
        self.selectstorebtn.setTitleColor(UIColor.red, for: .normal)
        self.selectcampaignbtn.setTitleColor(UIColor.gray, for: .normal)
        self.addDashboard()
    }
    @IBAction func pickcampaign(_ sender: Any) {
        self.selectstorebtn.setTitleColor(UIColor.gray, for: .normal)
        self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
        self.addCampaignPick()
    }
    
    @IBAction func launchfunc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Spinning") as! ViewController
        vc.themeno = self.selectedCampaign
        vc.selectedstore = self.selectedStore
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutfunc(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.mobileno = ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomVc") as! WelcomeViewController
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuopen = false
        //self.settingbtn.isEnabled = false
        self.sidemenuleading.constant = -120
        self.centerviewleading.constant = 0
        // load default View
        if(self.selectedStore == ""){
            self.selectstorebtn.setTitle("   Select Store", for: .normal)
            self.selectstorebtn.setTitleColor(UIColor.red, for: .normal)
            self.selectcampaignbtn.setTitleColor(UIColor.gray, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.luanch.isEnabled = false
            self.addDashboard()
        }
        else if(self.selectedCampaign == ""){
            self.getStoreNameByID(storeid:self.selectedStore)
            self.selectstorebtn.setTitleColor(UIColor.gray, for: .normal)
            self.selectcampaignbtn.setTitle("   Select Campaign", for: .normal)
            self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.luanch.isEnabled = false
            self.addCampaignPick()
        }
        else{
            self.getStoreNameByID(storeid:self.selectedStore)
            self.selectstorebtn.setTitleColor(UIColor.gray, for: .normal)
            self.getCampaignNameByID(campaignid:self.selectedCampaign)
            self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
            self.launchview.backgroundColor = UIColor.lightGray
            self.launchview.backgroundColor = UIColor.red
            self.luanch.isEnabled = true
            self.addCampaignPick()
        }
        //notification center
        //Dashboard List
        NotificationCenter.default.addObserver(self, selector: #selector(setToStore(notification:)), name: Notification.Name("store"), object: nil)
        //Campaign List
        NotificationCenter.default.addObserver(self, selector: #selector(setToC(notification:)), name: Notification.Name("campaign"), object: nil)
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
    //firebase function
    func getStoreNameByID(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["name"] as? String ?? ""
            self.selectstorebtn.setTitle("    "+storen, for: .normal)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCampaignNameByID(campaignid:String){
        ref = Database.database().reference()
        ref?.child("theme").child(campaignid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            self.selectcampaignbtn.setTitle("     "+theme, for: .normal)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //customized function
    func showAlertInCorrect( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
            print(">>>> click ok.")
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //notification function
    
    //Dashboard List
    @objc func setToStore(notification: NSNotification) {
        if let name = notification.userInfo?["name"] as? String {
            print("object,",name)
            self.getStoreNameByID(storeid: name)
            self.selectedStore = name
        }
        self.selectcampaignbtn.isEnabled = true
        self.selectstorebtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.selectcampaignbtn.setTitleColor(UIColor.red, for: .normal)
        self.selectedCampaign = ""
        self.selectcampaignbtn.setTitle("     Select Campaign", for: .normal)
        self.luanch.isEnabled = false
        self.launchview.backgroundColor = UIColor.gray
        self.addCampaignPick()
    }
    //
    //Campaign List
    @objc func setToC(notification: NSNotification) {
        self.launchview.backgroundColor = UIColor.red
        if let name = notification.userInfo?["name"] as? String {
            print("object,",name)
            self.selectedCampaign = name
            self.getCampaignNameByID(campaignid:name)
        }
        self.luanch.isEnabled = true
    }
    //end notification function
    
    
    func addDashboard(){
        dashboardViewController = storyboard!.instantiateViewController(withIdentifier: "DashboardVc") as! DashboardViewController
        dashboardViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 10)
        self.addChildViewController(dashboardViewController)
        self.centerview.addSubview(dashboardViewController.view)
        dashboardViewController.didMove(toParentViewController: self)
    }
    func removeDashboard(){
        self.dashboardViewController.willMove(toParentViewController: nil)
        self.dashboardViewController.removeFromParentViewController()
        self.dashboardViewController.view.removeFromSuperview()
    }
    func addCampaignPick(){
        campaignViewController = storyboard!.instantiateViewController(withIdentifier: "CampaignVc") as! CampaignViewController
        //
        campaignViewController.selectedC = self.selectedCampaign
        campaignViewController.storeid = self.selectedStore
        campaignViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 10)
        self.addChildViewController(campaignViewController)
        self.centerview.addSubview(campaignViewController.centerview)
        campaignViewController.didMove(toParentViewController: self)
    }
    func removeCampaignPick(){
        self.campaignViewController.willMove(toParentViewController: nil)
        self.campaignViewController.removeFromParentViewController()
        self.campaignViewController.centerview.removeFromSuperview()
    }

}
