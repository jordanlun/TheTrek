//
//  CustomAlertViewController.swift
//  The Trek
//
//  Created by Jordan Lunsford on 4/13/17.
//  Copyright © 2017 Jordan Lunsford. All rights reserved.
//

import UIKit


class CustomAlertViewController: UIViewController {

	var vc = ViewController()
	
	var button1Function = String()
	var button2Function = String()
	
	var action = String()
	
	
	@IBOutlet var titleLabel: UILabel!
	
	@IBOutlet var descriptionLabel: UILabel!
	
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!
	
	
	@IBAction func button1Tapped(_ sender: UIButton) {
		//action = button1Function //action = button1Function
		//detectAction()
	}
	
	@IBAction func button2Tapped(_ sender: UIButton) {
		//action = button2Function
		//detectAction()
	}
	
	@IBAction func button3Tapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
		//action = button1Function
		//detectAction()
	}
	
	
/*	func detectAction() {
		button1.isEnabled = false
		button2.isEnabled = false
		button3.isEnabled = false
		
		if action == "Dismiss" {
			self.dismiss(animated: true, completion: nil)
		} else if action == "Try Again" {
			print("Try Again")
		} else if action == "New Game" {
			print("New Game")
			//vc.startNewGame()
			self.dismiss(animated: true, completion: nil)
		} else {
			print("Alert Error")
		}
	}*/
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		//let alertParameters = vc.alertParameters
		
		titleLabel.text = alertParameters[0]
		descriptionLabel.text = alertParameters[1]
		
		
		/*
		button1Function = alertParameters[2]
		button2Function = alertParameters[3]
		
		if button1Function == "New Game" {
			button1.setTitleColor(.red, for: .normal)
			button3.setTitleColor(.red, for: .normal)
		}
		if button2Function == "New Game" {
			button2.setTitleColor(.red, for: .normal)
		}
		
		
		
		if button2Function == "None" {
			button3.setTitle(button1Function, for: UIControlState())
			
			button1.isHidden = true
			button2.isHidden = true
			button3.isHidden = false
			
			button1.isEnabled = false
			button2.isEnabled = false
			button3.isEnabled = true
			
		} else {
			button1.setTitle(button1Function, for: UIControlState())
			button2.setTitle(button2Function, for: UIControlState())
			
			button1.isHidden = false
			button2.isHidden = false
			button3.isHidden = true
			
			button1.isEnabled = true
			button2.isEnabled = true
			button3.isEnabled = false
		}*/
    }
}
