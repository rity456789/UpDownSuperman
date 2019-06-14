//
//  FaceController.swift
//  simpleFlappyBird
//
//  Created by Phan Hai Binh on 1/17/19.
//  Copyright © 2019 Phan Hải Bình. All rights reserved.
//

import UIKit

class FaceController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBAction func Back_click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    var faceImage: UIImageView!
    var check : Int = 0
    var count : Int = 0
    var current : Int = 0
    
    var arrayOfFace = [UIImage]()
    
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var next_button: UIButton!
    @IBOutlet weak var prev_button: UIButton!
    
    @IBAction func Import_click(_ sender: Any) {
        
        if(check == 1)
        {
            faceImage.image = nil
        }
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        
        self.present(image, animated: true)
        
    }
    var characterFace: UIImageView!
    
    
    @IBAction func Ok_click(_ sender: Any) {
        faceImage.image = nil
        characterFace = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        characterFace.image = resizeImage(image: reviewImage.image!, newWidth: 70.0)
        
        
        //resizeImage(image: reviewImage.image!, targetSize: CGSize(width: 50, height: 50))
        
        GlobalCharacter.character = mergedImageWith(frontImage: characterFace.image, backgroundImage: GlobalCharacter.character)
        GlobalCharacter.detail.shield = mergedImageWith(frontImage: characterFace.image, backgroundImage: GlobalCharacter.detail.shield)
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func next_click(_ sender: Any) {
        current = current + 1
        reviewImage.image = arrayOfFace[current]
        if(current == count - 1)
        {
            next_button.isHidden = true
        }
        else if (current == 1)
        {
            prev_button.isHidden = false
        }
        else
        {
            // do nothing
        }
    }
    
    
    @IBAction func prev_click(_ sender: Any) {
        current = current - 1
        reviewImage.image = arrayOfFace[current]
        if(current == 0 )
        {
            prev_button.isHidden = true
        }
        else if (current == count - 2)
        {
            next_button.isHidden = false
        }
        else
        {
            // do nothing
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if(image.size.width == view.bounds.width)
            {
                faceImage = UIImageView(frame: CGRect(x: 0,y: 55, width: image.size.width, height: image.size.height))
            }
            else
            {
                faceImage = UIImageView(frame: CGRect(x: 0,y: 55, width: view.bounds.width, height: image.size.height*view.bounds.width/image.size.width))
            }
            
            if(faceImage.bounds.height > view.bounds.height - 300)
            {
                let tempHeight = view.bounds.height - 300
                let tempWidth = image.size.width*(view.bounds.height - 300)/image.size.height
                faceImage = UIImageView(frame: CGRect(x: view.bounds.width/2 - tempWidth/2,y: 55, width: tempWidth, height: tempHeight))
            }
            
            faceImage.image = image
            self.view.addSubview(faceImage)
            print(faceImage.bounds)
            
        }
        else
        {
            // do nothing
        }
        check = 1
        self.dismiss(animated: true, completion: nil)
        
        
        arrayOfFace.removeAll()
        
        detect()
        
        if(count == 1)
        {
            next_button.isHidden = true
            prev_button.isHidden = true
        }
        else
        {
            next_button.isHidden = false
            prev_button.isHidden = true
        }
        
        reviewImage.image = arrayOfFace[0]
        reviewImage.layer.cornerRadius = 65
        reviewImage.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        next_button.isHidden = true
        prev_button.isHidden = true
        //UIImageWriteToSavedPhotosAlbum(#imageLiteral(resourceName: "demo"), nil, nil, nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detect() {
        guard let personciImage = CIImage(image: faceImage.image!) else {
            return
        }
        
        print(faceImage.bounds)
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // For converting the Core Image Coordinates to UIView Coordinates
        let transformScale = CGAffineTransform(scaleX: 1, y: -1)
        let transform = transformScale.translatedBy(x: 0, y: -personciImage.extent.height)
        
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = faceImage.bounds.size
            var offsetX:CGFloat = 0
            var offsetY:CGFloat = 0
            var scale:CGFloat=0
            if(viewSize.width*personciImage.extent.height > viewSize.height*personciImage.extent.width)
            {
                scale = viewSize.height/personciImage.extent.height
                offsetX = viewSize.width - personciImage.extent.width*viewSize.height/personciImage.extent.height
                offsetX /= 2
                
            }
            else
            {
                scale = viewSize.width/personciImage.extent.width
                offsetY = viewSize.height - personciImage.extent.height*viewSize.width/personciImage.extent.width
                offsetY /= 2
            }
            
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x = faceViewBounds.origin.x + offsetX
            faceViewBounds.origin.y = faceViewBounds.origin.y + offsetY
            
            faceViewBounds = CGRect(x: faceViewBounds.origin.x, y: faceViewBounds.origin.y, width: faceViewBounds.width , height: faceViewBounds.height)
            
            
            
            //-----------------------
            
            let imageView = UIImageView(frame: CGRect(x: 0,y: 400, width: faceViewBounds.width, height: faceViewBounds.height)); // set as you want
            
            
            
            //var dm = CGRect(x: faceViewBounds.origin.x - offsetX , y: faceViewBounds.origin.y - offsetY, width: faceBox.frame.width, height: faceBox.frame.height)
            let dm = CGRect(x: faceViewBounds.origin.x*(faceImage.image?.size.width)!/faceImage.bounds.width, y: faceViewBounds.origin.y*(faceImage.image?.size.height)!/faceImage.bounds.height, width: faceViewBounds.width*(faceImage.image?.size.width)!/faceImage.bounds.width,height: faceViewBounds.height*(faceImage.image?.size.height)!/faceImage.bounds.height)
            
            imageView.image = cropImage(faceImage.image!, toRect: dm, viewWidth: imageView.frame.width, viewHeight: imageView.frame.height)
            //imgFace.layer.borderWidth = 2
            //imgFace.layer.borderColor = UIColor.red.cgColor
            
            
            
            arrayOfFace.append(imageView.image!)// imageView.image
            count = count + 1
        }
        
        
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        //let imageViewScale = min(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width,
                              height:cropRect.size.height)
        
        // For converting the Core Image Coordinates to UIView Coordinates
        
        print(cropZone)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{
    
        if (backgroundImage == nil) {
            return frontImage!
        }
        
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //frontImage?.draw(in: CGRect.init(x: 45, y: -15, width: size.width, height: size.height).insetBy(dx: size.width * 0.30, dy: size.height * 0.30))
        frontImage?.draw(in: CGRect.init(x: GlobalCharacter.detail.x, y: GlobalCharacter.detail.y, width: size.width, height: size.height).insetBy(dx: size.width * GlobalCharacter.detail.dx, dy: size.height * GlobalCharacter.detail.dy))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

