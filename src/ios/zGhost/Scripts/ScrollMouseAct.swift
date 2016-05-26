//
//  ScrollMouseAct.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import ApplicationServices

struct ScrollMouseAct: Scriptable {
    
    let wheel: Int32
    
    func execute() {
        let event = CreateScrollWheelEvent(nil, CGScrollEventUnit.Line, wheel)
        CGEventPost(.CGHIDEventTap, event)
    }
}
