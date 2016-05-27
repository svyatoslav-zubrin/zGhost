//
//  AppDelegate.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/24/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var activateMenuItem: NSMenuItem!
    
    private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

    private let simulationManager = SimulationManager()
    private let prefsManager = PreferencesManager()
    
    private var activated = false {
        didSet {
            activateMenuItem.title = activated ? "Deactivate" : "Activate"
            if activated {
                simulationManager.start()
            } else {
                simulationManager.stop()
            }
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let icon = NSImage(named: "statusIcon") {
            icon.template = true
            statusItem.image = icon
            statusItem.menu = statusMenu
            activated = false
        }
    }

    @IBAction func toggleActivation(sender: NSMenuItem) {
        activated = !activated
    }

    @IBAction func preferences(sender: NSMenuItem) {
        prefsManager.showPreferences()
    }

    @IBAction func quit(sender: NSMenuItem) {
        NSApp.terminate(nil)
    }
}

