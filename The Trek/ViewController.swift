//
//  ViewController.swift
//  The Trek v. 0.2.2, Build 2
//  Bundle ID: com.jordanlunsford.TheTrek
//  SKU: 20170301
//
//  Created by Jordan Lunsford on 2/3/16.
//  Copyright © 2016-2017 Jordan Lunsford. All rights reserved.
//

//Update Notes v. 0.2.2:
//  Submitted to TestFlight
//  Fluid story updates
//	  Updates no longer require story progression reset
//  Improved app display on smaller screen sizes
//  Removed dead time on app launch
//  First game over now only prompts, "Try Again"
//  Story updates (rewrote much of the introduction)


//Discussion:
//  Settings menu: initial caps?



//Beta Submission
//  Remove unneeded fonts, images, UI elements
//  Check:
//    Try all buttons
//    Spell check messageList
//    forceNewGame = false, fastVersion = false, betaProgressReset = true
//    Bundle identifier, version & build
//    Info.plist "MinimumOSVersion: 10.0.0"

//App Store Submission:
//    Remove "Check for new version," betaProgressReset (viewDidLoad, viewDidAppear)

//  App Description:
//    Include Raleway Font Copyright Notice
//    Check Minion UI copyright




//UX:
//  setStoryVersion at safe "checkpoints" (locate new messageIndex)
//  Only scroll when looking at bottom of message feed
//  Wait for notification permission before starting game
//  Error handling (Restart story on error?)
//    Currently sends game end alert
//  Re-entering from background needs to check if Ben isn't busy anymore (Do not exit on move to background)
//    Update BenBusyTimer on move to the foreground
//    ALSO:
//      Messages begin pushing before view has appeared. Probably due to update in viewDidAppear. Reload table in viewDidLoad?
//      Screenshot on move to background not working properly
//  iOS 9 support
//  Ben is writing... (append to messagesViewed then remove, create separate object)
//  Custom table
//  Variable message speed
//  Advance forward, backward a specified number of KEY, RESPONSE, RESEARCH, SYS messages
//  CoreData


//UI:
//  Only in fast version, new game at end, buttons flash previous responses

//  Custom alert windows
//  New game yes/no menu (create menuPresets)
//  Sound

//  Try fonts: Exo 2, Lato, Open Sans
//  Buttons stay, response appears (?)
//  Challenge: Buttons slide up from bottom
//  Allow messages to flow under response bar

//  Launch screen?



//NAME:
//  100 Miles (or 100mi)
//  100 Mile Trek


import UIKit
import UserNotifications
//import CoreData
//import Foundation




