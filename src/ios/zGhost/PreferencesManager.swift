//
//  PreferencesManager.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/27/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import AppKit

class PreferencesManager {

    private var prefsWindowController: NSWindowController?
    
    func showPreferences() {
        prefsWindowController = NSWindowController(windowNibName: "Settings")
        if let prefsWindowController = prefsWindowController {
            prefsWindowController.showWindow(nil)
        }
    }
}