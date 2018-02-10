//
//  StoryListViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit

class StoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTitle()
    }
}

extension StoryListViewController{
    @IBAction func touchedAddStory(_ sender: Any) {
        let viewController: CameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(viewController, animated: true)
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
    
    func setTitle(){
        self.navigationItem.title = "스토리 (10)"
    }
}
extension StoryListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

extension StoryListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
      
    }
}

extension StoryListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension StoryListViewController: UITableViewDelegate{
    
}


