//
//  LinguaboardTableViewController.swift
//  Linguaboard
//
//  Created by Omar Abbasi on 2017-02-13.
//  Copyright © 2017 Omar Abbasi. All rights reserved.
//

import UIKit

class LinguaboardTableViewController: UITableViewController {

    // 0 == nil
    // 1 == true
    // 2 == false
    
    // TODO
    // update switches based on UserDefaults when loading app
    
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet var darkModeSwitch: UISwitch!
    @IBOutlet var whiteMinimalMode: UISwitch!
    @IBOutlet var darkMinimalMode: UISwitch!
    @IBOutlet var keyBackgroundSwitch: UISwitch!
    @IBOutlet var spaceDoubleTapSwitch: UISwitch!
    
    // sample key
    @IBOutlet var blurBG: UIVisualEffectView!
    @IBOutlet var background: UIView!
    @IBOutlet var key: UIButton!

    @IBAction func darkModeAction(_ sender: Any) {
        
        if darkModeSwitch.isOn && darkModeSwitch.isEnabled {
            
            // dark blur on
            
            whiteMinimalMode.isEnabled = false
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = false
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            darkModeBool.set(1, forKey: "darkBool")
            darkModeBool.synchronize()
            
            loadColours("darkMode")
            setColors()
            
        } else if !(darkModeSwitch.isOn) && darkModeSwitch.isEnabled {
            
            // dark blur off
            
            whiteMinimalMode.isEnabled = true
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = true
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            darkModeBool.set(2, forKey: "darkBool")
            darkModeBool.synchronize()
            
            loadColours("whiteMode")
            setColors()
            
        }
        
    }
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var keyBackgroundBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var spaceDoubleTapBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var firstRemeberedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var secondRemeberedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var lastUsedLanguage: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    
    var keyBackgroundColor: UIColor = UIColor.white
    var keyPopUpColor: UIColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
    var bgColor: UIColor = UIColor.clear
    var blurEffect: UIBlurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
    
    var currentlyUsedColor = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.darkMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        self.whiteMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        self.keyBackgroundSwitch.addTarget(self, action: #selector(self.keyBackground(_:)), for: .touchUpInside)
        self.spaceDoubleTapSwitch.addTarget(self, action: #selector(self.spaceDoubleTap(_:)), for: .touchUpInside)
        loadInterface()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInterface() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let launchAlert = UIAlertController(title: "First Time Launch", message: "Hello, there! Remember to \"Allow Full Access\" under your Settings app in General > Keyboard > Add New Keyboard. Select Linguaboard, and enable \"Allow Full Access\" ", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            launchAlert.addAction(action)
            self.present(launchAlert, animated: true, completion: nil)
        }
        
        let darkMode = darkModeBool.double(forKey: "darkBool")
        let whiteMinimal = whiteMinimalBool.double(forKey: "whiteMinimalBool")
        let darkMinimal = darkMinimalModeBool.double(forKey: "darkMinimalBool")
        let keyBackground = keyBackgroundBool.double(forKey: "keyBackgroundBool")
        let spaceDoubleTapDouble = spaceDoubleTapBool.double(forKey: "spaceDoubleTapBool")
        
        if darkMode == 1 {
            
            darkModeSwitch.isOn = true
            darkModeSwitch.isEnabled = true
            
            whiteMinimalMode.isOn = false
            whiteMinimalMode.isEnabled = false
            darkMinimalMode.isOn = false
            darkMinimalMode.isEnabled = false
            
            loadColours("darkMode")
            setColors()
            
        } else if whiteMinimal == 1 {
            
            whiteMinimalMode.isOn = true
            whiteMinimalMode.isEnabled = true
            
            darkModeSwitch.isOn = false
            darkModeSwitch.isEnabled = false
            darkMinimalMode.isOn = false
            darkMinimalMode.isEnabled = false
            
            loadColours("whiteMinimal")
            setColors()
            
        } else if darkMinimal == 1 {
            
            darkMinimalMode.isOn = true
            darkMinimalMode.isEnabled = true
            
            darkModeSwitch.isOn = false
            darkModeSwitch.isEnabled = false
            whiteMinimalMode.isOn = false
            whiteMinimalMode.isEnabled = false
            
            loadColours("darkMinimal")
            setColors()
            
        } else {
            
            darkMinimalMode.isOn = false
            darkMinimalMode.isEnabled = true
            darkModeSwitch.isOn = false
            darkModeSwitch.isEnabled = true
            whiteMinimalMode.isOn = false
            whiteMinimalMode.isEnabled = true
            
            loadColours("whiteMode")
            setColors()
            
        }
        
        if keyBackground == 1 {
            
            keyBackgroundSwitch.isOn = true
            keyBackgroundSwitch.isEnabled = true
            
        } else {
            
            keyBackgroundSwitch.isOn = false
            keyBackgroundSwitch.isEnabled = true
            
        }
        
        if spaceDoubleTapDouble == 1 {
            
            spaceDoubleTapSwitch.isOn = true
            spaceDoubleTapSwitch.isEnabled = true
            
        } else {
            
            spaceDoubleTapSwitch.isOn = false
            spaceDoubleTapSwitch.isEnabled = true
            
        }
        
    }
    
    func loadColours(_ thingToLoad: String) {
        
        if thingToLoad == "darkMode" {
            // dark blur mode
            currentlyUsedColor = "darkMode"
            self.keyPopUpColor = UIColor.white
            self.keyBackgroundColor = UIColor.clear // UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            self.blurBG.isHidden = false
        } else if thingToLoad == "darkMinimal" {
            currentlyUsedColor = "darkMinimal"
            self.keyPopUpColor = UIColor.white
            self.keyBackgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.bgColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMinimal" {
            currentlyUsedColor = "whiteMinimal"
            self.keyPopUpColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.keyBackgroundColor = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0)
            self.bgColor = UIColor.white
            self.blurBG.isHidden = true
        } else if thingToLoad == "whiteMode" {
            // white blur mode
            currentlyUsedColor = "whiteMode"
            self.keyPopUpColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
            self.keyBackgroundColor = UIColor.white
            self.bgColor = UIColor.clear
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
            self.blurBG.isHidden = false
        }
        
    }
    
