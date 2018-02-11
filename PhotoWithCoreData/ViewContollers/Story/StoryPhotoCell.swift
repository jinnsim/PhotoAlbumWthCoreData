//
//  StoryPhotoCell.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit
import CoreData
typealias ShowImage = (Int) -> Void
class StoryPhotoCell: UITableViewCell {
    var showImage: ShowImage?
    let collectionCellWidthSize = 80
    let collectionCellHeightSize = 90
    
    lazy var storyPhotoCollecitonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 80, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(StoryPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "StoryPhotoCollectionViewCell")
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var constratinsTvCollectionView:[NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.storyPhotoCollecitonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0))
        constraints.append(self.storyPhotoCollecitonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0))
        constraints.append(self.storyPhotoCollecitonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0))
        constraints.append(self.storyPhotoCollecitonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0))
        constraints.append(self.storyPhotoCollecitonView.heightAnchor.constraint(equalToConstant: 90))
        return constraints
    }()
    
    var story: Photos?{
        didSet{
           settingView()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
extension StoryPhotoCell{
    func settingView(){
        self.selectionStyle = .none
        self.addSubview(storyPhotoCollecitonView)
        NSLayoutConstraint.activate(constratinsTvCollectionView)
        storyPhotoCollecitonView.reloadData()
        
    }
}
extension StoryPhotoCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
}
extension StoryPhotoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: (story?.photo!)!) as? [Data] else {
            return 0
        }
            return decodedArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoryPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryPhotoCollectionViewCell", for: indexPath) as! StoryPhotoCollectionViewCell
        guard let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: (story?.photo!)!) as? [Data] else {
            return cell
        }
        cell.model = story
        cell.thumbnailImageView.image = UIImage(data: decodedArray[indexPath.row])
        return cell
    }
}

extension StoryPhotoCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      self.showImage?(indexPath.row)
    }
    
}
