//
//  PopupMenuViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit

class PopupMenuViewController: UIViewController {

    private var tableViewRowHeight: CGFloat = 37
    private let topInset: CGFloat = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PopupMenuTableViewCell.self, forCellReuseIdentifier: "PopupMenuTableViewCell")
        return tableView
    }()
    
    lazy var btnBg: UIButton = {
       let button = UIButton(frame: self.view.frame)
           button.backgroundColor = UIColor.black.withAlphaComponent(0.0)
           button.addTarget(self, action: #selector(closePopupAni), for: .touchUpInside)
           return button
    }()
    
    //-- 풀다운 뷰 설정
    private let menuHeight : CGFloat = 37 //메뉴 높이
    private var menuWidth : CGFloat = 0 //메뉴 넖이
    private var menuBgHeight: CGFloat = 0
    private var menuBgWidth: CGFloat = 0 
    private var senderObject : UIView?
    private var senderPoint : CGPoint?
    private var leftSpace : CGFloat = 0
    
    lazy var viewPullDown: UIView = {
         let viewPullDown = UIView(frame: .zero)
        viewPullDown.backgroundColor = UIColor.white
        viewPullDown.layer.cornerRadius = 3
        viewPullDown.clipsToBounds = true
        return viewPullDown
    }()
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
 
    convenience init(sender:  AnyObject? = nil) {
         self.init(nibName: nil, bundle: nil)
  
        tableViewRowHeight = 37
      
        senderObject = (sender as! UIBarButtonItem).value(forKey: "view") as? UIView
         senderPoint  = senderObject?.convert((senderObject?.frame)!.origin, to: super.view)
     
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addAction(_ action: PopupMenuAction) {
        actions.append(action)
        
            // 메뉴명이 길거나,짧을 때를 위해
            if menuWidth < (action.title?.width(withConstraintedHeight: menuHeight, font: UIFont.systemFont(ofSize: 15, weight: .regular)))! {
                menuWidth =  (action.title?.width(withConstraintedHeight: menuHeight, font: UIFont.systemFont(ofSize: 15, weight: .regular)))!
                menuBgWidth  = menuWidth + 42
            }
            menuBgHeight  = CGFloat( (actions.count * Int(menuHeight)))

            let bottomSpace =   ((senderObject?.frame.height)! + (senderPoint?.y)!) - (senderObject?.frame.maxY)!
            leftSpace =   ((senderObject?.frame.width)! + (senderPoint?.x)!) -  (senderObject?.frame.maxX)!
            viewPullDown.frame = CGRect(x: leftSpace  ,
                                        y: bottomSpace + (senderObject?.frame.size.height)!,
                                        width: 0,
                                        height: 0)

    }
    
    var actions: [PopupMenuAction] = [] {
        didSet {
            var calculatedActions: [PopupMenuAction] = []
            for action in actions {
                
                    calculatedActions.append(action)
               
            }
           actions = calculatedActions
         
        }
    }
 
    var preferredAction: PopupMenuAction?
 
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if traitCollection.userInterfaceIdiom == .phone {
            return .portrait
        }
        
        return super.preferredInterfaceOrientationForPresentation
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if traitCollection.userInterfaceIdiom == .phone {
            return .portrait
        }
        
        return super.supportedInterfaceOrientations
    }
}

extension PopupMenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
            view.addSubview(btnBg)
            viewPullDown.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: viewPullDown.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: viewPullDown.bottomAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: viewPullDown.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: viewPullDown.rightAnchor).isActive = true
            view.addSubview(viewPullDown)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPopupAni()
     }
    
    func showPopupAni(){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            self.btnBg.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.viewPullDown.frame = CGRect(x: self.leftSpace - self.menuWidth ,
                                             y: self.viewPullDown.frame.origin.y,
                                             width: self.menuBgWidth,
                                             height: self.menuBgHeight)
        }, completion: nil)
    }
    
    @objc func closePopupAni(_ action: PopupMenuAction? = nil){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            self.btnBg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.viewPullDown.frame = CGRect(x: self.leftSpace ,
                                             y: self.viewPullDown.frame.origin.y,
                                             width: 0,
                                             height: 0)
        }, completion: {_ in
            self.dismiss(animated: false, completion: {
                guard action != nil && (action?.isKind(of: PopupMenuAction.self))! else{
                    return
                }
                action?.handler?(action!)
            })
        })
    }
    
}

extension PopupMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupMenuTableViewCell", for: indexPath) as! PopupMenuTableViewCell
        
        let action = actions[indexPath.row]
        cell.titleLabel.attributedText = action.attributedString
        return cell
    }
}

extension PopupMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        closePopupAni(action)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
}
