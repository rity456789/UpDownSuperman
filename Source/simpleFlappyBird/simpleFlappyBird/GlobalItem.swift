//
//  GlobalItem.swift
//  simpleFlappyBird
//
//  Created by Phan Hai Binh on 1/17/19.
//  Copyright © 2019 Phan Hải Bình. All rights reserved.
//

import Foundation
import UIKit


class GlobalCharacter
{
    static var character : UIImage = #imageLiteral(resourceName: "superman")
    static var detail : detailImage = detailImage(shield_1: #imageLiteral(resourceName: "superman-2"), x: 35, y: -15, DX: 0.25, DY: 0.25)
}

class detailImage{
    var shield : UIImage!
    var x : CGFloat
    var y : CGFloat
    var dx : CGFloat!
    var dy : CGFloat!
    init(shield_1 : UIImage, x : CGFloat, y : CGFloat, DX : CGFloat, DY : CGFloat){
        self.shield = shield_1
        self.x = x
        self.y = y
        self.dx = DX
        self.dy = DY
    }
}
