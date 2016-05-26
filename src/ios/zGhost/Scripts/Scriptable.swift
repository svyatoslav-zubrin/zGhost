//
//  Scriptable.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation

protocol Scriptable {
    func execute()
}

extension NSAppleScript: Scriptable {
    func execute() {
        var errorDict: NSDictionary? = nil
        self.executeAndReturnError(&errorDict)
        if let errorDict = errorDict {
            print("Error executing script: \(errorDict)")
        } else {
            print("Script executed")
        }
    }
}