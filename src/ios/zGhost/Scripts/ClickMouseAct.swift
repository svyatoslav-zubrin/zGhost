//
//  ClickMouseAct.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import ApplicationServices

struct ClickMouseAct: Scriptable {
    
    let position: CGPoint
    
    func execute() {
        let eventDown = CGEventCreateMouseEvent(nil, .LeftMouseDown, position, .Left)
        let eventUp = CGEventCreateMouseEvent(nil, .LeftMouseUp, position, .Left)
        CGEventPost(CGEventTapLocation.CGHIDEventTap, eventDown)
        CGEventPost(CGEventTapLocation.CGHIDEventTap, eventUp)
    }
}