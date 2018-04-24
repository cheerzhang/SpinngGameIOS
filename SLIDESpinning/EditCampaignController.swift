//
//  EditCampaignController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 13/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase


class EditCampaignController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference? = nil
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var campaignnametx: UITextField!
    
    @IBAction func uploadimgfunc(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        //let mountainsRef = storageRef.child("Cbg.jpg")
        let riversRef = storageRef.child(self.campaignnametx.text! + "/GifBg.gif")
        
        var data = Data()
        data = UIImageJPEGRepresentation(self.bgimg.image!, 0.8)!
        //let data = UIImage(data: self.bgimg.image)//Data()
        let data2 = StorageMetadata()//(self.bgimg.image!)
        data2.contentType = "image/jpg"
        let uploadTask = riversRef.putData(data, metadata: data2) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
            }
        print("current file is ,",self.bgimg)
    }
    
    
    @IBOutlet weak var createbtn: UIButton!
    @IBOutlet weak var selectedStore: UILabel!
    var pickStoreData: [String] = [String]()
    var storeidArray:Array<String> = []
    var storeidNo:String = ""
    @IBOutlet weak var bgimg: UIImageView!
    let bgPicker = UIImagePickerController()
    
    @IBOutlet weak var downloadimg: UIImageView!
    @IBAction func bgimgfunc(_ sender: Any) {
        bgPicker.allowsEditing = false
        bgPicker.sourceType = .photoLibrary
        present(bgPicker, animated: true, completion: nil)
    }
    
    @IBAction func gobacktopro(_ sender: Any) {
    }
    
    @IBOutlet weak var storepicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.storepicker.delegate = self
        self.storepicker.dataSource = self
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                self.getStoreID()
            }else{
                
            }
        }
        //self.pickStoreData = ["Store1","Store2","Store3"]
        //self.selectedStore.text = ""
        bgPicker.delegate = self
    }

    @IBAction func createCfunc(_ sender: Any) {
        self.campaignnametx.isEnabled = false
        self.createbtn.isEnabled = false
        self.storepicker.isHidden = true
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let childRef = ref?.child("theme").childByAutoId()
        let addingItem = [
            "folderName" : self.campaignnametx.text!,
            "createBy" : user?.phoneNumber!
            ] as [String : Any]
        childRef?.setValue(addingItem, withCompletionBlock: { (errorAdding, ref) in
        })
        print("print succeed.",self.storeidNo)
        self.addCIDtoStore()
    }
    
    @IBAction func pickbgimg(_ sender: Any) {
        
        
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
                self.getStoreName(storeid: c)
                self.storeidArray.append(c)
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
            self.pickStoreData.append(storen)
            self.storepicker.reloadAllComponents()
            self.selectedStore.text = self.pickStoreData[0]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addCIDtoStore(){
        ref = Database.database().reference()
        ref?.child("theme").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let oID = child.key as String
                    self.ref?.child("theme").child(oID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let storen = value?["folderName"] as? String ?? ""
                        print(">>>>>>> storen,",storen)
                        if (storen == self.campaignnametx.text!){
                            self.updateStoreInfo1(oid:oID)
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }
            //let value = snapshot.value as? NSDictionary
            //let storen = value?["name"] as? String ?? ""
            //self.pickStoreData.append(storen)
            //self.storepicker.reloadAllComponents()
            //self.selectedStore.text = self.pickStoreData[0]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateStoreInfo1(oid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(self.storeidNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["campaign"] as? String ?? ""
            if (storen == ""){
                self.updateStoreInfo2(allc:oid)
            }else{
                var newoid = storen+"|"+oid
                print(">>>> see ||",newoid)
                newoid = newoid.replacingOccurrences(of: "||", with: "|")
                self.updateStoreInfo2(allc:newoid)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
            
    }
    
    func updateStoreInfo2(allc:String){
        ref = Database.database().reference()
        let childRef = ref?.child("Store").child(self.storeidNo)
        let addingItem = [
            "campaign" : allc
            ] as [String : Any]
        childRef?.updateChildValues(addingItem, withCompletionBlock: { (errorAdding, ref) in
        })
    }
    
    //select
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickStoreData.count
    }
    
    func numberOfComponentsInPickView(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickStoreData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedStore.text = pickStoreData[row]
        self.storeidNo = self.storeidArray[row]
    }
    
    //Img pick controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            bgimg.contentMode = .scaleAspectFit
            bgimg.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
