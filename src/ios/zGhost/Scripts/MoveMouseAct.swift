//
//  MoveMouseAct.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import ApplicationServices

struct MoveMouseAct: Scriptable {
    
    let position: CGPoint
    
    func execute() {
        let event = CGEventCreateMouseEvent(nil, .MouseMoved, position, .Left)
        CGEventPost(CGEventTapLocation.CGHIDEventTap, event)
    }
}