//
//  ReviewViewController.swift
//  Lab05
//
//  Created by 변상운 on 2020/10/24.
//  Copyright © 2020 sangun. All rights reserved.
//

import Foundation
import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myReview: UITextField!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    @IBOutlet weak var toiletRate1: UIButton!
    @IBOutlet weak var toiletRate2: UIButton!
    @IBOutlet weak var toiletRate3: UIButton!
    @IBOutlet weak var toiletRate4: UIButton!
    @IBOutlet weak var toiletRate5: UIButton!
    
    let defaults = UserDefaults.standard
    
    
    //var reviewItemsImage: [Data] = UserDefaults.standard.array(forKey: "reviewItemImage") as? [Data] ?? []
    
 
    var myNameSent = ""
    var myImageSent = UIImage()
    var userNameSet: Set<String> = []
   
    var toiletIndexSent = ""
    var toiletIndex = ""
    
    var eachToiletReview = [[]]
    
    let star: UIImage? = UIImage(named: "star")
    let starFilled: UIImage? = UIImage(named: "starFilled")
    
    var toiletRate = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        myName.text = myNameSent
        myImage.image = myImageSent
        toiletIndex = toiletIndexSent
            
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        let logoutButton = UIBarButtonItem(title: "Log out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.logoutButton(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = logoutButton
        
        
        initRate()
        
        toiletRate = 0
        eachToiletReview = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", String(toiletRate)]]
        
        
        DataManager.shared.firstVC = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        definesPresentationContext = true
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MY RATE
    @IBAction func rateButton1(_ sender: UIButton) {
        initRate()
        toiletRate1.setImage(starFilled, for: .normal)
        toiletRate = 1
    }
    
    @IBAction func rateButton2(_ sender: UIButton) {
        initRate()
        toiletRate1.setImage(starFilled, for: .normal)
        toiletRate2.setImage(starFilled, for: .normal)
        toiletRate = 2
    }
    @IBAction func rateButton3(_ sender: UIButton) {
        initRate()
        toiletRate1.setImage(starFilled, for: .normal)
        toiletRate2.setImage(starFilled, for: .normal)
        toiletRate3.setImage(starFilled, for: .normal)
        toiletRate = 3
    }
    @IBAction func rateButton4(_ sender: UIButton) {
        initRate()
        toiletRate1.setImage(starFilled, for: .normal)
        toiletRate2.setImage(starFilled, for: .normal)
        toiletRate3.setImage(starFilled, for: .normal)
        toiletRate4.setImage(starFilled, for: .normal)
        toiletRate = 4
    }
    
    @IBAction func rateButton5(_ sender: UIButton) {
        initRate()
        toiletRate1.setImage(starFilled, for: .normal)
        toiletRate2.setImage(starFilled, for: .normal)
        toiletRate3.setImage(starFilled, for: .normal)
        toiletRate4.setImage(starFilled, for: .normal)
        toiletRate5.setImage(starFilled, for: .normal)
        toiletRate = 5
    }
    
    
    @objc func logoutButton(sender: UIBarButtonItem) {
        
        var loginState = self.defaults.bool(forKey: "loginState")
        loginState = false
        defaults.set(loginState, forKey: "loginState")
        
        self.navigationController?.popToRootViewController(animated: true)
        
        let alert = UIAlertController(title: "", message: "로그아웃 되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler : nil)
        alert.addAction(defaultAction)
        present(alert,animated: false, completion: nil)
    }
    
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        
        let eachToiletReview: [[String]] = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", String(toiletRate)]]

        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let PopupUpdateViewControlelr = storyboard.instantiateViewController(withIdentifier: "PopupUpdateViewControlelr") as! PopupUpdateViewControlelr
    
        PopupUpdateViewControlelr.nameSent = eachToiletReview[sender.tag][0]
        PopupUpdateViewControlelr.commentSent = eachToiletReview[sender.tag][1]
        
        if(eachToiletReview[sender.tag].count == 3){
            PopupUpdateViewControlelr.toiletRateSent = Int(eachToiletReview[sender.tag][2])!
        }
        
        PopupUpdateViewControlelr.toiletIndexSent = toiletIndex
        print("sender.tag : \(sender.tag)")
        PopupUpdateViewControlelr.reviewIndexSent = sender.tag
        
        PopupUpdateViewControlelr.imageSent = myImage.image!
        
        
        self.present(PopupUpdateViewControlelr, animated: true, completion: nil)
      }
      

    @IBAction func deleteButton(_ sender: UIButton) {
        
        var eachToiletReview: [[String]] = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", String(toiletRate)]]
        
        eachToiletReview.remove(at: sender.tag)
        defaults.set(eachToiletReview, forKey: "\(toiletIndex)")
        
        print("remove after eachToiletReview \(eachToiletReview)")
        
        self.reviewTableView.reloadData()
    }
    
    
    
    @IBAction func registerReviewButton(_ sender: Any) {
        
        
        var eachToiletReview: [[String]] = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", String(toiletRate)]]
        
          //var reviewItemsImage: [Data] = defaults.array(forKey: "reviewItemImage") as? [Data] ?? []
        
        
        // 내 리뷰 저장 (이미지)
//        let testImage = myImageSent
//        let jpgImage = testImage.jpegData(compressionQuality: 0.1)
        
        //reviewItemsImage.append(jpgImage!)
//        defaults.set(reviewItemsImage, forKey: "reviewItemImage")
//        defaults.synchronize()
        
    
        if(myReview.text == ""){
            let alert = UIAlertController(title: "", message: "내용을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert,animated: false, completion: nil)
        }
        else if(toiletRate == 0){
            let alert = UIAlertController(title: "", message: "평점을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            present(alert,animated: false, completion: nil)
        }
            
        else {
        eachToiletReview.append([myName.text!, myReview.text!, String(toiletRate)])
        defaults.set(eachToiletReview, forKey: "\(toiletIndex)")
        self.reviewTableView.reloadData()
        
        self.myReview.text = ""
        
        
        
        // 등록 확인 alert
        let alert = UIAlertController(title: "", message: "리뷰가 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler : nil)
        alert.addAction(defaultAction)
        present(alert,animated: false, completion: nil)
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let eachToiletReview = defaults.array(forKey: "\(toiletIndex)") as? [[String]]
        return eachToiletReview?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! reviewTableViewCell
            
        
        // 이름, 내용 user default
        let eachToiletReview: [[String]] = defaults.array(forKey: "\(toiletIndex)") as? [[String]] ?? [["default user name", "default user comment", String(toiletRate)]]
        
        //var reviewItemsImage: [Data] = UserDefaults.standard.array(forKey: "reviewItemImage") as? [Data] ?? []

//        // 이미지 user default
//        if let imgData = defaults.object(forKey: "reviewItemImage") as? NSData {
//            if let image = UIImage(data: imgData as Data) {
//                cell.userImage.image = image
//            }
//        }
        
        
        
        
        cell.updateButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        cell.userName.text = eachToiletReview[indexPath.row][0]
        cell.userComment.text = eachToiletReview[indexPath.row][1]
        
        
        if(eachToiletReview[indexPath.row].count == 3){
            let cellRate = Int(eachToiletReview[indexPath.row][2])
            if(cellRate == 1){
                cell.eachToiletRate1.setImage(starFilled, for: .normal)
                cell.eachToiletRate2.setImage(star, for: .normal)
                cell.eachToiletRate3.setImage(star, for: .normal)
                cell.eachToiletRate4.setImage(star, for: .normal)
                cell.eachToiletRate5.setImage(star, for: .normal)
                
            } else if(cellRate == 2){
                cell.eachToiletRate1.setImage(starFilled, for: .normal)
                cell.eachToiletRate2.setImage(starFilled, for: .normal)
                cell.eachToiletRate3.setImage(star, for: .normal)
                cell.eachToiletRate4.setImage(star, for: .normal)
                cell.eachToiletRate5.setImage(star, for: .normal)
                
            } else if(cellRate == 3){
                cell.eachToiletRate1.setImage(starFilled, for: .normal)
                cell.eachToiletRate2.setImage(starFilled, for: .normal)
                cell.eachToiletRate3.setImage(starFilled, for: .normal)
                cell.eachToiletRate4.setImage(star, for: .normal)
                cell.eachToiletRate5.setImage(star, for: .normal)
                
            } else if(cellRate == 4){
                cell.eachToiletRate1.setImage(starFilled, for: .normal)
                cell.eachToiletRate2.setImage(starFilled, for: .normal)
                cell.eachToiletRate3.setImage(starFilled, for: .normal)
                cell.eachToiletRate4.setImage(starFilled, for: .normal)
                cell.eachToiletRate5.setImage(star, for: .normal)
                
            } else if(cellRate == 5){
                cell.eachToiletRate1.setImage(starFilled, for: .normal)
                cell.eachToiletRate2.setImage(starFilled, for: .normal)
                cell.eachToiletRate3.setImage(starFilled, for: .normal)
                cell.eachToiletRate4.setImage(starFilled, for: .normal)
                cell.eachToiletRate5.setImage(starFilled, for: .normal)
            }
        }
        
        
        
        
        userNameSet.insert(eachToiletReview[indexPath.row][0])
        
        if(userNameSet.contains(myName.text!) && cell.userName.text == myName.text!) {
            cell.updateButton.isHidden = false
            cell.deleteButton.isHidden = false
        } else {
            cell.updateButton.isHidden = true
            cell.deleteButton.isHidden = true
        }
        
        
        return cell
    }
    
    
    func initRate() {
        toiletRate1.setImage(star, for: .normal)
        toiletRate2.setImage(star, for: .normal)
        toiletRate3.setImage(star, for: .normal)
        toiletRate4.setImage(star, for: .normal)
        toiletRate5.setImage(star, for: .normal)
    }

    
}
