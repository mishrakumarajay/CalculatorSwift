//
//  LoginViewController.swift
//  iOSCalculator
//
//  Created by Ajay Mishra on 25/08/20.
//  Copyright © 2020 Ajay Mishra. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfeild : UITextField!
    @IBOutlet weak var passwordTextfeild : UITextField!
    
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var errorLabel : UILabel!
    
    
    var users: [NSManagedObject] = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Login"
        
        self.view.translatesAutoresizingMaskIntoConstraints = true;
        
        if self.fetchUsersCount() <= 0 {
            self.staticLoginDetails()
        }
        
        self.customizeTextfeild(self.usernameTextfeild)
        self.customizeTextfeild(self.passwordTextfeild)
        self.customizeTextfeild(self.loginButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.usernameTextfeild.text! = ""
        self.passwordTextfeild.text! = ""
        self.errorLabel.text! = ""
    }
    
    func customizeTextfeild(_ textfeild : UIView) {
        textfeild.layer.cornerRadius = 10
        textfeild.layer.borderColor = UIColor.lightGray.cgColor
        textfeild.layer.borderWidth = 1
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton)
    {
        let user = users[0]
        
        guard !self.usernameTextfeild.text!.isEmpty else {
            self.errorLabel.text = "Username cannot be empty"
            return
        }
        
        guard !self.passwordTextfeild.text!.isEmpty else {
            self.errorLabel.text = "password cannot be empty"
            return
        }
        
        guard self.usernameTextfeild.text! == (user.value(forKey: "username") as! String) && self.passwordTextfeild.text! == (user.value(forKey: "password") as! String) else {
            self.errorLabel.text = "Login credentials are wrong"
            return
        }
        
        let calcViewController = CalculatorViewController(nibName: "CalculatorViewController", bundle: nil)
        
        self.navigationController?.pushViewController(calcViewController, animated: true)
    }

    func staticLoginDetails()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
      
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
      
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "User",in: managedContext)!
      
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
      
        // 3
        person.setValue("Ajay", forKeyPath: "username")
        person.setValue("Demo@123", forKeyPath: "password")
      
        // 4
        do
        {
            try managedContext.save()
            users.append(person)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchUsersCount() -> Int
    {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return users.count
        }
      
        let managedContext = appDelegate.persistentContainer.viewContext
      
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
      
        //3
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("Count - \(users.count)")
        return users.count
    }


}
