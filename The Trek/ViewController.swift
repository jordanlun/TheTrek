//
//  ViewController.swift
//  The Trek v. 0.2.2, Build 1
//  Bundle ID: com.jordanlunsford.TheTrek
//  SKU: 20170301
//
//  Created by Jordan Lunsford on 2/3/16.
//  Copyright © 2016-2017 Jordan Lunsford. All rights reserved.
//

//Update Notes v. 0.2.2:
//  Submitted to TestFlight
//  Fluid story updates
//	  Updates no longer reset story progression
//  Improved app display on smaller screen sizes
//  Removed dead time on app launch
//  First game over now only prompts, "Try Again"
//  Story tweaks (rewrote much of the introduction)


//Beta Submission
//  Remove unneeded fonts, images, UI elements
//  Check:
//    Try all buttons
//    Spell check messageList
//    forceNewGame = false, fastVersion = false, betaProgressReset = true
//    Bundle identifier, version & build
//    Info.plist "MinimumOSVersion"

//App Store Submission:
//    Remove "Check for new version," betaProgressReset (viewDidLoad, viewDidAppear)

//  App Description:
//    Include Raleway Font Copyright Notice
//    Check Minion UI copyright




//UX:
//  setStoryVersion at safe "checkpoints" (update thread & locate new messageIndex)

//  Only scroll when looking at bottom of message feed

//  Wait for notification permission before starting game

//  Error handling (Restart story on error?)
//    Currently sends game end alert

//  Re-entering from background needs to check if Ben isn't busy anymore (Do not exit on move to background)
//    Update BenBusyTimer on move to the foreground
//    ALSO:
//      Messages begin pushing before view has appeared. Probably due to update in viewDidAppear. Reload table in viewDidLoad?
//      Screenshot on move to background not working properly


//UX (cont.):
//  iOS 9 support
//  Ben is writing... (append to messagesViewed then remove, create separate object)
//  Custom table
//  Variable message speed
//  Advance forward, backward a specified number of KEY, RESPONSE, RESEARCH, SYS messages
//  CoreData


//UI:
//  Sound
//  Custom alert windows
//  Try fonts: Exo 2, Lato, Open Sans

//  Buttons stay, response appears (?)
//  Challenge: Buttons slide up from bottom
//  Allow messages to flow under response bar

//  Launch screen?


//STORY:
//  Explain Ben is Busy (Alert, notification explanation, or more Ben)

//  Option to search the wreckage twice

//  Lack of food
//    Mention eating the pilot
//    Eating snow, donut

//  Giving up, coax to keep going


//  Do something after Ben takes a break
//  Remind what to Google (rework that line)
//  What does Ben do? What kind of business trip (Analytics?)

//  Check the line before loads of help

//  More chances for interaction
//  More emotion

//  Ideas: Animals, hallucinations, details (peeling skin, frostbite, blisters, numb mouth)


//NAME:
//  100 Miles (or 100mi)
//  100 Mile Trek


import UIKit
import UserNotifications
//import CoreData
//import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
//INITIAL VARIABLES
	let forceNewGame = false
	let fastVersion = false

	var betaProgressReset = true
	
	var gameVersion = String()
	var savedGameVersion = String()
	var newGameForBeta = false
	
	var messageList = [String]()
	var messagesViewed = [String]()
	var messageTypes = [String]()
	var messagePath = [String]() //Not really used
	var messageIndex = -1 // Search the wreckage: 83, Default: -1
	
	var newMessage = ""
	var messageArray = [String]()
	
	var isGameOver = false
	var newGameConfirm = true
	
	var messageDelay = Timer()
	var messageDelayTime = 0.0
	
	var benBusyTimer = Timer()
	var savedBenBusyTimer = Date()
	var time = 0.0
	
	let history = UserDefaults.standard
	var savedDataList = [String]()
	
	let delegate = UIApplication.shared.delegate as? AppDelegate
	
	let screenSize: CGRect = UIScreen.main.bounds  // 4.7" (1334 x 750); 4" (1136 x 640)
	var fontResponse = UIFont (name: "Raleway-MediumItalic", size: 16)
	var fontDefault = UIFont (name: "Raleway-Light", size: 16)
	
	

