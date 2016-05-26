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

class SimulationManager {
    
    var simulationInProgress = false
    var gaussRandomizerX: GKGaussianDistribution!
    var gaussRandomizerY: GKGaussianDistribution!
    var simulationTimer: NSTimer!
}
    // MARK: - Public
    
extension SimulationManager {
        
    func start() {
        guard self.simulationInProgress == false else  {
            return
        }
        
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
    
    @objc func tick() {
        let x = gaussRandomizerX.nextInt()
        let y = gaussRandomizerY.nextInt()
        
        moveMouse(x, y)

        if y % 3 == 0 {
            switchMainTab()
        }
        
        if x % 5 == 0 {
            let tab = navigatorTabFromRandomInt(y)
            switchNavigator(tab)
        }
        
        if x % 4 == 0 {
            let direction = (y % 2 == 0) ? ScriptsBuilder.ScrollDirection.Down : ScriptsBuilder.ScrollDirection.Up
            scroll(direction)
        }
    }
}

// MARK: - Basic actions

private extension SimulationManager {

    func makeFullScreen() {
        ScriptsBuilder.build(.FullScreen).execute()
    }
    
    func switchMainTab() {
        ScriptsBuilder.build(.SwitchMainTab).execute()
    }
    
    func switchNavigator(tab: ScriptsBuilder.NavigatorTab) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.NavigatorTab: tab]
        ScriptsBuilder.build(.SwitchNavigatorTab, args: args).execute()
    }

    func moveMouse(x: Int, _ y: Int) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.PositionX: x,
             ScriptsBuilder.ArgsKey.PositionY: y]
        ScriptsBuilder.build(.MoveMouse, args: args).execute()
    }
    
    func click() {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.PositionX: 500,
             ScriptsBuilder.ArgsKey.PositionY: 500]
        ScriptsBuilder.build(.Click, args: args).execute()
    }
    
    func scroll(direction: ScriptsBuilder.ScrollDirection) {
        let args: Dictionary<ScriptsBuilder.ArgsKey, Any> =
            [ScriptsBuilder.ArgsKey.ScrollDirection: ScriptsBuilder.ScrollDirection.Down]
        ScriptsBuilder.build(.Scroll, args: args).execute()
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
}