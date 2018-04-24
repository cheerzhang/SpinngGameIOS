//
//  TestchildViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 9/4/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit
import Firebase

class TestchildViewController: TestbaseViewController {
    
    var ref: DatabaseReference? = nil
    
    @IBOutlet weak var labeltx: UILabel!
    @IBOutlet weak var scrolv: UIScrollView!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImage(named: "cny spin")
        let imageView2 = UIImage(named: "easter spin")
        let button1 = UIButton()
        let button2 = UIButton()
        self.getStoreName(storeid:"0")
        
        images = [imageView,imageView2] as! [UIImage]
        for (index,element) in self.images.enumerated(){
            //var imageView = UIImageView()
            let buttonc = UIButton()
            //let x = self.view.frame.size.width * CGFloat(index) * 0.5
            let x = 550 * index
            //imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: 150)
            buttonc.frame = CGRect(x: x, y: 0, width: 500, height: 250)
            buttonc.contentMode = .scaleAspectFit
            //imageView.contentMode = .scaleAspectFit
            buttonc.setBackgroundImage(images[index], for: .normal)
            self.scrolv.contentSize.width = self.scrolv.frame.size.width * CGFloat(index + 1)
            self.scrolv.addSubview(buttonc)
        }
        
        //let scrollv = UIScrollView(frame: view.bounds)
        //self.scrollv.backgroundColor = UIColor.gray
        //self.scrolv.contentSize = imageView.bounds.size
        //scrolv.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        //self.scrolv.addSubview(imageView)
        //self.scrolv.addSubview(imageView2)
        //self.scrolv.setContentOffset(CGPoint(x: 1, y: 1), animated: true)
        //view.addSubview(scrollv)
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
    func getStoreName(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storen = value?["name"] as? String ?? ""
            let buttonc = UIButton()
            let x = 550 * 2
            buttonc.frame = CGRect(x: x, y: 0, width: 500, height: 250)
            buttonc.contentMode = .scaleAspectFit
            buttonc.setTitle(storen, for: .normal)
            buttonc.setBackgroundImage(UIImage(named: "cny spin"), for: .normal)
            self.scrolv.contentSize.width = self.scrolv.frame.size.width * CGFloat(4 + 1)
            self.scrolv.addSubview(buttonc)
            self.labeltx.text = storen
            self.view.updateConstraints()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
