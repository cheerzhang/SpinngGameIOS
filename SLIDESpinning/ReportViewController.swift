//
//  ReportViewController.swift
//  SLIDESpinning
//
//  Created by 张乐 on 16/3/18.
//  Copyright © 2018 Wayne Lai. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var storePicker: UIPickerView!
    var pickStoreData: [String] = [String]()
    var storeidArray:Array<String> = []
    var storeidNo:String = ""
    
    @IBAction func gobackfunc(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
