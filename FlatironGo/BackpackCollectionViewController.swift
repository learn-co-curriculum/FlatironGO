//
//  BackpackCollectionViewController.swift
//  FlatironGo
//
//  Created by Haaris Muneer on 7/16/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BackpackCollectionViewController: UICollectionViewController {
    
    var treasureArray:[Treasure] = []
    let dismissButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: remove dummy data and set up treasure array from Firebase
        let location = GPSLocation(latitude: 1.0, longitude: 1.0)
        let treasure1 = Treasure(location: location, name: "Treasure 1", imageURLString: "https://cdn4.iconfinder.com/data/icons/REALVISTA/3d_graphics/png/400/cube.png")
        let treasure2 = Treasure(location: location, name: "Treasure 2", imageURLString: "https://cdn4.iconfinder.com/data/icons/REALVISTA/3d_graphics/png/400/cube.png")
        let treasure3 = Treasure(location: location, name: "Treasure 3", imageURLString: "https://cdn4.iconfinder.com/data/icons/REALVISTA/3d_graphics/png/400/cube.png")
        let treasure4 = Treasure(location: location, name: "Treasure 4", imageURLString: "https://cdn4.iconfinder.com/data/icons/REALVISTA/3d_graphics/png/400/cube.png")
        treasureArray.append(treasure1); treasureArray.append(treasure2); treasureArray.append(treasure3); treasureArray.append(treasure4)
        
        self.automaticallyAdjustsScrollViewInsets = false
        guard let collectionView = self.collectionView else { print("error getting the collectionView"); return }
        
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = UIColor(red: 0.7, green: 0.9, blue: 0.9, alpha: 1.0)

        setUpDismissButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treasureArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BackpackCollectionViewCell /* else {print("error, fix this later"); return UICollectionViewCell()}*/
        let currentTreasure = treasureArray[indexPath.row]
        cell.treasureImageView.image = currentTreasure.image
        cell.treasureNameLabel.text = currentTreasure.name
        cell.treasureNameLabel.textColor = UIColor.flatironBlueColor()
        cell.backgroundColor = UIColor.clearColor()
    
        return cell
    }
    
    func setUpDismissButton() {
        dismissButton.backgroundColor = UIColor.flatironBlueColor()
        //TODO: Replace with x icon
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.titleLabel?.textAlignment = .Center
        view.addSubview(dismissButton)
        dismissButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
            make.width.equalTo(dismissButton.snp_height)
        }
        dismissButton.layer.cornerRadius = 25
        dismissButton.addTarget(self, action: #selector(dismissBackpack), forControlEvents: .TouchUpInside)
    }
    
    func dismissBackpack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
