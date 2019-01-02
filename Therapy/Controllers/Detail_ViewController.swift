//
//  Detail_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/20/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit

class Detail_ViewController: UIViewController {
    @IBOutlet weak var FirstTable: UITableView!
    @IBOutlet weak var SecondTable: UITableView!
    
    var cell1 = [ReviewCell]()
    var cell2 = [SecCell]()
    var titleArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = ["Videos", "Images"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension Detail_ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.FirstTable{
             return 3
        }else{
            return titleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.FirstTable{
            if let cell1 = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell {
                return cell1
            }
        }else{
            if let cell2 = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as? SecCell {
                cell2.lblTitle.text = titleArray[indexPath.row]
                return cell2
            }
        }
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.FirstTable{
            return tableView.frame.height / 3 - 5
        }else{
            return tableView.frame.height / 2
        }
    }
    
}
extension Detail_ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath as IndexPath) as? ImagesCell
            {
                return cell
            }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width)/3, height: 100)
    }
    
}


