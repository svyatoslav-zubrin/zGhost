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

    let prefs: Preferences = PreferencesManager()
    
    private lazy var simulationManager: SimulationManager =
        { return SimulationManager(preferences: self.prefs) }()
    
    private var activated = false {
        didSet {
            activateMenuItem.title = activated ? "Deactivate" : "Activate"
            if activated {
                simulationManager.start()
            } else {
                simulationManager.stop()
            }
            setStatusIcon(activated)
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        activated = false
    }

    @IBAction func toggleActivation(sender: NSMenuItem) {
        activated = !activated
    }

    @IBAction func preferences(sender: NSMenuItem) {
        prefs.show()
    }

    @IBAction func quit(sender: NSMenuItem) {
        NSApp.terminate(nil)
    }
}

private extension AppDelegate {
    
    func setStatusIcon(active: Bool) {
        if active == true {
            if let icon = NSImage(named: "statusIcon-active") {
                statusItem.image = icon
                statusItem.menu = statusMenu
            }
        } else {
            if let icon = NSImage(named: "statusIcon") {
                icon.template = true
                statusItem.image = icon
                statusItem.menu = statusMenu
            }
        }
    }
}

