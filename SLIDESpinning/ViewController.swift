//
//  ViewController.swift
//  SLIDESpinning
//
//  Created by Wayne Lai on 13/12/17.
//  Copyright © 2017 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var counter: Int = 0
    var selectedstore = ""
    @IBOutlet weak var wheelshadowimg: UIImageView!
    
    @IBOutlet weak var textbg: UIImageView!
    
    @IBOutlet weak var taphere: UIImageView!
  
    @IBOutlet weak var pinline: UIImageView!
    
    @IBOutlet weak var pindot: UIImageView!
    
    @IBOutlet weak var titleimg: UIImageView!
    
    @IBOutlet weak var descriptionfont: UIImageView!
    
    @IBOutlet weak var tfText: UITextField!
  
  @IBOutlet weak var imgWheel: UIImageView!
  
  @IBOutlet weak var bg: UIImageView!
  
  @IBOutlet weak var secretView: UIView!
  
  @IBOutlet weak var anotherSecret: UIView!
  
    @IBOutlet weak var backbtn: UIButton!
    @IBAction func backtopre(_ sender: Any) {
        if (self.counter == 0){
            self.counter = self.counter + 1
        }else{
            self.counter = 0
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BaseVc") as! BaseViewController
            vc.selectedStore = self.selectedstore
            vc.selectedCampaign = self.themeno
            present(vc, animated: true, completion: nil)
        }
    }
    
    var ref: DatabaseReference? = nil
  
  let pieChartView = PieChartView()
  let circleView = CircleView()
  
  var currentAngularSpeed: Double = 0.0
  var totalSpeed = 0.0
  
  var randomPicked = 0
  
  var isSpinning = false
    
  var themeno:String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    
    bg.image = nil
    //bg.image = gifFile
    //getImgFromFireBase(string: "cnyGifBg.gif",imgview: self.bg)
    print("themeno,",self.themeno)
    getThemeNo(themeno: self.themeno)
    addDoneButtonOnKeyboard()
    slowSpin(targetView: self.imgWheel)
    // Disable Snow flakes -> Christmas View
