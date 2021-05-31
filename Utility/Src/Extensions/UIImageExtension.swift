//
//  UIImageExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 07/05/2018.
//

import UIKit

public extension UIImage {
    
     func resizeImage(width: CGFloat, offset:CGFloat) -> UIImage? {
    
        let scale = width/self.size.width
        let height = self.size.height * scale
        
        let offsetSize = CGSize(width: width + offset, height: height + offset)
        
        UIGraphicsBeginImageContextWithOptions(offsetSize, false, 0.0)
        
        self.draw(in: CGRect(x: offset/2, y: offset/2, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}
