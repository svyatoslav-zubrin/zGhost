//
//  PreferencesWindowController.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/30/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    var preferencesManager: Preferences!
    
    @IBOutlet var userDefaults: NSUserDefaultsController!
    
    @IBOutlet weak var mouseMoveButton: NSButton!
    @IBOutlet weak var mouseClickButton: NSButton!
    @IBOutlet weak var mouseScrollButton: NSButton!
    @IBOutlet weak var maximiseXcodeButton: NSButton!
    @IBOutlet weak var switchMainTabButton: NSButton!
    @IBOutlet weak var SwitchNavTabButton: NSButton!
    @IBOutlet weak var switchUtilsTabButton: NSButton!
    @IBOutlet weak var toggleConsoleButton: NSButton!
    @IBOutlet weak var eventsFrequencySlider: NSSlider!
    @IBOutlet weak var eventsFrequencyLabel: NSTextField!
    
    let unsupportedSetting = false
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.delegate = self
        
        setupUserDefaults()
    }
}

extension PreferencesWindowController: NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        userDefaults.revert(nil)
    }
}

private extension PreferencesWindowController {
    
    func setupUserDefaults() {
        userDefaults.initialValues = preferencesManager.defaults
        userDefaults.appliesImmediately = false
    }
}