//BUTTONS
	@IBOutlet var responseButton1: UIButton!
	@IBOutlet var responseButton2: UIButton!
	@IBOutlet var newGameButton: UIButton!
	
	@IBAction func responseButtonPressed1(_ sender: UIButton) {
		if messageArray != []  {
			messagesViewed.append(messageArray[1])
			messageTypes.append("RESPONSE")
		
			for path in messageArray[2].components(separatedBy: "->") {
				messagePath.append(path)
			}
		
			saveGame()
			table.reloadData()
			scrollToBottom()
			disableButtons()
			nextMessage()
		} else {
			print("Response Button Error")
			nextMessage()
		}
	}
	
	@IBAction func responseButtonPressed2(_ sender: UIButton) {
		if messageArray != []  {
			messagesViewed.append(messageArray[3])
			messageTypes.append("RESPONSE")
		
			for path in messageArray[4].components(separatedBy: "->") {
				messagePath.append(path)
			}
			
			saveGame()
			table.reloadData()
			scrollToBottom()
			disableButtons()
			nextMessage()
		} else {
			print("Response Button Error")
			nextMessage()
		}
	}
	
	func enableButtons() {
		responseButton1.isEnabled = true
		responseButton2.isEnabled = true
		responseButton1.isHidden = false
		responseButton2.isHidden = false
	}
	
	func disableButtons() {
		responseButton1.isHidden = true
		responseButton2.isHidden = true
		responseButton1.isEnabled = false
		responseButton2.isEnabled = false
	}
	
	@IBAction func newGameButtonPressed(_ sender: UIButton) {
		gameOver("Are you sure you want to start a new game?", revert: "BEGINNING")
		self.newGameConfirm = false
		self.newGameButton.isHidden = true
		self.newGameButton.isEnabled = false
	}
	
	
