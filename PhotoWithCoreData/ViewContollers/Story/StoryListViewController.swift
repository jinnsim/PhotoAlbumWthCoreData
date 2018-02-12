//
//  StoryListViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit
import CoreData

class StoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchText: String? = nil
    
    let searchController = UISearchController(searchResultsController: nil)
 
    // MARK: -
    
    fileprivate let coreDataManager = CoreDataManager(modelName: "Story")
    
    // MARK: -
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Photos> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
       
        // Add Sort Descriptors
        let FirstSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let SecondSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [FirstSortDescriptor,SecondSortDescriptor]
      
       // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: "createdAt", cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFetchRequest()
        tableView.reloadData()
    }
    
}

extension StoryListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
        switch (type) {
        case .insert: 
            break;
        case .delete:
            let indexSet: IndexSet = [(indexPath?.section)!]
            
            if tableView.numberOfRows(inSection: (indexPath?.section)!) == 1 {
               tableView.deleteSections(indexSet, with: .none)
                
            }else{
                tableView.reloadSections(indexSet, with: .none)
            }
            break;
        case .update:
            break;
        case .move:
            break;
        }
    }
    
}

extension StoryListViewController{
    @IBAction func touchedAddStory(_ sender: Any) {
        let viewController: CameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        viewController.createStory = { (photos) in
             self.detailStory(photos,true)
        }
        self.present(viewController, animated: true)
    }
    func detailStory(_ story: Photos, _ isEditMode: Bool, fetch: NSFetchedResultsController<Photos>? = nil) {
     let storyboard = UIStoryboard(name: "Story", bundle: nil)
     let storyDetail = storyboard.instantiateViewController(withIdentifier: "StoryDetailViewController") as! StoryDetailViewController
         storyDetail.story = story
         storyDetail.isEditMode = isEditMode
         storyDetail.fetch = fetch
    self.navigationController?.pushViewController(storyDetail, animated: true)
    }
    
    func loadFetchRequest(){
        if searchText != nil {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", searchText!, searchText!)
        }else{
             fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func setSearchController(){
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어을 입력해 주세요."
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            //MARK: 지원하지 않는 버전 처리
        }
        definesPresentationContext = true
    }
}

extension StoryListViewController: UISearchBarDelegate {
 
}

extension StoryListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let count: Int = (searchBar.text?.count)!
        if count > 0 {
            self.searchText = searchBar.text
        }else{
            self.searchText = nil
        }
        loadFetchRequest()
        tableView.reloadData()
    }
}


extension StoryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            if let totalCount = fetchedResultsController.fetchedObjects?.count {
                super.navigationItem.title = "스토리 (\(totalCount))"
            }
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
         let story = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
         let sections = fetchedResultsController.sections
         let sectionInfo = sections![section]
     
        return story.createdAt! + "(\(sectionInfo.numberOfObjects))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections    {
            let sectionInfo = sections[section]
            if sectionInfo.numberOfObjects > 0 {
                 return sectionInfo.numberOfObjects
            }
           return 0
        }
         return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryListTableVewCell", for: indexPath) as! StoryListTableViewCell
        cell.titleLabel.text = nil
        cell.updatedLabel.text = nil
        cell.thumbnailImage.image = nil
        
        // Configure Cell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
         let story = fetchedResultsController.object(at: indexPath)
        // Delete
         fetchedResultsController.managedObjectContext.delete(story)
         try? fetchedResultsController.managedObjectContext.save()
    }
    
    func configureCell(_ cell: StoryListTableViewCell, at indexPath: IndexPath) {
        let story = fetchedResultsController.object(at: indexPath)
        // Configure Cell
        cell.titleLabel.text = story.title
        cell.updatedLabel.text = story.updatedAt?.description
        guard story.photo != nil else{
            return
        }
        if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: story.photo!) as? [Data] {
            cell.thumbnailImage.image = UIImage(data: decodedArray[0] )
        }
       
        
    }
    
}

extension StoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        detailStory(fetchedResultsController.object(at: indexPath),false, fetch: fetchedResultsController )
    }
    
} 