var alertParameters = [String]()


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
//INITIAL VARIABLES
	let forceNewGame = false
	let fastVersionToggle = true

	var betaProgressReset = false
	var fastVersion = false
	
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
	var tryAgainRevert = String()
	
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
	@IBOutlet var newGameButton2: UIButton!
	@IBOutlet var tryAgainButton: UIButton!
	@IBOutlet var settingsButton: UIButton!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var fastVersionButton: UIButton!
	
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
		settingsButton.isHidden = false
		settingsButton.isEnabled = true
	}
	
	func disableButtons() {
		responseButton1.isHidden = true
		responseButton2.isHidden = true
		responseButton1.isEnabled = false
		responseButton2.isEnabled = false
		settingsButton.isHidden = true
		settingsButton.isEnabled = false
	}
	
	@IBAction func newGameButtonPressed(_ sender: UIButton) { //Change text to Confirm new game?, then new game
		if newGameConfirm == true {
			newGameButton.setTitle("Start New Game", for: UIControlState())
			newGameConfirm = false
		} else {
			newGameButton.isHidden = true
			newGameButton.isEnabled = false
			newGameButton.setTitle("New Game", for: UIControlState())
			newGameConfirm = true
			startNewGame()
		}
	}
	
	@IBAction func newGameButtonPressed2(_ sender: UIButton) {
		if newGameConfirm == true {
			newGameButton2.setTitle("Start New Game", for: UIControlState())
			newGameConfirm = false
		} else {
			tryAgainButton.isHidden = true
			tryAgainButton.isEnabled = false
			newGameButton2.isHidden = true
			newGameButton2.isEnabled = false
			newGameButton2.setTitle("New Game", for: UIControlState())
			newGameConfirm = true
			startNewGame()
		}
	}
	
	@IBAction func tryAgainButtonPressed(_ sender: UIButton) {
		
		tryAgainButton.isHidden = true
		tryAgainButton.isEnabled = false
		newGameButton2.isHidden = true
		newGameButton2.isEnabled = false
		newGameButton2.setTitle("New Game", for: UIControlState())
		newGameConfirm = true
		tryAgain()
	}
	
	@IBAction func settingsButtonPressed(_ sender: UIButton) {
		settingsButton.isHidden = true
		settingsButton.isEnabled = false
		backButton.isHidden = false
		backButton.isEnabled = true
		
		newGameButton.isHidden = false
		newGameButton.isEnabled = true
		
		disableButtons()
	}
	
	@IBAction func backButtonPressed(_ sender: UIButton) {
		backButton.isHidden = true
		backButton.isEnabled = false
		settingsButton.isHidden = false
		settingsButton.isEnabled = true
		
		newGameButton.isHidden = true
		newGameButton.isEnabled = false
		newGameButton.setTitle("New Game", for: UIControlState())
		newGameConfirm = true
		
		enableButtons()
	}
	
	@IBAction func fastVersionButtonPressed(_ sender: UIButton) {
		if fastVersion == false {
			fastVersion = true
			fastVersionButton.alpha = 1
			
			if messageDelay.isValid {
				if messageDelay.fireDate.timeIntervalSince(Date()) > 0.1 {
					messageDelay.invalidate()
					pushMessage()
					return
				}
			}
			
			if benBusyTimer.isValid {
				if benBusyTimer.fireDate.timeIntervalSince(Date()) > 0.1 {
					benBusyTimer.invalidate()
					nextMessage()
					return
				}
			}
			
		} else {
			fastVersion = false
			fastVersionButton.alpha = 0.4
		}
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
				
				responseButton1.setTitle("", for: UIControlState()) //temp find where buttons are enabling on TryAgain or NewGame
				responseButton2.setTitle("", for: UIControlState()) //temp
				tryAgainRevert = messageArray[2]
				
				if fastVersion == false {
					delay(1.5) {
						self.customAlert(title: "Game Over", alertMessage: self.messageArray[1], button1: "Dismiss")
					}
				} else {
					customAlert(title: "Game Over", alertMessage: messageArray[1], button1: "Dismiss")
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
			
		} else if messageArray[0] == "RESPONSE"{
			messageDelayTime = 1

		} else {
			if messagesViewed.count <= 1 { //First message
				messageDelayTime = 1.5
			} else {
				messageDelayTime = 2.7 + Double(messagesViewed[messagesViewed.count - 1].characters.count)/40.0
				//messageDelayTime = 2.5 + Double(messagesViewed[messagesViewed.count - 1].characters.count)/35.0
			}
		}
		
		//MARK - If last message was "Ben is Busy" or a response, override message delay
		if messagesViewed.count >= 1 {
			if messagesViewed[messagesViewed.count - 1] == "Ben is busy" {
				messageDelayTime = 0.1
			} /*else if messageTypes[messageTypes.count - 1] == "RESPONSE" && fastVersion != true {
				messageDelayTime = 2.5
			}*/
		}
	
		if skipDelay == false && fastVersion != true {
			messageDelay = Timer.scheduledTimer(timeInterval: messageDelayTime, target: self, selector: #selector(ViewController.pushMessage), userInfo: nil, repeats: false)
		} else {
			pushMessage()
		}
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
	
	
	func customAlert(title: String, alertMessage: String, button1: String, button2: String = "None") {
		if title == "Game Over" {
			
			alertParameters = [title, alertMessage, button1, button2]
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
			myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
			myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
			self.present(myAlert, animated: true, completion: nil)
			
			if messageIndex == 2 {
				newGameButton.setTitle("try again", for: UIControlState())
				newGameConfirm = false
			}
			
			delay(0.2) {
				if self.tryAgainRevert == "BEGINNING" {
					self.newGameButton.isHidden = false
					self.newGameButton.isEnabled = true
					
				} else if self.messageIndex == 2 {//can rename new game button instead of showing try again
					self.newGameButton.isHidden = false
					self.newGameButton.isEnabled = true
					
				} else {
					self.newGameButton2.isHidden = false
					self.newGameButton2.isEnabled = true
					self.tryAgainButton.isHidden = false
					self.tryAgainButton.isEnabled = true
				}
			}
		}
	}
	

	func tryAgain() {
		
		//MARK - Can revert to any unique message or most recent research or response item
		//MARK - Only revert within the current story thread. Cannont revert to a message that was never viewed.
		
		self.newGameConfirm = true
		
		//MARK: Adjust Message Index
		if tryAgainRevert == "RESEARCH" || tryAgainRevert == "RESPONSE" {
			while self.splitMessage(self.messageList[self.messageIndex])[0] != tryAgainRevert {
				self.messageIndex -= 1
			}
		} else {
			while self.messageList[self.messageIndex] != tryAgainRevert {
				self.messageIndex -= 1
			}
		}
		self.messageIndex -= 1
		
		//MARK: Adjust messagesViewed
		if tryAgainRevert == "RESEARCH" || tryAgainRevert == "RESPONSE" {
			while self.messageTypes[self.messageTypes.count - 1] != tryAgainRevert {
				self.messagesViewed.removeLast()
				self.messageTypes.removeLast()
			}
		} else {
			while self.messagesViewed[self.messagesViewed.count - 1] != tryAgainRevert {
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
	}
	
	
	func startNewGame() { //include optional wait
		
		newGameConfirm = true
		
		backButton.isHidden = true
		backButton.isEnabled = false
		settingsButton.isHidden = true
		settingsButton.isEnabled = false
		
		messageIndex = -1
		
		messagesViewed = []
		messageTypes = []
		messagePath = []
		
		isGameOver = false
		
		setMessageList()
		
		saveGame()
		table.reloadData()
		scrollToBottom()
		nextMessage()
	}
	
	
	func setMessageList() {
		messageList = masterMessageList
		//messageList = testMessageList
		
		history.removeObject(forKey: "messageList")
		history.set(messageList, forKey: "messageList")
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
	
	
	
	func alert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in }))
		self.present(alert, animated: true, completion: nil)
	}
	

	
	func delay(_ delay: Double, closure: @escaping ()->()) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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
		
		responseButton1.titleLabel!.textAlignment = NSTextAlignment.center
		responseButton2.titleLabel!.textAlignment = NSTextAlignment.center
		responseButton1.titleLabel!.font = fontResponse
		responseButton2.titleLabel!.font = fontResponse
		
		newGameButton.titleLabel!.textAlignment = NSTextAlignment.center
		
		if fastVersionToggle == true {
			fastVersionButton.isHidden = false
			fastVersionButton.isEnabled = true
		} else {
			fastVersionButton.isHidden = true
			fastVersionButton.isEnabled = false
		}
		
		
		
		
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
				self.tryAgainRevert = self.messageArray[2]
				self.customAlert(title: "Game Over", alertMessage: self.messageArray[1], button1: "Dismiss")
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
