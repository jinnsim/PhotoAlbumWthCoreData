//
//  StoryShowImageViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 11..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit
typealias DeletePhoto = (Int) -> Void
class StoryShowImageViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var image: UIImage!
    var deletePhoto: DeletePhoto?
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         photoImageView.image = image
    }
}

extension StoryShowImageViewController{
    @IBAction func touchedDelete(_ sender: Any) {
        deletePhoto?(index)
        self.dismiss(animated: true)
    }
    
    @IBAction func tabedView(_ sender: Any) {
        self.dismiss(animated: true)
    } 
}

