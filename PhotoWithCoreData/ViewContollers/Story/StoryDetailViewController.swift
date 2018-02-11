//
//  StoryDetailViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 11..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit
import CoreData

class StoryDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    fileprivate let coreDataManager = CoreDataManager(modelName: "Story")
    
    var isEditMode = true
    var story: Photos?
    var fetch: NSFetchedResultsController<Photos>?
    lazy var menuButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(popupMenu))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StoryPhotoCell.self, forCellReuseIdentifier: "StoryPhotoCell")
        self.navigationItem.rightBarButtonItem = menuButton
        menuButton.title = "Action"
    }

}
extension StoryDetailViewController{
    @objc func popupMenu(){
        let popupMenu = PopupMenuViewController(sender: menuButton as AnyObject)
        
       if isEditMode == false {
            let action = PopupMenuAction(title: "편집") { (action) in
                self.enableEditMode()
            }
            popupMenu.addAction(action) 
        
       }else{
            let action = PopupMenuAction(title: "저장") { (action) in
                self.save()
                self.navigationController?.popViewController(animated: true)
            }
            popupMenu.addAction(action)
        }
        let action = PopupMenuAction(title: "취소") { (action) in
            if self.isEditMode == false {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.enableEditMode()
            }
        }
        popupMenu.addAction(action)
        
        present(popupMenu, animated: false, completion: nil)
        
    }
    
    @objc func save(){

        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! StoryDetailCell
        let newStory = Photos(context: coreDataManager.managedObjectContext)
        
        newStory.content = cell.memoTextBox.text
        newStory.title = cell.titleTextField.text
        newStory.updatedAt = Date().updateDate()
        newStory.createdAt = story?.createdAt != nil ?  story?.createdAt : Date().yearAndMonth()  
        newStory.photo = self.story?.photo
        
        do {
            try newStory.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Note")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        
        if fetch != nil {
            // Delete
            fetch?.managedObjectContext.delete(self.story!)
            try? fetch?.managedObjectContext.save()
        }
       
    }
    
    func enableEditMode(){
        isEditMode = !isEditMode
        tableView.reloadData()
    }
  
}
private enum CellType: Int {
    case Photos
    case Memo
}

extension StoryDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: (story?.photo)! ) as? [Data] {
            return "\(decodedArray.count)개의 사진"
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case CellType.Photos.rawValue:
             return 90
        default:
            return 350
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
       case CellType.Photos.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryPhotoCell", for: indexPath) as! StoryPhotoCell
                cell.story = story
                cell.showImage = {(index) in
                if var decodedArray = NSKeyedUnarchiver.unarchiveObject(with: (self.story?.photo!)!) as? [Data] {
                    let image = UIImage(data: decodedArray[index])
                    let storyboard = UIStoryboard(name: "Story", bundle: nil)
                    let showImageController = storyboard.instantiateViewController(withIdentifier: "StoryShowImageViewController") as! StoryShowImageViewController
                         showImageController.image = image
                         showImageController.index = index
                         showImageController.deletePhoto = { (index) in
                         decodedArray.remove(at: index)
                         self.story?.photo = NSKeyedArchiver.archivedData(withRootObject:decodedArray)
                         self.tableView.reloadData()
                         self.save()
                    }
                    self.present(showImageController, animated: true)
                    
                }
            }
            return cell
        default:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailCell", for: indexPath) as! StoryDetailCell
            cell.titleTextField.text = story?.title
            cell.memoTextBox.text = story?.content == nil ? "메모를 입력하세요." : story?.content
            
            cell.titleTextField.isUserInteractionEnabled = isEditMode
            cell.memoTextBox.isUserInteractionEnabled = isEditMode
            
        return cell
      }
    
    }
}

extension StoryDetailViewController: UITableViewDelegate{
    
}
