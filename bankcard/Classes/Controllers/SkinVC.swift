//
//  SkinVC.swift
//  bankcard
//
//  Created by xun on 17/12/23.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SkinCell"

class SkinVC: UICollectionViewController {
    
    var kinds: [String] = [String]()
    var colors: [[String]] = [[String]]()
    var bankcard: BankCardModel? = nil
    
    var selectIcon: UIImageView = {
        
        let icon = UIImageView(image: UIImage(named: "select"))

        icon.backgroundColor = UIColor(white: 0, alpha: 0.4)
        icon.frame = CGRect(origin:.zero, size:CGSize(width:50, height:50))
        icon.layer.cornerRadius = 25
        icon.clipsToBounds = true
        
        return icon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = localize("Skin")
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 16, 0)
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.kinds.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.colors[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SkinCell
    
        cell.skinName = colors[indexPath.section][indexPath.item]
        cell.update()
        
        if cell.skinName == bankcard?.skin {
            self.selectIcon.isHidden = false
            cell.icon.addSubview(selectIcon)
        }
        else if cell.icon == self.selectIcon.superview {
            self.selectIcon.isHidden = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SkinTitleView", for: indexPath) as! SkinReusableView
        
        view.titleLab.text = localize(kinds[indexPath.section])
        
        return view
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! SkinCell
        bankcard?.skin = cell.skinName!
        cell.icon.addSubview(self.selectIcon)
        self.selectIcon.isHidden = false
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: Read Data

    func loadData() {
        
        let config = Bundle.main.path(forResource: "color", ofType: "ini")
        
        do{
           let info = try String(contentsOfFile: config!)
            
            let arr = info.components(separatedBy: "\n")
            
            for str in arr {
                
                if str.lengthOfBytes(using: .utf8) == 0 {continue}
                
                if str.hasPrefix("#") {
                    
                    self.colors.append(str.components(separatedBy: ";"))
                }
                else {
                    
                    self.kinds.append(str)
                }
            }
        }
        catch {}
    }
}

extension SkinCell {
    
    func update() {
        
        DispatchQueue.global().async {
            
            let image = UIImage.skinThumbnail(name: self.skinName!);
            
            DispatchQueue.main.async {
                self.icon.image = image
            }
        }
        self.nameLab.text = self.skinName
    }
}
