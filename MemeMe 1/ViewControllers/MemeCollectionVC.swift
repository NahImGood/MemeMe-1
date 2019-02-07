//
//  MemeCollectionViewController.swift
//  MemeMe 1
//
//  Created by Eli Warner on 1/31/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    //MARK: Properties
    private var reuseIdentifier = "memeCell"
    var memes: [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if memes.count == 0 {
            setEmptyMessage("There are no Memes at this time! Go Make Some!")
            print("\(memes.count)")
        } else {
            restore()
            print("\(memes.count)")
        }
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeMeDetailVC") as! MemeDetailVC
        detailViewController.memes = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeMeCell
        print(indexPath.row)
        let meme = memes[indexPath.row]
        cell.bottomLabel.text = meme.bottomTextField
        cell.topLabel.text = meme.topTextField
        cell.memeImage.image = meme.originalImage
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth, height: collectionWidth/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir-Light", size: 18)
        messageLabel.sizeToFit()
        
        collectionView.backgroundView = messageLabel;
    }
    
    func restore() {
        collectionView.backgroundView = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