//MAIN FUNCTIONS
	func nextMessage(skipDelay : Bool = false) {
		
		//MESSAGE QUEUE
		if messagePath.count > 0 {
			advanceToMessage(messagePath[0] as AnyObject)
			messagePath.removeFirst()
		} else {
			messageIndex += 1
		}
		
		newMessage = messageList[messageIndex]
		
		if newMessage.characters.first! == "[" {
			
			messageArray = splitMessage(newMessage)
			
				// RESPONSE
			if messageArray[0] == "RESPONSE" {
				responseButton1.setTitle(messageArray[1], for: UIControlState())
				responseButton2.setTitle(messageArray[3], for: UIControlState())
				setMessageDelay(skipDelay : skipDelay)
				
				// RESEARCH
			} else if messageArray[0] == "RESEARCH" {
				setMessageDelay(skipDelay : skipDelay)
				
				//SYS
			} else if messageArray[0] == "SYS" {
				setMessageDelay(skipDelay : skipDelay)
				
				// SKIP
			} else if messageArray[0] == "SKIP" {
				advanceToMessage(messageArray[1] as AnyObject)
				messageIndex -= 1 //Should this go in advanceToMessage()?
				saveGame()
				nextMessage()
				
				// WAIT
			} else if messageArray[0] == "WAIT" {
				if fastVersion == false {
					saveGame()
					delay(Double(messageArray[1])!) {
						self.nextMessage()
					}
				} else {
					self.nextMessage()
				}
				//GAMEOVER
			} else if messageArray[0] == "GAMEOVER" {
				isGameOver = true
				saveGame()
				if fastVersion == false {
					delay(1.5) {
						self.gameOver(self.messageArray[1], revert: self.messageArray[2])
					}
				} else {
					self.gameOver(self.messageArray[1], revert: self.messageArray[2])
				}
			}
			
		// MESSAGE
		} else {
			messageArray = ["MESSAGE", newMessage]
			setMessageDelay(skipDelay : skipDelay)
		}
	}
	
	
	func setMessageDelay(skipDelay : Bool = false) {
		
		if fastVersion == true {
			messageDelayTime = 0.1
			//print("Fast Version|\(messageDelayTime)")
			
		} else if messageArray[0] == "RESPONSE"{
			messageDelayTime = 1
			//print("Response|\(messageDelayTime)")

		} else {
			if messagesViewed.count <= 1 {
				messageDelayTime = 2.5
				//print("First message|\(messageDelayTime)")
			} else {
				//print("messageDelayTime: \(messageDelayTime)")
				messageDelayTime = 2.5 + Double(messagesViewed[messagesViewed.count - 1].characters.count)/35.0
			}
		}
		
		//MARK - If last message was "Ben is Busy" or a response, override message delay
		if messagesViewed.count >= 1 {
			if messagesViewed[messagesViewed.count - 1] == "Ben is busy" {
				messageDelayTime = 0.1
			} else if messageTypes[messageTypes.count - 1] == "RESPONSE" && fastVersion != true {
				messageDelayTime = 2.5
			}
		}
	
		// ATTEMPT: BEN TYPING
		//messagesViewed.append("...")
		//table.reloadData()
		if skipDelay == false && fastVersion != true {
			messageDelay = Timer.scheduledTimer(timeInterval: messageDelayTime, target: self, selector: #selector(ViewController.pushMessage), userInfo: nil, repeats: false)
		} else {
			pushMessage()
		}
		
		//print("Timer set – Now: \(Date()) | Delay: \(messageDelayTime) | Fire date: \(messageDelay.fireDate)")
		
	}
	
	
	func pushMessage() {
		
		messageDelay.invalidate() //Needed?
		
		/* ATTEMPT: BEN TYPING
		if messagesViewed[messagesViewed.count - 1] as! String == "..." {
			messagesViewed.removeLast()
			table.reloadData()
		}*/
		if messageArray[0] != "RESPONSE" {
			messageTypes.append(messageArray[0])
			messagesViewed.append(messageArray[1])
			saveGame()
			table.reloadData()
			scrollToBottom()
			
			if messageArray[1] == "Ben is busy" {
				benIsBusy()
			} else {
				if messageIndex < messageList.count - 1 {
					nextMessage()
				}
			}
			
		} else {
			enableButtons()
		}
	}
	
	
	func benIsBusy() {
		if fastVersion {
			//time = 0.1 // MARK - Affects how long to hold on Ben Is Busy while fastVersion
			nextMessage()
			return
		} else {
			time = Double(messageArray[2])! * 60.0
		}
		
		//MARK - Schedule Notification
		delegate?.scheduleNotification(time: time)
		
		//MARK - In-app Timer
		benBusyTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(ViewController.nextMessage), userInfo: nil, repeats: false)
		
		history.removeObject(forKey: "savedBenBusyTimer")
		history.set([benBusyTimer.fireDate], forKey: "savedBenBusyTimer")
	}
	
	
	func gameOver(_ message : String, revert : String) {
		
		//MARK - Can revert to any unique message or most recent research or response item
		//MARK - Only revert within the current story thread. Cannont revert to a message that was never viewed.
		
		let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: UIAlertControllerStyle.alert)
		
		//TRY AGAIN
		if revert != "BEGINNING" {
			alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
				self.newGameConfirm = true
				
				//MARK: Adjust Message Index						<<<<< Combine this and next?
				if revert == "RESEARCH" || revert == "RESPONSE" {
					while self.splitMessage(self.messageList[self.messageIndex])[0] != revert {
						self.messageIndex -= 1
					}
				} else {
					while self.messageList[self.messageIndex] != revert {
						self.messageIndex -= 1
					}
				}
				self.messageIndex -= 1
				
				//MARK: Adjust messagesViewed
				if revert == "RESEARCH" || revert == "RESPONSE" {
					while self.messageTypes[self.messageTypes.count - 1] != revert {
						self.messagesViewed.removeLast()
						self.messageTypes.removeLast()
					}
				} else {
					while self.messagesViewed[self.messagesViewed.count - 1] != revert {
						self.messagesViewed.removeLast()
						self.messageTypes.removeLast()
					}
				}
				self.messagesViewed.removeLast()
				self.messageTypes.removeLast()
				
				//MARK: Reset other variables
				if self.messagePath.count > 0 { //TEMP: Checks expression below
					print("MESSAGE PATH NOT EMPTY")
				}
				self.messagePath = [] //Not ideal to clear this
				
				self.isGameOver = false
				
				//MARK: If new game, setMessageList
				if self.messageIndex == -1 {
					self.setMessageList()
				}
				
				self.saveGame()
				self.table.reloadData()
				self.scrollToBottom()
				self.nextMessage()
			}))
		} else {
			alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
				self.newGameButton.isEnabled = true
				self.newGameButton.isHidden = false
			}))
		}
		
		//NEW GAME
		if messageIndex != 2 {
			alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction!) in
				if self.newGameConfirm == false {
					self.newGameConfirm = true
					
					self.messageIndex = -1
					
					self.messagesViewed = []
					self.messageTypes = []
					self.messagePath = []
					
					self.isGameOver = false
					
					self.setMessageList()
					
					self.saveGame()
					self.table.reloadData()
					self.scrollToBottom()
					self.nextMessage()
				} else {
					self.newGameConfirm = false
					self.gameOver("Are you sure you want to start a new game?", revert: revert)
				}
			}))
		}
		
		//PUSH ALERT WINDOW
			self.present(alert, animated: true, completion: nil)
	}

	
	
