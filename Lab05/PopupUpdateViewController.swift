//
//  PopupUpdateViewController.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/24.
//  Copyright © 2020 sangun. All rights reserved.
//

import Foundation
import UIKit

class PopupUpdateViewControlelr : UIViewController {
    
    @IBOutlet weak var popupImage: UIImageView!
    @IBOutlet weak var popupName: UILabel!
    @IBOutlet weak var popupComment: UITextView!
    
    @IBOutlet weak var popupRate1: UIButton!
    @IBOutlet weak var popupRate2: UIButton!
    @IBOutlet weak var popupRate3: UIButton!
    @IBOutlet weak var popupRate4: UIButton!
    @IBOutlet weak var popupRate5: UIButton!
    
    var nameSent = ""
    var commentSent = ""
    var imageSent = UIImage()
    
    let defaults = UserDefaults.standard
    var toiletIndexSent = ""
    var toiletIndex = ""
    
    var reviewIndexSent = 0
    var reviewIndex = 0
    var toiletRate = 0
    var toiletRateSent = 0
    
    let star: UIImage? = UIImage(named: "star")
    let starFilled: UIImage? = UIImage(named: "starFilled")
    
    
    
     var instanceOfVCA:ReviewViewController!    // Create an instance of VCA in VCB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupName.text = nameSent
        popupComment.text = commentSent
        popupImage.image = imageSent
        
        toiletIndex = toiletIndexSent
        reviewIndex = reviewIndexSent
        
        toiletRate = toiletRateSent
        
        // 키보드 올라올 시 화면 이동
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
            if(toiletRate == 1){
                popupRate1.setImage(starFilled, for: .normal)
                
            } else if(toiletRate == 2){
                popupRate1.setImage(starFilled, for: .normal)
                popupRate2.setImage(starFilled, for: .normal)
                
            } else if(toiletRate == 3){
                popupRate1.setImage(starFilled, for: .normal)
                popupRate2.setImage(starFilled, for: .normal)
                popupRate3.setImage(starFilled, for: .normal)
                
            } else if(toiletRate == 4){
                popupRate1.setImage(starFilled, for: .normal)
                popupRate2.setImage(starFilled, for: .normal)
                popupRate3.setImage(starFilled, for: .normal)
                popupRate4.setImage(starFilled, for: .normal)
                
            } else if(toiletRate == 5){
                popupRate1.setImage(starFilled, for: .normal)
                popupRate2.setImage(starFilled, for: .normal)
                popupRate3.setImage(starFilled, for: .normal)
                popupRate4.setImage(starFilled, for: .normal)
                popupRate5.setImage(starFilled, for: .normal)
            }
        
        
    }
    
    
    @IBAction func popupRate1(_ sender: Any) {
        initRate()
        popupRate1.setImage(starFilled, for: .normal)
        toiletRate = 1
    }
    @IBAction func popupRate2(_ sender: Any) {
        initRate()
        popupRate1.setImage(starFilled, for: .normal)
        popupRate2.setImage(starFilled, for: .normal)
        toiletRate = 2
    }
    @IBAction func popupRate3(_ sender: Any) {
        initRate()
        popupRate1.setImage(starFilled, for: .normal)
        popupRate2.setImage(starFilled, for: .normal)
        popupRate3.setImage(starFilled, for: .normal)
        toiletRate = 3
    }
    
    @IBAction func popupRate4(_ sender: Any) {
        initRate()
        popupRate1.setImage(starFilled, for: .normal)
        popupRate2.setImage(starFilled, for: .normal)
        popupRate3.setImage(starFilled, for: .normal)
        popupRate4.setImage(starFilled, for: .normal)
        toiletRate = 4
    }
    @IBAction func popupRate5(_ sender: Any) {
        initRate()
        popupRate1.setImage(starFilled, for: .normal)
        popupRate2.setImage(starFilled, for: .normal)
        popupRate3.setImage(starFilled, for: .normal)
        popupRate4.setImage(starFilled, for: .normal)
        popupRate5.setImage(starFilled, for: .normal)
        toiletRate = 5
    }
    
    @IBAction func popupCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popupUpdateButton(_ sender: Any) {
        var eachToiletReview: [[String]] = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", "0"]]
        
        
        if(popupComment.text == "") {

            let alert = UIAlertController(title: "", message: "내용을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert,animated: false, completion: nil)
        }
        
        
        eachToiletReview[reviewIndex][1] = popupComment.text
        //eachToiletReview[reviewIndex][2] = String(toiletRate)
        if(eachToiletReview[reviewIndex].count == 2){
            eachToiletReview[reviewIndex].append(String(toiletRate))
        }
        else {
            eachToiletReview[reviewIndex][2] = String(toiletRate)
        }
        defaults.set(eachToiletReview, forKey: "\(toiletIndex)")
        
        
        DataManager.shared.firstVC.reviewTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    func initRate() {
        popupRate1.setImage(star, for: .normal)
        popupRate2.setImage(star, for: .normal)
        popupRate3.setImage(star, for: .normal)
        popupRate4.setImage(star, for: .normal)
        popupRate5.setImage(star, for: .normal)
    }

    
    
}


class DataManager {

        static let shared = DataManager()
        var firstVC = ReviewViewController()
}
