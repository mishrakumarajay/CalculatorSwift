//
//  CalculatorViewController.swift
//  iOSCalculator
//
//  Created by Ajay Mishra on 23/08/20.
//  Copyright © 2020 Ajay Mishra. All rights reserved.
//

import UIKit
import Expression

class CalculatorViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var historyValue = "0"
    var previousAns = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
    }
    
    @objc func logout()
    {
        self.showSimpleAlert()
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Calculator", message: "Are you want to logout",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        
                                        self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Operation and Number Methods
    
    @IBAction func operationButtonClick(_ sender: UIButton)
    {
        if self.resultLabel.text!.contains("=")
        {
            self.resultLabel.text! = self.previousAns + (sender.titleLabel?.text!)!
        }
        else
        {
            self.resultLabel.text = self.resultLabel.text! + (sender.titleLabel?.text!)!
        }
        
    }
    
    @IBAction func numButtonClcik(_ sender: UIButton) {
        if self.resultLabel.text == "0" || self.resultLabel.text!.contains("=")
        {
            self.resultLabel.text = sender.titleLabel?.text!
        }
        else
        {
            self.resultLabel.text =  self.resultLabel.text! + (sender.titleLabel?.text!)!
        }
        
    }
    
    @IBAction func equalButtonClick(_ sender: UIButton) {
       
        do
        {
            self.historyValue = self.resultLabel.text!
            let result = try Expression(self.resultLabel.text!).evaluate()
            self.resultLabel.text = String(format: "%g", result)
            self.previousAns = String(format: "%g", result)
            self.historyValue = self.historyValue + " = " + self.previousAns
        }
        catch
        {
            //self.resultLabel.font = UIFont(name: "Helvetica-Neue", size: 20)
            self.previousAns = "0"
            self.resultLabel.text = "\(error.localizedDescription)"
        }
    }
    
    
    @IBAction func acButtonClick(_ sender: UIButton) {
        self.resultLabel.text = "0"
    }
    
    @IBAction func answerButtonClick(_ sender: UIButton) {
        if Expression(self.resultLabel.text!).symbols.count > 0 {
            print("operators are present")
            self.resultLabel.text = self.resultLabel.text! + self.previousAns
        }
        else
        {
            self.resultLabel.text = self.previousAns
        }
    }
    
    @IBAction func historyButtonClick(_ sender: UIButton) {
        self.resultLabel.text = self.historyValue
    }
    
}
