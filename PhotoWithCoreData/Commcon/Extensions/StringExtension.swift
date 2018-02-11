//
//  ViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 11..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//
import UIKit
import Foundation

extension String {
    
    /* 라인 넘버 구하기 */
    func lines(font : UIFont, width : CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil);
        return Int(boundingBox.height/font.lineHeight);
    }
    
    /* 지역화 문구 arg 전달 */
    func localizeWithFormat( args: CVarArg...) -> String {
        return String(format: self, arguments: args)
    }
    
    /* 폰트 기준으로 width 구하기 */
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    /* 폰트 기준으로 height 구하기 */
    func height(withConstraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
     }
}