//    let snowFlakes = SnowflakesView(frame: view.frame)
//
//    view.addSubview(snowFlakes)
//
//    view.sendSubview(toBack: snowFlakes)
//    view.sendSubview(toBack: bg)
    
    
    ref = Database.database().reference()
    
    //addDoneButtonOnKeyboard()
    
    //slowSpin(targetView: self.imgWheel)

  }
    

  
  @objc func changeTopPrizeData() {
    //
    self.counter = 0
    //
    let alertVC = UIAlertController(title: "", message: "Enable top prize?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Enable", style: .default) { (act) in
      self.saveDataLocally(object: "true", string: "top")
    }
    alertVC.addAction(okAction)
    
    let notOkAction = UIAlertAction(title: "Disable", style: .default) { (act) in
      self.saveDataLocally(object: "false", string: "top")
    }
    alertVC.addAction(notOkAction)
    
    DispatchQueue.main.async {
      self.present(alertVC, animated: true, completion: nil)
    }
  }
  
  // Enable sure win
  @objc func sureWin() {
    let alert = UIAlertController(title: "Enable sure win?", message: "", preferredStyle: .alert)
    
    alert.addTextField { (textField) in
      textField.text = self.tfText.text!
      textField.keyboardType = .phonePad
    }
    
    alert.addAction(UIAlertAction(title: "Disable", style: .default, handler: { (act) in
      self.saveDataLocally(object: "false", string: "sure")
    }))
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      
      if textField?.text! == "55555" {
        self.saveDataLocally(object: "true", string: "sure")
      } else {
        self.showAlertWithTitle(title: "", message: "wrong passcode")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func slowSpin(targetView: UIView) {
    if !isSpinning {
      self.currentAngularSpeed = 0.1
      let newAngle: CGFloat = CGFloat(self.currentAngularSpeed) * CGFloat(0.5)
      self.spinSlowRotate(angle: newAngle)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        self.slowSpin(targetView: self.imgWheel)
      })
    }
  }
  
  func spinSlowRotate(angle: CGFloat, animated: Bool = false) {
    UIView.animate(withDuration: 0.2) {
      self.imgWheel.layer.transform = CATransform3DRotate(self.imgWheel.layer.transform, angle, 0, 0, 1)
    }
  }
  
  @IBAction func textFieldClicked() {
    let alert = UIAlertController(title: "Insert mobile number", message: "", preferredStyle: .alert)
    
    alert.addTextField { (textField) in
      textField.text = self.tfText.text!
      textField.keyboardType = .phonePad
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0]
//      print("Text field: \(String(describing: textField?.text!))")
      self.tfText.text = textField?.text!
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }

  @IBAction func buttonClicked() {
    
    if isSpinning {
      return
    }
    
    view.endEditing(true)
    
    if tfText.text!.count != 8 {
      showAlertWithTitle(title: "", message: "Please enter correct mobile number")
      return
    }
    
    if tfText.text!.first != "8" && tfText.text!.first != "9" {
      showAlertWithTitle(title: "", message: "Please enter correct mobile number")
      return
    }
    
    isSpinning = true
    
    currentAngularSpeed = Double.random(min: 3, max: 4)

    let randomNumber = randomPercent()
    switch(randomNumber) {
    case 0..<25:
      randomPicked = 4
      print("25%")
      break
    case 25..<50:
      randomPicked = 2
      print("25%")
      break
    case 50..<70:
      randomPicked = 1
      print("20%")
      break
    case 70..<80:
      randomPicked = 5
      print("10%")
      break
    case 80..<85:
      randomPicked = 6
      print("5%")
      break
    case 85..<90:
      randomPicked = 0
      print("5%")
      break
    default:
      randomPicked = 7
      print("10%")
      break
    }
    
    if randomPicked == 3 {
      if getDataLocally(string: "top") == "" || getDataLocally(string: "top") == "false" {
        print("too bad :(")
        randomPicked = 4
      }
    }
    
    randomPicked = 1
    
    //0 (1), 1 (6) - 70 < 80, 2 (3) - 95 < 98, 3 (TOP) 90 < 91, 4 (5), 5 (2), 6 (4), 7 (
    
    var num = ""
    
    switch randomPicked {
    case 0:
      num = "1"
    case 1:
      num = "6"
    case 2:
      num = "3"
    case 3:
      num = "TOP"
    case 4:
      num = "5"
    case 5:
      num = "2"
    case 6:
      num = "4"
    case 7:
      num = "7"
    default:
      num = "0"
    }
    
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Store winner
    //let childRef = ref?.child("winner").childByAutoId()
    let childRef = ref?.child("winner").child(themeno).child("1").childByAutoId()
    let addingItem = [
      "mobileNumber": tfText.text!,
      "winningNumber": num,
      "spinDate": dateFormat.string(from: Date())
      ] as [String : Any]
    childRef?.setValue(addingItem, withCompletionBlock: { (errorAdding, ref) in
      if errorAdding == nil {
        self.updateRotate()
      }
    })
    
  }
  
  func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    tfText.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction() {
    view.endEditing(true)
  }
  
  func createCustomWheel() {
    // Customs create wheel
    //    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeTopPrizeData))
    //    doubleTapRecognizer.numberOfTapsRequired = 3
    //
    //    // add gesture recognizer to button
    //    secretView.addGestureRecognizer(doubleTapRecognizer)
    
    //    let fiveTap = UITapGestureRecognizer(target: self, action: #selector(sureWin))
    //    fiveTap.numberOfTapsRequired = 5
    //
    //    // add gesture recognizer to button
    //    anotherSecret.addGestureRecognizer(fiveTap)
    
    //    pieChartView.frame = CGRect(x: 0, y: 80, width: view.frame.size.width, height: view.frame.size.width - 30)
    //    pieChartView.segments = [
    //      Segment(color: UIColor(red: 1.0, green: 31.0/255.0, blue: 73.0/255.0, alpha: 1.0), name:"", value: 1),
    //      Segment(color: UIColor(red:1.0, green: 138.0/255.0, blue: 0.0, alpha: 1.0), name: "", value: 1),
    //      Segment(color: UIColor(red: 122.0/255.0, green: 108.0/255.0, blue: 1.0, alpha: 1.0), name: "", value: 1),
    //      Segment(color: UIColor(red: 0.0, green: 222.0/255.0, blue: 1.0, alpha: 1.0), name: "", value: 1),
    //      Segment(color: UIColor(red: 100.0/255.0, green: 241.0/255.0, blue: 183.0/255.0, alpha: 1.0), name: "", value: 1),
    //      Segment(color: UIColor(red: 0.0, green: 100.0/255.0, blue: 1.0, alpha: 1.0), name: "", value: 1),
    //      Segment(color: UIColor(red: 1.0, green: 31.0/255.0, blue: 73.0/255.0, alpha: 1.0), name:"", value: 1),
    //      Segment(color: UIColor(red:1.0, green: 138.0/255.0, blue: 0.0, alpha: 1.0), name: "", value: 1)
    //    ]
    //
    //    pieChartView.segmentLabelFont = UIFont.systemFont(ofSize: 18)
    //    pieChartView.showSegmentValueInLabel = false
    //    view.addSubview(pieChartView)
    //
    //    circleView.frame = CGRect(x: 0, y: 80, width: view.frame.size.width, height: view.frame.size.width - 30)
    //    circleView.segments = [
    //      CCView(name: "1", value: 1),
    //      CCView(name: "2", value: 1),
    //      CCView(name: "3", value: 1),
    //      CCView(name: "4", value: 1),
    //      CCView(name: "5", value: 1),
    //      CCView(name: "6", value: 1),
    //      CCView(name: "7", value: 1),
    //      CCView(name: "8", value: 1)
    //    ]
    //    circleView.backgroundColor = UIColor.clear
    //    view.addSubview(circleView)
    //
    //
    //    let imgview = UIImageView(frame: CGRect(x: view.frame.width / 2 - 11, y: 80 - 28, width: 23, height: 32))
    //    imgview.image = #imageLiteral(resourceName: "roulettepointer")
    //    view.addSubview(imgview)
  }

}

