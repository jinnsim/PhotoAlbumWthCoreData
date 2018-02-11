//
//  PopMenuAction.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit

class PopupMenuAction: NSObject {
 
        override init() {
            super.init()
        }
        
        convenience init(title: String?, handler: ((PopupMenuAction) -> Void)? = nil) {
            self.init()
            
            self.title = title
            self.handler = handler
        }
    
       var title: String?
        
        /// title 중에 포함된 String 이어야 합니다.
        /// title 중 이 부분만 highlight 되어 표시됩니다.
        var highlightedString: String?
        var highlightedColor = UIColor.blue
        
        var attributedString: NSAttributedString? {
            guard let title = title else { return nil }
            
            if let highlightedString = highlightedString, let substringRange = title.range(of: highlightedString) {
                let attrString = NSMutableAttributedString(string: title)
                attrString.addAttribute(.foregroundColor, value: highlightedColor, range: NSRange(substringRange, in: title))
                return attrString.copy() as? NSAttributedString
            }
            
            return NSAttributedString(string: title)
        }
    
        private(set) var handler: ((PopupMenuAction) -> Void)? = nil
 
}