//OTHER FUNCTIONS
	func advanceToMessage(_ message : AnyObject) {
		//MARK - Can advance by number or to next RESEARCH, SYS, WAIT, or specific message
		let msg = message as! String
		if let _ = Int(msg) {
			messageIndex += Int(msg)!
		} else if msg == "RESEARCH" || msg == "SYS" || msg == "WAIT" {
			while msg != splitMessage(messageList[messageIndex])[0] {
				messageIndex += 1
			}
		} else {
			while msg != messageList[messageIndex] && messageIndex < messageList.count - 2 {
				messageIndex += 1
			}
			
			if msg != messageList[messageIndex] {
				print("advanceToMessage error")
				
			}
		}
	}
	
	
	func splitMessage(_ message : String) -> [String] {
		var msg = ""
		for char in message.characters {
			if char != "[" && char != "]" {
				msg.append(char)
			}
		}
		return msg.components(separatedBy: "|")
	}
	
	// Call from AppDelegate applicationWillEnterForeground()
	func updateBenIsBusyTimer() {
		if history.object(forKey: "savedBenBusyTimer") != nil {
			savedBenBusyTimer = (history.object(forKey: "savedBenBusyTimer")!  as! NSArray)[0] as! Date
		
			let now = Date()
			let difference = savedBenBusyTimer.timeIntervalSince(now)
			
			if difference >= 0 {
				//MARK - Adjust In-app Timer
				self.benBusyTimer = Timer.scheduledTimer(timeInterval: difference, target: self, selector: #selector(ViewController.nextMessage), userInfo: nil, repeats: false)
				print("Updated BenIsBusyTimer")
			}
		}

	}
	
	func alert(title : String, message : String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in }))
		self.present(alert, animated: true, completion: nil)
	}

	
	func delay(_ delay:Double, closure:@escaping ()->()) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
	}
	
	
	func setMessageList() {
		messageList = masterMessageList
		//messageList = testMessageList
		
		history.removeObject(forKey: "messageList")
		history.set(messageList, forKey: "messageList")
	}
	
	
	func saveGame() { //Destructive
		
		savedDataList = messagesViewed
		savedDataList.append(String(messageIndex))
		
		history.removeObject(forKey: "history")
		history.set([savedDataList], forKey: "history")
		
		history.removeObject(forKey: "isGameOver")
		history.set([isGameOver], forKey: "isGameOver")
		
		history.removeObject(forKey: "messagePath")
		history.set([messagePath], forKey: "messagePath")
		
		history.removeObject(forKey: "messageTypes")
		history.set([messageTypes], forKey: "messageTypes")
	}
	
	

	