    func setColors() {
        
        let keyBackground = keyBackgroundBool.double(forKey: "keyBackgroundBool")
        
        if keyBackground == 1 {
            
            key.backgroundColor = keyBackgroundColor
            
        } else if keyBackground == 2 {
            
            key.backgroundColor = UIColor.clear
            
        } else {
            
            key.backgroundColor = UIColor.clear
            
        }
        
        background.backgroundColor = bgColor
        background.layer.borderColor = UIColor.gray.cgColor
        background.layer.borderWidth = 0.5
        blurBG.effect = blurEffect
        blurBG.layer.cornerRadius = 15
        blurBG.clipsToBounds = true
        key.setTitleColor(keyPopUpColor, for: .normal)
        key.layer.cornerRadius = 6
        key.tintColor = keyPopUpColor
        
    }
    
    func spaceDoubleTap(_ sender: UISwitch) {
        
        if sender == spaceDoubleTapSwitch {
            
            if sender.isOn && sender.isEnabled {
                
                spaceDoubleTapBool.set(1, forKey: "spaceDoubleTapBool")
                spaceDoubleTapBool.synchronize()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                spaceDoubleTapBool.set(2, forKey: "spaceDoubleTapBool")
                spaceDoubleTapBool.synchronize()
                
            }
            
        }
        
    }

    func keyBackground(_ sender: UISwitch) {
        
        if sender == keyBackgroundSwitch {
            
            if sender.isOn && sender.isEnabled {
                
                keyBackgroundBool.set(1, forKey: "keyBackgroundBool")
                keyBackgroundBool.synchronize()
                
                loadColours(currentlyUsedColor)
                setColors()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                keyBackgroundBool.set(2, forKey: "keyBackgroundBool")
                keyBackgroundBool.synchronize()
                
                loadColours(currentlyUsedColor)
                setColors()
                
            }
            
        }
        
    }
    
    func minimalMode(_ sender: UISwitch) {
        
        if sender == whiteMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                // white mode on
                
                darkMinimalMode.isEnabled = false
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                whiteMinimalBool.set(1, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                loadColours("whiteMinimal")
                setColors()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                // white mode off
                
                darkMinimalMode.isEnabled = true
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                whiteMinimalBool.set(2, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                loadColours("whiteMode")
                setColors()
                
            }
            
            
        } else if sender == darkMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                // dark mode on
                
                whiteMinimalMode.isEnabled = false
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                darkMinimalModeBool.set(1, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                loadColours("darkMinimal")
                setColors()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                // dark mode off
                
                whiteMinimalMode.isEnabled = true
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                darkMinimalModeBool.set(2, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                loadColours("whiteMode")
                setColors()
                
            }
            
        }
        
    }

}
