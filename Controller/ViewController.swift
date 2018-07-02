//  CoreMLDemo
//  ViewController.swift
//  Created by Collin on 2017/12/15.
//  Copyright © 2017年 AppCoda. All rights reserved.
import CoreML
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    var model: Inceptionv3!
    var URL="https://www.google.com.tw"
    var result: ResultMO!
    var ans:String!
    var photo:UIImage!
    var old_ans:String!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        model = Inceptionv3()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        imageView.image = newImage
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        classifier.text = "I think this is a \(prediction.classLabel)."
        ans="\(prediction.classLabel)"
        URL="http://www.google.com/search?q=\(prediction.classLabel.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        print(URL)
    }
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier=="showWebView"{
            if (ans) == nil {
                let alertController = UIAlertController(title: "Oops", message: "We can't proceed because there is no information, it can not be stored", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
                
                return
            }
            if let destinationCoroller = segue.destination as? WebViewController{
                destinationCoroller.targetURL = URL
            }
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject){
        if (ans) == nil {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because there is no information, it can not be stored", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        if ans == old_ans {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because you don't give another image to identify.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            old_ans = ans
            result = ResultMO(context: appDelegate.persistentContainer.viewContext)
            if (ans) != nil{
                result.result = ans
                if let image = imageView.image {
                    result.image = UIImagePNGRepresentation(image)
                }
                appDelegate.saveContext()
            }
            if let ans = result.result {
                print(ans)
            }
        }
    }
}
