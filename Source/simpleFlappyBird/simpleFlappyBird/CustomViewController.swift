//
//  CustomViewController.swift
//  simpleFlappyBird
//
//  Created by Binh Ne on 12/7/18.
//  Copyright © 2018 Phan Hải Bình. All rights reserved.
//

import UIKit
import CoreImage

class CustomViewController: UIViewController {

    @IBAction func _Back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
   
    @IBAction func Choose_default(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let defaultScreen = sb.instantiateViewController(withIdentifier: "DEFAULT")
        self.navigationController?.pushViewController(defaultScreen, animated: false)
    }
    @IBAction func Choose_face(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let defaultScreen = sb.instantiateViewController(withIdentifier: "FACE")
        self.navigationController?.pushViewController(defaultScreen, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}


