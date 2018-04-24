//
//  ManageCampaignController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 13/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class ManageCampaignController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func gobackhome(_ sender: Any) {
    }
    
    @IBOutlet weak var tableview: UITableView!
    var sections:Array<String> = []
    var storeidlist:Array<String> = []
    var clist:Array<String> = []
    var Alllist:Array<Array<String>> = []
    var currentStoreID:String = ""
    var currentCampaignID:String = ""
    var currentstoreName:String = ""
    
    var refresher: UIRefreshControl!
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference? = nil
    
    @IBOutlet weak var editCbtn: UIButton!
    @IBOutlet weak var deleteCbtn: UIButton!
    
    @IBAction func addCfunc(_ sender: Any) {
    }
    
    @IBAction func editCfunc(_ sender: Any) {
        print("edit here,",self.currentstoreName)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Mimg") as! MImgController
        vc.campaignid = self.currentCampaignID
        vc.storeid = self.currentStoreID
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteCfunc(_ sender: Any) {
        self.deleteCbtn.setTitle("Delete", for: .normal)
        self.deleteCbtn.isHidden = true
        self.deleteCbtn.isEnabled = false
        self.editCbtn.isHidden = true
        self.editCbtn.isEnabled = false
        self.updateStoreInfo1()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                self.tableview.isHidden = false
                self.getStoreID()
            }else{
                self.tableview.isHidden = true
            }
        }
        //
        tableview.delegate = self
        tableview.dataSource = self
        self.editCbtn.isHidden = true
        self.editCbtn.isEnabled = false
        self.deleteCbtn.isHidden = true
        self.deleteCbtn.isEnabled = false
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
    func getStoreID(){
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref?.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storeID = value?["storeID"] as? String ?? ""
            let StoreArr = storeID.split(separator: "|").map(String.init)
            for c in StoreArr{
                self.getCampaignID(storeid: c)
                self.getStoreName(storeid: c)
                self.storeidlist.append(String(c))
            }
            self.tableview.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getStoreName(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["name"] as? String ?? ""
            self.sections.append(storen)
            self.tableview.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCampaignID(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let campaignid = value?["campaign"] as? String ?? ""
            self.clist = []
            let CampaignArr = campaignid.split(separator: "|").map(String.init)
            for c in CampaignArr{
                self.clist.append(c)
            }
            self.Alllist.append(self.clist)
            self.tableview.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // table function tamplate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.clist = Alllist[section]
        return clist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MStoreCell", for: indexPath) as UITableViewCell
        self.clist = Alllist[indexPath.section]
        cell.textLabel?.text = clist[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)//
        let row = indexPath.row
        self.clist = Alllist[indexPath.section]
        //mytheme = String(clist[row])
        print("mytheme,",String(clist[row]))
        self.editCbtn.setTitle("Edit Campaign "+String(clist[row]), for: .normal)
        self.editCbtn.isHidden = false
        self.editCbtn.isEnabled = true
        self.currentstoreName = String(self.sections[indexPath.section])
        self.deleteCbtn.setTitle("Delete Campaign "+String(clist[row]+" From  "+String(self.sections[indexPath.section])), for: .normal)
        self.deleteCbtn.isHidden = false
        self.deleteCbtn.isEnabled = true
        self.currentStoreID = String(self.storeidlist[indexPath.section])
        self.currentCampaignID = String(clist[row])
    }
    
    
    //update Camapign if of Store
    func updateStoreInfo1(){
        ref = Database.database().reference()
        ref?.child("Store").child(self.currentStoreID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["campaign"] as? String ?? ""
            print(">>>> new oid,",storen)
            var newoid = storen.replacingOccurrences(of: self.currentCampaignID, with: "")
            newoid = newoid.replacingOccurrences(of: "||", with: "|")
            self.updateStoreInfo2(allc:newoid)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func updateStoreInfo2(allc:String){
        ref = Database.database().reference()
        let childRef = ref?.child("Store").child(self.currentStoreID)
        let addingItem = [
            "campaign" : allc
            ] as [String : Any]
        childRef?.updateChildValues(addingItem, withCompletionBlock: { (errorAdding, ref) in
        })
        self.tableview.reloadData()
        self.viewDidLoad()
    }
    
}
