//
//  MImgController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 15/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class MImgController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var ref: DatabaseReference? = nil
    
    @IBOutlet weak var titletx: UILabel!
    var storeid:String = ""
    var campaignid:String = ""
    var pickImgnameData: [String] = [String]()
    var campaigntheme = ""
    var currentimg = ""
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var testimg: UIImageView!
    @IBOutlet weak var uploadbtn: UIButton!
    @IBOutlet weak var imgnamepicker: UIPickerView!
    
    @IBOutlet weak var loadimg: UIImageView!
    
    @IBOutlet weak var uploadtofbbtn: UIButton!
    @IBOutlet weak var deleteimgbtn: UIButton!
    
    @IBAction func deleteimgfunc(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = self.campaigntheme+"/"+self.currentimg
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.delete { error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
                print("delete yet")
                self.deleteimgbtn.isHidden = false
                self.deleteimgbtn.isEnabled = true
                self.uploadbtn.isHidden = false
                self.uploadbtn.isEnabled = true
            }
        }

    }
    
    @IBAction func uploadimgfunc(_ sender: Any) {
        print("upload file.")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadfunc(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        //let mountainsRef = storageRef.child("Cbg.jpg")
        let imgname = self.campaigntheme+"/"+self.currentimg
        let riversRef = storageRef.child(imgname)
        
        var data = Data()
        
        data = UIImageJPEGRepresentation(self.loadimg.image!, 0.8)!
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
        print("current file is ,",self.loadimg)
    }
    
    @IBAction func gobackfunc(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titletx.text = self.campaignid
        
        self.imgnamepicker.delegate = self
        self.imgnamepicker.dataSource = self
        
    self.pickImgnameData=["GifBg","InsertMobile","Pin","TextBg","Title","Wheel","WheelShadow","taphere","PinLine"]
        
        self.deleteimgbtn.isHidden = true
        self.deleteimgbtn.isEnabled = false
        self.uploadbtn.isHidden = true
        self.uploadbtn.isEnabled = false
        
        imagePicker.delegate = self
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
    
    //picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickImgnameData.count
    }
    
    func numberOfComponentsInPickView(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickImgnameData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickImgnameData[row])
        let filename = ""+String(pickImgnameData[row])+".png"
        self.currentimg = filename
        ref = Database.database().reference()
        ref?.child("theme").child(self.campaignid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            //print(">>>>> folder name :",themename)
            self.campaigntheme = theme
            self.getImgFromFireBase(themename: theme, filename: filename, imgview: self.loadimg)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //load img
    
    func getImgFromFireBase(themename:String,filename:String,imgview:UIImageView){
        //download img from firebase
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = themename+"/"+filename
        let bgimgRef = storageRef.child(imgname)
        
        bgimgRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
                self.uploadbtn.isHidden = false
                self.uploadbtn.isEnabled = true
                self.deleteimgbtn.isHidden = true
                self.deleteimgbtn.isEnabled = false
                self.loadimg.isHidden = true
            } else {
                //self.bg.image = UIImage(data: data!)
                imgview.image = UIImage(data: data!)
                self.deleteimgbtn.isHidden = false
                self.deleteimgbtn.isEnabled = true
                self.uploadbtn.isHidden = true
                self.uploadbtn.isEnabled = false
            }
        }
    }
    
    //pick image
    //Img pick controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("selected an img file")
            self.testimg.contentMode = .scaleAspectFit
            self.testimg.image = pickedImage
            self.testimg.reloadInputViews()
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
