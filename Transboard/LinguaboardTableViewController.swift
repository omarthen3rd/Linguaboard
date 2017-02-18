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
    
    @IBOutlet var darkModeSwitch: UISwitch!
    @IBOutlet var whiteMinimalMode: UISwitch!
    @IBOutlet var darkMinimalMode: UISwitch!
    @IBAction func darkModeAction(_ sender: Any) {
        
        if darkModeSwitch.isOn && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = false
            // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = false
            // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            // darkModeBool.set("true", forKey: "darkBool")
            darkModeBool.set(1, forKey: "darkBool")
            darkModeBool.synchronize()
            
        } else if !(darkModeSwitch.isOn) && darkModeSwitch.isEnabled {
            
            whiteMinimalMode.isEnabled = true
            // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
            whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
            whiteMinimalBool.synchronize()
            
            darkMinimalMode.isEnabled = true
            // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
            darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
            darkMinimalModeBool.synchronize()
            
            // darkModeBool.set("false", forKey: "darkBool")
            darkModeBool.set(2, forKey: "darkBool")
            darkModeBool.synchronize()
            
        }
        
    }
    
    var darkModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var whiteMinimalBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    var darkMinimalModeBool: UserDefaults = UserDefaults(suiteName: "group.Linguaboard")!
    
    var globalTintColor: UIColor = UIColor.white // UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0)
    var altGlobalTintColor: UIColor = UIColor.darkGray
    var backgroundColor: UIColor = UIColor.clear // UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    var blurEffect: UIBlurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.darkMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        self.whiteMinimalMode.addTarget(self, action: #selector(self.minimalMode(_:)), for: .touchUpInside)
        loadInterface()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInterface() {
        
        let darkMode = darkModeBool.double(forKey: "darkBool")
        let whiteMinimal = whiteMinimalBool.double(forKey: "whiteMinimalBool")
        let darkMinimal = darkMinimalModeBool.double(forKey: "darkMinimalBool")
        
        switch darkMode {
        case 1:
            darkModeSwitch.isOn = true
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
            self.globalTintColor = UIColor.white
            self.altGlobalTintColor = UIColor.darkGray
        case 2:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.darkGray
        case 0:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.darkGray
        default:
            print("")
        }
        
        switch whiteMinimal {
        case 1:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = true
            darkMinimalMode.isOn = false
            self.view.backgroundColor = UIColor.white
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 2:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 0:
            print("")
        default:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        }
        
        switch darkMinimal {
        case 1:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = true
            self.view.backgroundColor = UIColor.black
            self.globalTintColor = UIColor.white
            self.altGlobalTintColor = UIColor.darkGray
        case 2:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        case 0:
            print("")
        default:
            darkModeSwitch.isOn = false
            whiteMinimalMode.isOn = false
            darkMinimalMode.isOn = false
            self.blurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
            self.globalTintColor = UIColor.darkGray
            self.altGlobalTintColor = UIColor.white
        }
        
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            // tableView.backgroundColor = UIColor.clear
            let blurEffectView = UIVisualEffectView(effect: self.blurEffect)
            // tableView.backgroundView = blurEffectView
            
            // if you want translucent vibrant table view separator lines
            // tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        }
        
    }

    func minimalMode(_ sender: UISwitch) {
        
        if sender == whiteMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                print("ran white on")
                
                darkMinimalMode.isEnabled = false
                // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // whiteMinimalBool.set("true", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(1, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                loadInterface()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran white off")
                
                darkMinimalMode.isEnabled = true
                // darkMinimalModeBool.set("nil", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(0, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // whiteMinimalBool.set("false", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(2, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                loadInterface()
                
            }
            
            
        } else if sender == darkMinimalMode {
            
            if sender.isOn && sender.isEnabled {
                
                print("ran dark on")
                
                whiteMinimalMode.isEnabled = false
                // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = false
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // darkMinimalModeBool.set("true", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(1, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                loadInterface()
                
            } else if !(sender.isOn) && sender.isEnabled {
                
                print("ran dark off")
                
                whiteMinimalMode.isEnabled = true
                // whiteMinimalBool.set("nil", forKey: "whiteMinimalBool")
                whiteMinimalBool.set(0, forKey: "whiteMinimalBool")
                whiteMinimalBool.synchronize()
                
                darkModeSwitch.isEnabled = true
                // darkModeBool.set("nil", forKey: "darkBool")
                darkModeBool.set(0, forKey: "darkBool")
                darkModeBool.synchronize()
                
                // darkMinimalModeBool.set("false", forKey: "darkMinimalBool")
                darkMinimalModeBool.set(2, forKey: "darkMinimalBool")
                darkMinimalModeBool.synchronize()
                
                loadInterface()
                
            }
            
        }
        
    }

}
