//
//  SimulationManager.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import AppKit
import GameplayKit

protocol Simulation {
    func start()
    func stop()
}

class SimulationManager {
    
    private var simulationInProgress = false
    private var gaussRandomizerX: GKGaussianDistribution!
    private var gaussRandomizerY: GKGaussianDistribution!
    private var simulationTimer: NSTimer!
    
    private var preferences: Preferences

    init(preferences: Preferences) {
        self.preferences = preferences
        startObservingPreferencesChanges()
    }
    
    deinit {
        stopObservingPreferencesChanges()
    }
    
    // observing preference changes
    
    private func startObservingPreferencesChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(restart), name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    private func stopObservingPreferencesChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
    }
}
    // MARK: - Public
    
extension SimulationManager: Simulation {
    
    func start() {
        guard self.simulationInProgress == false else  {
            return
        }
        
        /* DEBUG
        print("START")
        if preferences.shouldMaximiseXcode {
            print("will maximize Xcode")
        }
        if preferences.shouldMoveMouse {
            print("will move mouse")
        }
        if preferences.shouldScroll {
            print("will scroll")
        }
        if preferences.shouldSwitchMainTabs {
            print("will switch main tabs")
        }
        if preferences.shouldSwitchNavigatorTabs {
            print("will switch navigator tabs")
        }
        if preferences.shouldSwitchInspectorTabs {
            print("will switch inspector tabs")
        }
        if preferences.shouldToggleDebugConsole {
            print("will toggle debug console")
        }
        */
        
        simulationInProgress = true
        gaussRandomizerX = GKGaussianDistribution(lowestValue: 0, highestValue: Int(screenSize().width))
        gaussRandomizerY = GKGaussianDistribution(lowestValue: 0, highestValue: Int(screenSize().height))
        simulationTimer = NSTimer(timeInterval: 10.0, target: self, selector: #selector(SimulationManager.tick), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(simulationTimer, forMode: NSDefaultRunLoopMode)
    }
    
    func stop() {
        guard self.simulationInProgress == true else  {
            return
        }

        if let timer = simulationTimer where timer.valid == true {
            timer.invalidate()
            simulationTimer = nil
        }
        
        simulationInProgress = false
        gaussRandomizerX = nil
        gaussRandomizerY = nil
    }
    
    @objc func restart() {
        guard simulationInProgress == true else {
            return
        }
        
        stop()
        start()
    }
    
    @objc private func tick() {
        let x = gaussRandomizerX.nextInt()
        let y = gaussRandomizerY.nextInt()
        
        if preferences.shouldMaximiseXcode {
            makeFullScreen()
        }
        
        if preferences.shouldMoveMouse {
            moveMouse(x, y)
        }
        
        if preferences.shouldScroll && x % 4 == 0 {
            let direction = (y % 2 == 0) ? ScriptsBuilder.ScrollDirection.Down : ScriptsBuilder.ScrollDirection.Up
            scroll(direction)
        }

        if preferences.shouldSwitchMainTabs && y % 3 == 0 {
            switchMainTab()
        }
        
        if preferences.shouldSwitchNavigatorTabs && x % 5 == 0 {
            let tab = navigatorTabFromRandomInt(y)
            switchNavigator(tab)
        }

        if preferences.shouldSwitchInspectorTabs && x % 6 == 0 {
            let tab = inspectorTabFromRandomInt(y)
            switchInspector(tab)
        }

        if preferences.shouldToggleDebugConsole && y % 4 == 0 {
            toggleDebugConsole()
        }
    }
}

// MARK: - Basic actions

private extension SimulationManager {

    func makeFullScreen() {
        ScriptsBuilder.build(.FullScreen).execute()
    }
    
    func moveMouse(x: Int, _ y: Int) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.PositionX: x,
             ScriptsBuilder.ArgsKey.PositionY: y]
        ScriptsBuilder.build(.MoveMouse, args: args).execute()
    }
    
    func click(x: Int, _ y: Int) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.PositionX: x,
             ScriptsBuilder.ArgsKey.PositionY: y]
        ScriptsBuilder.build(.Click, args: args).execute()
    }
    
    func scroll(direction: ScriptsBuilder.ScrollDirection) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.ScrollDirection: ScriptsBuilder.ScrollDirection.Down]
        ScriptsBuilder.build(.Scroll, args: args).execute()
    }

    func switchMainTab() {
        ScriptsBuilder.build(.SwitchMainTab).execute()
    }
    
    func switchNavigator(tab: ScriptsBuilder.NavigatorTab) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.NavigatorTab: tab]
        ScriptsBuilder.build(.SwitchNavigatorTab, args: args).execute()
    }
    
    func switchInspector(tab: ScriptsBuilder.InspectorTab) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.InspectorTab: tab]
        ScriptsBuilder.build(.SwitchInspectorTab, args: args).execute()
    }

    func toggleDebugConsole() {
        ScriptsBuilder.build(.ToggleDebugConsole).execute()
    }
}

// MARK: - Helpers

private extension SimulationManager {
    
    func screenSize() -> CGSize {
        if let firstScreen = NSScreen.screens()?.first {
            return firstScreen.visibleFrame.size
        } else {
            print("No screen found")
            // TODO: get rid of magic numbers
            return CGSize(width: 1920, height: 1080)
        }
    }
    
    func navigatorTabFromRandomInt(value: Int) -> ScriptsBuilder.NavigatorTab {
        if let tab = ScriptsBuilder.NavigatorTab(rawValue: value % 9 ) {
            return tab
        } else {
            return ScriptsBuilder.NavigatorTab.Project
        }
    }

    func inspectorTabFromRandomInt(value: Int) -> ScriptsBuilder.InspectorTab {
        if let tab = ScriptsBuilder.InspectorTab(rawValue: value % 9 ) {
            return tab
        } else {
            return ScriptsBuilder.InspectorTab.File
        }
    }
}