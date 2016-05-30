//
//  EventsFrequencyTextTransformer.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/30/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation

@objc(EventsFrequencyTextTransformer) internal class EventsFrequencyTextTransformer: NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.classForCoder()
    }
    
    internal override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let value = value {
            return "\(value) secs"
        } else {
            return ""
        }
    }
}