// Wheel rotation
extension ViewController {
  
  func randomPercent() -> Double {
    return Double(arc4random() % 1000) / 10.0;
  }
  
  func updateRotate() {
    rotateOnDeceleration(targetView: imgWheel)
  }
  
  func rotateIndicatorsLayer(angle: CGFloat, animated: Bool = false) {
    UIView.animate(withDuration: 0.2) {
      self.imgWheel.layer.transform = CATransform3DRotate(self.imgWheel.layer.transform, angle, 0, 0, 1)
    }
  }
  
  func rotateOnDeceleration(targetView: UIView) {
    if self.currentAngularSpeed < 0.25 {
      //      self.stopRotation()
      
      var startAngle = CGFloat(-(Double.pi / 2))
      
      var selectedAngle = CGFloat(0)
      
      for i in 0...7 {
        let endAngle = startAngle + (CGFloat(2.0 * Double.pi) * CGFloat(1.0 / 8.0))
        
        if randomPicked == i {
          selectedAngle = startAngle
        }
        
        startAngle = endAngle
      }
      
      // Set a better point
      if randomPicked == 7 {
        selectedAngle = 2.7999
      } else if randomPicked == 6 {
        selectedAngle = 3.600
      }
      
      let radians = atan2f(Float(imgWheel.transform.b), Float(imgWheel.transform.a))
      
      if CGFloat(radians) < selectedAngle && CGFloat(radians) > selectedAngle - 0.75 {
        self.currentAngularSpeed = 0.0
        self.showAlertWithTitle(title: "Congratulation!", message: "")
      } else {
        self.currentAngularSpeed = self.currentAngularSpeed < 0.1 ? 0.1 : self.currentAngularSpeed * 0.98
        let newAngle: CGFloat = CGFloat(self.currentAngularSpeed) * CGFloat(0.5)
        self.rotateIndicatorsLayer(angle: newAngle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
          self.rotateOnDeceleration(targetView: self.imgWheel)
        })
      }
      
    } else {
      
      self.currentAngularSpeed = self.currentAngularSpeed * 0.975
      let newAngle: CGFloat = CGFloat(self.currentAngularSpeed) * CGFloat(0.5)
      self.rotateIndicatorsLayer(angle: newAngle)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        self.rotateOnDeceleration(targetView: self.imgWheel)
      })
      
      
    }
  }
  
  func showAlertWithTitle( title:String, message:String ) {
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
      if self.isSpinning {
        self.isSpinning = false
        self.tfText.text = ""
        self.slowSpin(targetView: self.imgWheel)
      }
    }
    alertVC.addAction(okAction)
    
    DispatchQueue.main.async {
      self.present(alertVC, animated: true, completion: nil)
    }
  }
  
}

