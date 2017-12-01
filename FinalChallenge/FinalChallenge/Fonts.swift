//
//  Fonts.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 21/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation
import UIKit

struct FontLato {
    
    func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Medium", size: size)!
    }
    
    func italicFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Italic", size: size)!
    }
    
    func blackFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Black", size: size)!
    }
}


struct FontOstrich {
    func heavyFont (size: CGFloat) -> UIFont {
        return UIFont(name: "OstrichSans-Heavy", size: size)!
    }
}
