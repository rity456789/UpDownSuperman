//
//  DefaultCharacterViewController.swift
//  simpleFlappyBird
//
//  Created by Phan Hai Binh on 1/17/19.
//  Copyright © 2019 Phan Hải Bình. All rights reserved.
//

import UIKit


class DefaultCharacterViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    
    @IBAction func Back_click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var chosenCharacter: UIImageView!
    
    @IBOutlet weak var collectionVie: UICollectionView!
    
    @IBAction func OK_Click(_ sender: Any) {
        GlobalCharacter.character = anhChon
        GlobalCharacter.detail = detail
        self.navigationController?.popViewController(animated: false)
    }
    
    var arrayOfCharacter : Array<UIImage> = []
    var arrayOfDetail : Array<detailImage> = []
    
    var anhChon:UIImage = #imageLiteral(resourceName: "superman")
    var detail:detailImage = detailImage(shield_1: #imageLiteral(resourceName: "superman-2"), x: 35, y: -15, DX: 0.25, DY: 0.25)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCharacter.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionControllerCellCollectionViewCell
        _cell.imgView.image = arrayOfCharacter[indexPath.row]
        
        return _cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func initData(){
        arrayOfCharacter.append(#imageLiteral(resourceName: "bird"))
        arrayOfCharacter.append(#imageLiteral(resourceName: "heroes"))
        arrayOfCharacter.append(#imageLiteral(resourceName: "jetpack"))
        arrayOfCharacter.append(#imageLiteral(resourceName: "pencil"))
        arrayOfCharacter.append(#imageLiteral(resourceName: "pilot"))
        arrayOfCharacter.append(#imageLiteral(resourceName: "superman"))
        
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "bird_shield"), x: 30, y: 0, DX: 0.28, DY: 0.28))
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "heroes_shield"), x: 30, y: 30, DX: 0.24, DY: 0.24))
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "jetman_shield"), x: 0, y: -25, DX: 0.3, DY: 0.3))
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "pencil_shield"), x: 0, y: -40, DX: 0.3, DY: 0.3))
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "pilot_shield"), x: 17, y: -25, DX: 0.29, DY: 0.29))
        arrayOfDetail.append(detailImage(shield_1: #imageLiteral(resourceName: "superman-2"), x: 35, y: -15, DX: 0.25, DY: 0.25))
        
        
        collectionVie.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        collectionVie.dataSource = self
        collectionVie.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCharacter.image = arrayOfCharacter[indexPath.row]
        anhChon = arrayOfCharacter[indexPath.row]
        detail = arrayOfDetail[indexPath.row]
    }
}


