//
//  StringExtension.swift
//  Pintu
//
//  Created by Roshan Mahanama on 16/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import Foundation


extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}