//TABLE PROPERTIES
	@IBOutlet var table: UITableView!
	
	func scrollToBottom() {
		if messagesViewed.count > Int(table.frame.height / table.rowHeight) {
			let indexPath = IndexPath(row: messagesViewed.count - 1, section: 0)
			table.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messagesViewed.count
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = .clear
		
		//MARK - Set message font
		if messageTypes[indexPath.row] == "RESPONSE"{
			cell.textLabel!.font = fontResponse
		} else {
			cell.textLabel!.font = fontDefault
		}
		cell.textLabel!.numberOfLines = 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Message")
		var contentForCell = messagesViewed[indexPath.row]
		
		//cell.textLabel!.text = ""
		
		//MARK - Add period to message
		if contentForCell.characters.last! != "." && contentForCell.characters.last! != "?" && contentForCell.characters.last! != "," && contentForCell.characters.last! != "!" && contentForCell.characters.last! != ":" && contentForCell.characters.last! != ";" && contentForCell.characters.last! != "-" && messageTypes[indexPath.row] != "SYS" {
			contentForCell = "\(contentForCell)."
		}
		
		/* ATTEMPT: BEN TYPING
		if contentForCell == "..." {
			message.textLabel!.textColor = UIColor(red: 76/255, green: 116/225, blue: 0, alpha: 1.0)
			message.textLabel!.textAlignment = NSTextAlignment.Center
		*/
			
		//SYS
		if messageTypes[indexPath.row] == "SYS" {
			cell.textLabel!.text = "[\(contentForCell)]"
			cell.textLabel!.textColor = UIColor(red: 150/255, green: 220/255, blue: 150/255, alpha: 1.0)
			cell.textLabel!.textAlignment = NSTextAlignment.center
		
		//RESPONSE
		} else if messageTypes[indexPath.row] == "RESPONSE" {
			contentForCell = contentForCell.replacingOccurrences(of: "\n", with: " ")
			cell.textLabel!.text = contentForCell
			cell.textLabel!.textColor = UIColor(red: 60/255, green: 172/255, blue: 155/255, alpha: 1.0)
			cell.textLabel!.textAlignment = NSTextAlignment.right
		
		//RESEARCH
		} else if messageTypes[indexPath.row] == "RESEARCH" {
			cell.textLabel!.text = contentForCell
			cell.textLabel!.textColor = UIColor(red: 150/255, green: 220/255, blue: 150/255, alpha: 1.0)
			
		//MESSAGE
		} else {
			cell.textLabel!.text = contentForCell
			cell.textLabel!.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
		}
		
		// ATTEMPT: DYNAMIC ROW HEIGHT
		//cell.setNeedsUpdateConstraints()
		//cell.updateConstraintsIfNeeded()
		
		return cell
	}
	
	/* ATTEMPT: DYNAMIC ROW HEIGHT
	func tableView(_ heightForRowAttableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}*/
	


	
//VIEWDIDLOAD
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if screenSize.width < 375 {
			table.rowHeight = 79.5 //(79.5, 86.5)
		} else {
			table.rowHeight = 96
		}
		
		// ATTEMPT: DYNAMIC ROW HEIGHT
		//table.estimatedRowHeight = 96
		//table.rowHeight = UITableViewAutomaticDimension
		
		fontDefault = UIFont (name: "Raleway-Light", size: 16)
		fontResponse = UIFont (name: "Raleway-MediumItalic", size: 16)
		
		//responseButton1.titleLabel!.textAlignment = NSTextAlignment.center
		//responseButton2.titleLabel!.textAlignment = NSTextAlignment.center
		//responseButton1.titleLabel!.font = fontResponse
		//responseButton2.titleLabel!.font = fontResponse
		
		
		
		
		//LOAD SAVED DATA
		/*let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext = appDel.managedObjectContext
		var newData = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: context) as NSManagedObject*/
		
		
		//MARK - Detect Game Update
		let versionNumber = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
		let buildVersion = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
		gameVersion = "\(versionNumber)|\(buildVersion)"

		if history.object(forKey: "gameVersion") != nil {
			savedGameVersion = (history.object(forKey: "gameVersion")! as! NSArray)[0] as! String
			if gameVersion != savedGameVersion && betaProgressReset == true {
				newGameForBeta = true
			} else {
				newGameForBeta = false
			}
		}
		
		history.set([gameVersion], forKey: "gameVersion")
		
		
		//MARK - Override newGameForBeta if no savedMessageList (v1.2.1)
		if history.object(forKey: "messageList") == nil {
			newGameForBeta = true
			betaProgressReset = true
		}
		
		
		//MARK - New Game
		if newGameForBeta == true || forceNewGame == true || history.object(forKey: "history") == nil {
			
			history.removeObject(forKey: "history")
			history.removeObject(forKey: "messageList")
			history.removeObject(forKey: "messagePath")
			history.removeObject(forKey: "messageTypes")
			history.removeObject(forKey: "isGameOver")
			history.removeObject(forKey: "savedBenBusyTimer")
			
			setMessageList()
			
			
		//MARK - Load Game
		} else {
			let savedData = history.object(forKey: "history")! as! NSArray
			savedDataList = savedData[0] as! [String]
			
			messageIndex = Int(savedDataList.last!)!
			savedDataList.remove(at: savedDataList.count - 1)
			
			messagesViewed = savedDataList
			
			messageList = (history.object(forKey: "messageList")! as! NSArray) as! [String]
			
			messageTypes = (history.object(forKey: "messageTypes")! as! NSArray)[0] as! [String]
			messagePath = (history.object(forKey: "messagePath")! as! NSArray)[0] as! [String]
			
			isGameOver = (history.object(forKey: "isGameOver")! as! NSArray)[0] as! Bool
			
			
			
			//table.reloadData()   <<<<<    Check this before implementation
			
			/*dispatch_async(dispatch_get_main_queue(), {
				self.alert("Start: " + String(self.history.objectForKey("history")! as! NSArray))
			})*/
			
		}
		
		
		//let time2 = NSDate()
		//print(time2.timeIntervalSinceDate(time1))

	}
	
	
