//
//  StoryPhotoCollectionViewCell.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit 
class StoryPhotoCollectionViewCell: UICollectionViewCell {
    let imgThumbnailKeyPath = \StoryPhotoCollectionViewCell.thumbnailImageView
    let thumbnailImageView: UIImageView   = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        return imageView
    }()
    
    var constraintsThumbnailImageView: [NSLayoutConstraint]  {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26))
        constraints.append(self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)) 
        constraints.append(self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 64))
        constraints.append(self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 64))
       
        return constraints
    }
    
    
    
    var model: Photos? {
        didSet{
            self.addSubview(thumbnailImageView)
            NSLayoutConstraint.activate(constraintsThumbnailImageView)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

