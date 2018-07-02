//
//  ResultDetailViewController.swift
//  CoreMLDemo
//
//  Created by Collin on 2017/12/21.
//  Copyright © 2017年 AppCoda. All rights reserved.
//

import UIKit

class ResultDetailViewController: UIViewController {
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var classifier: UILabel!
    
    var URL: String!
    var ans:String!
    var result: ResultMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let resultImage = result.image {
            ImageView.image = UIImage(data: resultImage as Data)
        }
        if let result_text = result.result {
            classifier.text = "I think this is a \(result_text)."
            ans = result_text
            URL="http://www.google.com/search?q=\(result_text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier=="showWebfromDetail"{
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

