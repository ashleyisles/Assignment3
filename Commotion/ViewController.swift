//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.stepsSlider.setValue(newtotalSteps, animated: true)
                self.stepsLabel.text = "Steps: \(newtotalSteps)"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    
    
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.totalSteps = 0.0
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
//        self.startMotionUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Raw Motion Functions
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device 
        
        // TODO: should we be doing this from the MAIN queue? You will need to fix that!!!....
        if self.motion.isDeviceMotionAvailable{
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion as! CMDeviceMotionHandler)
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:NSError?){
        if let gravity = motionData?.gravity {
            let rotation = atan2(gravity.x, gravity.y) - M_PI
            self.isWalking.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)\n Running: \(unwrappedActivity.running)\n Cycling: \(unwrappedActivity.cycling)\n Driving: \(unwrappedActivity.automotive)"
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        //separate out the handler for better readability
//        if CMPedometer.isStepCountingAvailable(){
//            pedometer.startUpdates(from: Date(), withHandler: self.handlePedometer as! CMPedometerHandler)
//        }
        
//        if(CMPedometer.isStepCountingAvailable()){
//            
//            self.pedometer.startUpdates(from: midnightOfToday) { (data: CMPedometerData?, error) -> Void in
//                DispatchQueue.main.async(execute: { () -> Void in
//                    if(error == nil){
//                        print("\(data!.numberOfSteps)")
//                        self.currentStepsLabel.text = "\(data!.numberOfSteps)"
//                    }
//                })
//            }
//        }
        
        var cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = TimeZone.current
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)!
        
        if(CMPedometer.isStepCountingAvailable()){
            
            self.pedometer.startUpdates(from: midnightOfToday) { (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        print("\(data!.numberOfSteps)")
                        self.stepsLabel.text = "\(data!.numberOfSteps)"
                    }
                })
            }
        }
    }
    
    
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:NSError?){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }


}