//VIEWDIDAPPEAR
	override func viewDidAppear(_ animated: Bool) {
		
		//ScrollToBottom - Normal function does not work here and must be delayed
		if messagesViewed.count > Int(table.frame.height / table.rowHeight) {
			delay(0.1) {
				let indexPath = IndexPath(row: self.messagesViewed.count - 1, section: 0)
				self.table.scrollToRow(at: indexPath, at: .bottom, animated: false)
			}
		}
		
		//MARK - Alert: Update Detected
		if newGameForBeta == true {
			alert(title : "Update Detected", message : "During the beta phase, story progression is reset with each update")
		}
		
		if isGameOver { //messageList not initialized yet. Cannot check index point for game over   <<< messageList is initialized now. Can check
			delay(0.1) {
				self.messageArray = self.splitMessage(self.messageList[self.messageIndex])
				self.gameOver(self.messageArray[1], revert: self.messageArray[2])
			}
		} else {
			if history.object(forKey: "savedBenBusyTimer") != nil {
				savedBenBusyTimer = (history.object(forKey: "savedBenBusyTimer")!  as! NSArray)[0] as! Date
			}
			
			let now = Date()
			let difference = savedBenBusyTimer.timeIntervalSince(now)
			if difference <= 0 { //Delay?
				nextMessage(skipDelay : true)
				table.reloadData()
			} else {
				benBusyTimer = Timer.scheduledTimer(timeInterval: difference, target: self, selector: #selector(ViewController.nextMessage), userInfo: nil, repeats: false)
			}
		}
	}

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}//END ViewController
