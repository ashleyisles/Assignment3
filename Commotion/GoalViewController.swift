//
//  GoalViewController.swift
//  Commotion
//
//  Created by Ashley Isles on 9/29/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stepGoal: UITextField!
    @IBOutlet weak var stepGoalLabel: UILabel!
    @IBOutlet weak var setGoal: UIButton!
    
    var steps:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GoalViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
        stepGoal.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        stepGoalLabel.text = textField.text
        steps = Int(textField.text!)!
        print(steps)
        
    }
    
    //MARK: - Actions
    
    @IBAction func setGoal(_ sender: UIButton) {
        stepGoalLabel.text = stepGoal.text
        print("hi")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
