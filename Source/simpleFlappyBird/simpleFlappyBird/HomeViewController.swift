//
//  HoneViewController.swift
//  simpleFlappyBird
//
//  Created by sv on 11/30/18.
//  Copyright © 2018 Phan Hải Bình. All rights reserved.
//

import UIKit


class HoneViewController: UIViewController {
    
    @IBAction func playBtn_Clicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let playScreen = sb.instantiateViewController(withIdentifier: "PLAY")
        self.navigationController?.pushViewController(playScreen, animated: false)
    }
    
    @IBAction func customBtn_Clicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let playScreen = sb.instantiateViewController(withIdentifier: "CUSTOM")
        self.navigationController?.pushViewController(playScreen, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //Character = GlobalItem._character
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
}
