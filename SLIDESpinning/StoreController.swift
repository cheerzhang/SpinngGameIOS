//
//  StoreController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 12/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class StoreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func gobackfunc(_ sender: Any) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections:Array<String> = []
    var clist:Array<String> = []
    var Alllist:Array<Array<String>> = []
    var mytheme:String = ""
    
    var refresher: UIRefreshControl!
    var handle: AuthStateDidChangeListenerHandle?
    
    var ref: DatabaseReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                self.tableView.isHidden = false
                self.getStoreID()
            }else{
                self.tableView.isHidden = true
            }
        }
        //
        tableView.delegate = self
        tableView.dataSource = self
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
            }
            self.tableView.reloadData()
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
            self.tableView.reloadData()
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
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // table function tamplate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        switch section {
        case 0:
            // Fruit Section
            return nlist[0]
                //clist.count
        case 1:
            // Vegetable Section
            return clist.count
        default:
            return 0
        }*/
        //return nlist[section]
        self.clist = Alllist[section]
        return clist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as UITableViewCell
        //cell.textLabel?.text = clist[indexPath.row]
        /*
        switch indexPath.section {
        case 0:
            // Fruit Section
            self.clist = Alllist[0]
            print(">>>>> current clist is",indexPath.section )
            cell.textLabel?.text = clist[indexPath.row]
            break
        case 1:
            // Vegetable Section
            self.clist = Alllist[1]
            print(">>>>> current clist is",indexPath.section )
            cell.textLabel?.text = clist[indexPath.row]
            break
        case 2:
            // Vegetable Section
            self.clist = Alllist[2]
            print(">>>>> current clist is",indexPath.section )
            cell.textLabel?.text = clist[indexPath.row]
            break
        default:
            break
        }*/
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
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let row = indexPath.row
        self.clist = Alllist[indexPath.section]
        mytheme = String(clist[row])
        print("mytheme,",self.mytheme)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Spinning") as! ViewController
        vc.themeno = self.mytheme
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        //performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segue") {
            // Setup new view controller
            if let destinationViewController = segue.destination as? ViewController {
                //destinationViewController.themeno = self.mytheme
            }
        }
        
    }
    
    //function for spinning


}