public extension Double {
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  public static var random:Double {
    get {
      return Double(arc4random()) / 0xFFFFFFFF
    }
  }
  
  public static func random(min: Double, max: Double) -> Double {
    return Double.random * (max - min) + min
  }
}

extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
  
  @IBAction func textFieldEditing(_ textField: UITextField) {
    if textField.text!.count == 8 {
      view.endEditing(true)
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
    let compSepByCharInSet = string.components(separatedBy: aSet)
    let numberFiltered = compSepByCharInSet.joined(separator: "")
    return string == numberFiltered
  }
  
}

extension ViewController {
  
  func saveDataLocally(object:String, string:String) {
    let userDefault = UserDefaults()
    userDefault.set(object, forKey: string)
    userDefault.synchronize()
  }
  
  func deleteDataLocally(string:String) {
    let userDefault = UserDefaults()
    userDefault.removeObject(forKey: string)
    userDefault.synchronize()
  }
  
  func getDataLocally(string:String)->String {
    let userDefault = UserDefaults()
    
    if let string = userDefault.object(forKey: string) as? String {
      return string
    }
    else {
      return ""
    }
  }
    
    func getImgFromFireBase(themename:String,filename:String,imgview:UIImageView){
        //download img from firebase
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = themename+"/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading img error :",error)
            } else {
                //self.bg.image = UIImage(data: data!)
                imgview.image = UIImage(data: data!)
            }
        }
    }
    
    func getGIFFromFireBase(themename:String,filename:String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgname = themename+"/"+filename
        let bgimgRef = storageRef.child(imgname)
        bgimgRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(">>>> downloading gif error :",error)
            } else {
                let advTimeGif = UIImage.gifImageWithData(data!)
                let imageView = UIImageView(image: advTimeGif)
                self.view.insertSubview(imageView, at: 0)
            }
        }
    }
 
    func getThemeNo(themeno:String){
        ref = Database.database().reference()
        ref?.child("theme").child(themeno).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            //print(">>>>> folder name :",themename)
            self.getThemeImg(themename: theme)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getThemeImg(themename:String){
        getGIFFromFireBase(themename: themename,filename: "GifBg.gif")
        getImgFromFireBase(themename: themename,filename: "Wheel.png",imgview: self.imgWheel)
        getImgFromFireBase(themename: themename,filename: "WheelShadow.png",imgview: self.wheelshadowimg)
        getImgFromFireBase(themename: themename,filename: "TextBg.png",imgview: self.textbg)
        getImgFromFireBase(themename: themename,filename: "taphere.png",imgview: self.taphere)
        getImgFromFireBase(themename: themename,filename: "PinLine.png",imgview: self.pinline)
        getImgFromFireBase(themename: themename,filename: "Pin.png",imgview: self.pindot)
        getImgFromFireBase(themename: themename,filename: "Title.png",imgview: self.titleimg)
        getImgFromFireBase(themename: themename,filename: "InsertMobile.png",imgview: self.descriptionfont)
    }
    
    func testfun(){
        //ref = Database.database().reference()
        //ref?.child("Store").childByAutoId().observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as? NSDictionary
            //let theme = value?["folderName"] as? String ?? ""
            /*
            while let listObject = enumerator.nextObject() as? DataSnapshot {
                print("key>>>>>",listObject.key)
                let object = listObject.value as! [String: AnyObject]
                print("value",object)
            }*/
        //}) { (error) in
        //    print(error.localizedDescription)
        //}
    }
  
}
