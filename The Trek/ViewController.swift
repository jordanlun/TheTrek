//
//  ViewController.swift
//  The Trek v. 0.2.2
//  Bundle ID: com.jordanlunsford.TheTrek
//  SKU: 20170301
//
//  Created by Jordan Lunsford on 2/3/16.
//  Copyright © 2016-2017 Jordan Lunsford. All rights reserved.
//

//Update Notes v. 0.2.2:
//  Removed dead time on app launch
//  First game over now only prompts, "Try Again"
//  Story tweaks


//Submission
//  forceNewGame = false, fastVersion = false
//  Remove unneeded fonts, images, UI elements

//  App Store:
//    Remove "Check for new version" (viewDidLoad, viewDidAppear)
//      Consider update feasibility (i.e. story mismatch)

//  App Description:
//    Include Raleway Font Copyright Notice
//    Check Minion UI copyright




//UX:
//  Re-entering from background needs to check if Ben isn't busy anymore (Do not exit on move to background)
//    Update BenBusyTimer on move to the foreground
//    ALSO:
//      Messages begin pushing before view has appeared. Probably due to update in viewDidAppear. Reload table in viewDidLoad?
//      Screenshot on move to background not working properly

//  Only scroll when looking at bottom of message feed

//  Wait for notification permission before starting game

//  Error handling (Restart story on error?)


//UX (cont.):
//  Variable message speed
//  Ben is writing... (append to messagesViewed then remove, create separate object)
//  Custom table
//  Advance forward, backward a specified number of KEY, RESPONSE, RESEARCH, SYS messages
//  CoreData
//  Progress sync through iCloud/Gamecenter


//UI:
//  Sound
//  Custom alert windows
//  Try fonts: Exo 2, Lato, Open Sans

//  Buttons stay, response appears (?)
//  Challenge: Buttons slide up from bottom
//  Allow messages to flow under response bar

//  Launch screen?


//STORY:
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
	var forceNewGame = false
	var fastVersion = false

	var gameVersion = String()
	var savedGameVersion = String()
	var newGame = false
	
	var messageList = [String]()
	var messagesViewed = [String]()
	var messageTypes = [String]()
	var messagePath = [String]() //Not really used
	var messageIndex = -1 // Images: 130, Default: -1
	
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
				delay(1.5) {
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
				messageDelayTime = 2.0 + Double(messagesViewed[messagesViewed.count - 1].characters.count)/34.0
			}
		}
		
		//MARK - If last message was "Ben is Busy" or a response, override message delay
		if messagesViewed.count >= 1 {
			if messagesViewed[messagesViewed.count - 1] == "Ben is busy" {
				messageDelayTime = 0.1
			} else if messageTypes[messageTypes.count - 1] == "RESPONSE" && fastVersion != true {
				messageDelayTime = 2
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
			while msg != messageList[messageIndex] {
				messageIndex += 1
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

	
	func delay(_ delay:Double, closure:@escaping ()->()) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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
		
		alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
			
		}))
		
		self.present(alert, animated: true, completion: nil)
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
			//cell.textLabel!.textColor = UIColor(red: 76/255, green: 116/225, blue: 0, alpha: 1.0) // GREEN
			cell.textLabel!.textColor = UIColor(red: 150/255, green: 220/255, blue: 150/255, alpha: 1.0) // L. GREEN
			cell.textLabel!.textAlignment = NSTextAlignment.center
		
		//RESPONSE
		} else if messageTypes[indexPath.row] == "RESPONSE" {
			contentForCell = contentForCell.replacingOccurrences(of: "\n", with: " ")
			cell.textLabel!.text = contentForCell
			//cell.textLabel!.textColor = UIColor(red: 74/255, green: 170/255, blue: 201/255, alpha: 1.0)  // BLUE
			cell.textLabel!.textColor = UIColor(red: 60/255, green: 172/255, blue: 155/255, alpha: 1.0)  // TEAL
			//cell.textLabel!.textColor = UIColor(red: 238/255, green: 139/255, blue: 3/255, alpha: 1.0)  // ORANGE
			cell.textLabel!.textAlignment = NSTextAlignment.right
		
		//RESEARCH
		} else if messageTypes[indexPath.row] == "RESEARCH" {
			cell.textLabel!.text = contentForCell
			//cell.textLabel!.textColor = UIColor(red: 80/255, green: 170/255, blue: 80/255, alpha: 1.0) // GREEN
			cell.textLabel!.textColor = UIColor(red: 150/255, green: 220/255, blue: 150/255, alpha: 1.0) // L. GREEN
			//cell.textLabel!.textColor = UIColor(red: 74/255, green: 170/255, blue: 201/255, alpha: 1.0) // BLUE
			
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
			fontResponse = UIFont (name: "Raleway-MediumItalic", size: 14)
			fontDefault = UIFont (name: "Raleway-Light", size: 14)
			table.rowHeight = 79.5
		} else {
			fontResponse = UIFont (name: "Raleway-MediumItalic", size: 16)
			fontDefault = UIFont (name: "Raleway-Light", size: 16)
			table.rowHeight = 96 //14:72, 16:96
		}
		// ATTEMPT: DYNAMIC ROW HEIGHT
		//table.estimatedRowHeight = 44
		//table.rowHeight = UITableViewAutomaticDimension
		
		
		responseButton1.titleLabel!.textAlignment = NSTextAlignment.center
		responseButton2.titleLabel!.textAlignment = NSTextAlignment.center
		responseButton1.titleLabel!.font = fontResponse
		responseButton2.titleLabel!.font = fontResponse
		
		
		
		
		//LOAD SAVED DATA
		/*let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext = appDel.managedObjectContext
		var newData = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: context) as NSManagedObject*/
		
		
		//MARK - Check for new version
		gameVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
		
		if history.object(forKey: "gameVersion") != nil {
			savedGameVersion = (history.object(forKey: "gameVersion")! as! NSArray)[0] as! String
			if gameVersion != savedGameVersion {
				newGame = true
			} else {
				newGame = false
			}
		}
		
		history.set([gameVersion], forKey: "gameVersion")
		
		
		//MARK - New Game
		if newGame == true || forceNewGame == true || history.object(forKey: "history") == nil { //Remove "== true"
			
			history.removeObject(forKey: "history")
			history.removeObject(forKey: "messagePath")
			history.removeObject(forKey: "messageTypes")
			history.removeObject(forKey: "isGameOver")
			history.removeObject(forKey: "savedBenBusyTimer")
			
		//MARK - Load Game
		} else {
			let savedData = history.object(forKey: "history")! as! NSArray
			savedDataList = savedData[0] as! [String]
			
			messageIndex = Int(savedDataList.last!)!
			savedDataList.remove(at: savedDataList.count - 1)
			
			messagesViewed = savedDataList
			
			messageTypes = (history.object(forKey: "messageTypes")! as! NSArray)[0] as! [String]
			messagePath = (history.object(forKey: "messagePath")! as! NSArray)[0] as! [String]
			
			isGameOver = (history.object(forKey: "isGameOver")! as! NSArray)[0] as! Bool
			
			//table.reloadData()   <<<<<    Check this before implementation
			
			/*dispatch_async(dispatch_get_main_queue(), {
				self.alert("Start: " + String(self.history.objectForKey("history")! as! NSArray))
			})*/
			
		}
		
		
		
		messageList = [
			
			//DAY 1
			
			"[RESEARCH|JACK:\nGot someone on line 2. Everyone else is busy. Should I patch you through?", //KEY
			"[RESPONSE|Go ahead|WAIT|Nah|1",
			"[GAMEOVER|The caller was ignored. He eventually froze to death.|RESEARCH",
			"[WAIT|0.5",
			"[SYS|Receiving transmission",
			"[WAIT|0.5",
			"Hello?",
			"[WAIT|0.3",
			"Is anyone there?",
			"[RESPONSE|Yes, I'm here|1|Who is this?|My name is Ben",
			"Finally! You've got to help me",
			"[RESPONSE|What's wrong?|1|Who are you?|My name is Ben",
			"Let me start at the beginning",
			"My name is Ben", //KEY (2)
			"A few days ago I came over to Pakistan on a business trip",
			"I love mountains, so when my meetings were over I decided to take a couple days off and see some",
			"I found this little travel agency with helicopter tours and hired one to fly me up north",
			"As we were nearing Gil--",
			"[SYS|Static",
			"[WAIT|1.5",
			"[RESPONSE|Ben?|1|You there?|1",
			"[WAIT|1",
			"Yeah, I'm still here",
			"Must be the blizzard",
			"[RESPONSE|Blizzard?|1|So what\nhappened?|Oh, so as we were nearing Gilgit, I asked him to take me on a quick pass over one of the ranges--the Karakoram I think he called it",
			"Yeah, there's quite a storm out there",
			"I'm fine for now",
			"I'm taking shelter in the helicopter wreckage",
			"It's getting real chilly in here though",
			"[RESPONSE|What happened?|1|Wreckage?|1",
			"Oh, so as we were nearing Gilgit, I asked him to take me on a quick pass over one of the ranges--the Karakoram I think he called it", //KEY
			"He told me it was getting late and that the wind was starting to pick up, and kept flying towards Gilgit",
			"But . . . it is Pakistan after all.",
			"There's not much you can't do with a bit of cash",
			"[WAIT|1",
			"We should not have kept going",
			"[WAIT|1",
			"By the time we realized it we were dealing with a full on blizzard, and by then it was too late to do anything",
			"The wind knocked the chopper off balance, and we fell",
			"[WAIT|1",
			"The pilot . . . he's dead",
			"His restraint didn't hold up and I think he hit his head",
			"There's a . . . a lot of blood",
			"[RESPONSE|Try not to look|1|What's your status?|3",
			"I can't seem to help it though. My eyes keep drifting over to him",
			"[RESPONSE|Are you injured?|Miraculously, I seem to be ok, apart from a few bruises|What's your status?|1",
			"You mean besides the fact that I'm huddled up in the skeleton of a wrecked helicopter in the middle of nowhere, trying not to freeze to death?", //KEY
			"[RESPONSE|Are you injured?|1|Yes, besides that.|1",
			"Miraculously, I seem to be ok, apart from a few bruises", //KEY
			"And I've had a little bit of time to get over the shock of the whole thing",
			"My cell phone's useless out here, so without any means of contacting anyone I just kind of sat in utter hopelessness for a bit",
			"I finally got restless and began to search the wreck for a radio or something",
			"Lucky this backpack was in here",
			"That's where I found this satellite phone . . . also a few extra batteries, canned food, some water, and a compass",
			"I guess the pack's here in case of emergencies",
			"[WAIT|1",
			"I'm pretty sure this qualifies as an emergency",
			"[RESPONSE|How's your\nfood supply?|1|Where are you?|That is a good question",
			"It looks like I have several days worth if I make it last",
			"I’ll probably freeze to death long before I run out of food",
			"[WAIT|1.5",
			"Well that was a cheery thought",
			"[WAIT|1",
			"However, I'm not sure how long I'll need to make the food last",
			"[SKIP|2",
			"That is a good question", //KEY
			"I'm somewhere in the vicinity of Gilgit",
			". . . somewhere east of the city",
			"For all I know though, I could be twenty miles away, or a hundred",
			"[WAIT|1",
			"So, what are the chances of another helicopter coming by to pick me up?",
			"[RESPONSE|Not good|1|Jack?|1",
			"[RESEARCH|JACK:\nPickup right now is a no-go. Local sources are measuring wind speeds of up to sixty miles an hour",
			"[WAIT|1",
			"So you're saying I have to . . . walk?",
			"[RESPONSE|I'm afraid so|1|Yes|1",
			"Fun",
			"It would definitely help to know exactly where I was",
			"But if I'm east of Gilgit, I guess I just head west",
			"How should I start?",
			"[RESPONSE|Try to find a map|1|Start walking|You sure I should go out in this?",
			"Ok, give me a minute to look",
			"[SYS|Ben is busy|3",
			"Couldn’t find a map anywhere",
			"I did find a thin blanket, though, which could really be helpful",
			"So, what do I do now?",
			"It’s starting to get dark . . . and cold",
			"Should I head out now, or get a bit of shut-eye first?",
			"[RESPONSE|Get going now|1|Get some sleep|Yeah, someone would have to be pretty dumb to go out in this weather",
			"You sure I should go out in this?", //KEY
			"It’ll already be hard to hike with this wind, but in the dark too . . .",
			"[RESPONSE|Start walking|1|Ok, wait\nuntil morning|Yeah, someone would have to be pretty dumb to go out in this weather",
			"Ok, I’m trusting you on this",
			"[SYS|Ben is busy|13",
			"Umm. I can’t see a thing. Maybe I should head back",
			"Wait, which way’s back? I think it was this way",
			"[SYS|Ben is busy|7",
			"Ok, so I have no idea where I am",
			"I thought I was heading back toward the wreck, but I would've thought I'd reach it by now",
			"[SYS|Ben is busy|10",
			"i don’t think . . . good idea to . . . this weather",
			"i'm really . . .",
			". . . cold",
			"[SYS|Static",
			"[WAIT|2",
			"[RESPONSE|Ben?|1|You there?|1",
			"[SYS|Static",
			"[GAMEOVER|Ben lost consciousness and collapsed. He eventually froze to death.|How should I start?",
			"Yeah, someone would have to be pretty dumb to go out in this weather", //KEY
			"Ok, I guess I’ll talk to you in the morning",
			"[SYS|Ben is busy|480",
			
			
			//DAY 2
			
			"Well, good news is I didn’t freeze to death last night",
			"But I don’t think there’s a single part of my body that doesn’t ache right now",
			"I guess our bodies weren’t made to fall out of the sky",
			"Still windy as ever outside the wreck, but the snow seems to have thinned a little. I can actually see the area around me now",
			"It looks like we crash-landed at the bottom of a valley. There are hills all around with this valley snaking between them",
			"Well, “hills” is probably quite an understatement. According to the pilot, many of these peaks are over twenty thousand feet high",
			"Even at the bottom of this valley I must be higher than most peaks back home",
			"And I have to hike across this terrain",
			"Anyways, what should I do this morning? I could get an early start on my trip and think about breakfast later, but my stomach's already growling",
			"[RESPONSE|Head out now|Good thinking. I am starting to feel a little claustrophobic in here, and it’ll feel good to finally be making some progress|Eat something first|1",
			"Great! I’m starving",
			"[SYS|Ben is busy|8",
			"Yum. I guess it's time to go now",
			"[WAIT|1",
			"[SKIP|Here we go! I am off to find Gilgit!",
			"Good thinking. I am starting to feel a little claustrophobic in here, and it’ll feel good to finally be making some progress", //KEY
			"Here we go! I am off to find Gilgit!",
			"[WAIT|3",
			"The door's stuck",
			"[WAIT|2",
			"Great start to my journey",
			"I guess the frame got bent in the crash",
			"[RESPONSE|Kick it open|1|Break the window|Ok, I'll try that. Give me a minute",
			"Ok, hang on a sec",
			"[SYS|Ben is busy|0.5",
			"Well that didn't work",
			"The only difference is now my leg hurts more",
			"I guess I'll have to break the window",
			"[SKIP|SYS",
			"Ok, I'll try that. Give me a minute", //KEY
			"[SYS|Ben is busy|1", //KEY
			"Well, hopefully the travel agency doesn't hold me liable for broken windows",
			"[WAIT|1",
			"Huh. The helicopter looks like it held up surprisingly well",
			"I'm not saying it's flyable or anything, but it's all in one piece",
			"The snow must've provided some cushion",
			"[WAIT|3",
			"Wow",
			"This view is both incredibly beautiful and utterly terrifying",
			"If it weren't for the fact that I could die out here, I might just stop and enjoy the scenery",
			"Ah well. At least I'll have something to look at while I walk",
			"So now I just head back west and hope I end up in Gilgit? Sounds like a plan",
			"[WAIT|2",
			"Hey! This valley is actually heading in the right direction. What luck",
			"Well, off I go. I'll keep you posted",
			"[SYS|Ben is busy|120",
			
			"Well this crazy weather didn't help much, but I've managed to make some progress",
			"At least I think I have. I can't see the crash site anymore . . .",
			". . . but then again I haven't been able to see much of anything since the snow picked up again",
			"But seeing as I'm just blindly following my compass, I really don't need to see where I'm going . . .",
			". . . as long as I don't walk off the edge of a cliff or something",
			"Sorry. I'm just rambling",
			"Being out here alone, it's good to have someone to talk to",
			"Anyways, I'm starting to get pretty tired. You think I've earned a short break?",
			"[RESPONSE|Sure, take a break|1|You have to\nkeep walking|Ok, I guess I'll just have to grin and bear it",
			"Thank goodness. My legs could sure use a rest after plowing through all this snow",
			"The base of this hill--if you can call it that--has a couple patches of bare rock",
			"I'll just take a quick breather",
			"[SYS|Ben is busy|15",
			"Well, that felt good, but I probably should move on before I become a permanent feature of this landscape",
			"[SKIP|SYS",
			"Ok, I guess I'll just have to grin and bear it", //KEY
			"It's probably better not to linger out here in this weather anyway",
			"I'll check back with you in a bit",
			"[SYS|Ben is busy|75", //KEY
			
			"Well, I'm now face to face with another mountain, and the trail I've been following curves off in a more northerly direction",
			"So, I could keep following the trail, and hope I don't end up too far north",
			"Or I could stay true to my compass and cut straight across",
			"[RESPONSE|Start climbing|1|Keep to the valley|Yeah, it's probably safer to stay down here",
			"Ok, I'll give it a shot. I must warn you though, I'm not much of a mountaineer",
			"Seeing as I don't have any climbing gear, it looks like there are only two potential paths up the mountain . . .",
			". . . one is farther north, one farther south. Which should I take?",
			"[RESPONSE|South|1|North|Ok, north it is",
			
			"Ok, south it is",
			"It's a little ways away. I'll let you know when I start climbing",
			"[SYS|Ben is busy|20",
			"Ok, I've made it to the base of the mountain",
			"It's gonna take a while, but hopefully this is quicker than going around",
			"[SYS|Ben is busy|90",
			"Whoa, I can barely see the valley way down there. I must be pretty high up",
			"So, it's really been a struggle to make it up this far, and I would hate to turn back now . . .",
			". . . but it's starting to get really steep",
			"I can even see the top of the ridge in the distance, but it's going to be a really tough climb, especially without equipment",
			"Do you think I should try it, or is it too risky?",
			"[RESPONSE|Go for it|1|No, turn back|I agree. One bad step, and that would be it",
			"Ok, here goes nothing",
			"[SYS|Ben is busy|20",
			"[SYS|Connection Lost",
			"[GAMEOVER|Ben lost his footing and fell to his death|Well, I'm now face to face with another mountain, and the trail I've been following curves off in a more northerly direction",
			
			"I agree. One bad step, and that would be it", //KEY
			"I'll just head back to the path and hope I don't end up too far north",
			"I'll let you know when I get there",
			"[SYS|Ben is busy|95",
			"Ok, I'm back on the path. Now I have to decide:",
			"Do I want to try the north pass, or stick to the valley?",
			"[RESPONSE|North|1|Keep to the valley|Yeah, it's probably safer to stay down here",
			"Ok, hopefully I'll have more success this time", //KEY
			"[SKIP|2",
			"Ok, north it is",
			"It's a bit of a walk to the base of the mountain. I'll let you know when I start climbing",
			"[SYS|Ben is busy|20",
			"I've reached the base",
			"Wish me luck",
			"[SKIP|WAIT",
			
			"Yeah, it's probably safer to stay down here", //KEY
			"[SYS|Ben is busy|100",
			"Um . . . I just reached the end of the valley",
			"Looks like there's no way past this range without going over it, so I guess I'm climbing after all",
			"However, it does look easier than the paths earlier",
			"Anyways, I'm gonna get climbing",
			
			"[WAIT|0", //KEY (Placeholder)
			"[SYS|Ben is busy|110",
			"Phew! I can't believe I made it",
			"I literally just free climbed a mountain. I mean, it wasn't straight up or anything . . . but still!",
			"I'm at the top of the ridge, trying not to let the wind knock me off",
			"There's a little valley ahead that seems to run straight down to the base of the mountain",
			"[WAIT|2",
			"Man, it's already starting to get dark. Hopefully going down is quicker than it was coming up . . .",
			". . . otherwise I'm gonna to be blindly stumbling down the mountain in the dark",
			"[SYS|Ben is busy|50",
			
			"Well, I warned you",
			"Stumbling down the mountain in the dark is exactly what I'm doing",
			"[WAIT|2",
			"Argh . . .", //KEY!!
			"I can't seem to find a firm foothold anywhere!",
			"I'm gonna twist an ankle if I keep this up!",
			"I think my best shot would be to wait for morning to continue",
			"It seems to be snowing harder too, but if I bundle up I think I have a chance of making it through the night",
			"What do you think? Should I keep trying to fight my way to the bottom, or try to survive until morning up here?",
			"[RESPONSE|Wait for morning|Ok, I guess I'll see if the little I have with me is enough to keep warm|Keep going|1",
			
			"Yeah, I guess chance of survival up here is pretty slim",
			"Ok, here we go",
			"I just have to make it down in one piece",
			"I think in the future I would . . .",
			"ahh!",
			"[SYS|Connection Lost",
			"[GAMEOVER|Ben slipped and hit his head on a rock. He eventually froze to death|Argh . . .",
			
			"Ok, I guess I'll see if the little I have with me is enough to keep warm", //KEY
			"Can't see a thing out here",
			"If only I thought to bring a flashlight with me. Or a warm blanket",
			"You don't really think of these things living in the land of 24/7 electricity and year-round warmth",
			"I guess I just sleep right where I am. Can't very well see any alternatives",
			"Oh well. I'm gonna have a bite to eat and then see if I can fall asleep",
			"I hope to talk to you in the morning",
			"[RESPONSE|Stay warm|1|Goodnight|SYS",
			"I'll try . . .",
			"[SYS|Ben is busy|500", //KEY
			
			//DAY 3
			
			"Wha-? What's going on?",
			"What was that?",
			"[WAIT|2",
			"the moun-- the side of the mountain's falling!",
			". . . its all sliding towards me!",
			"[RESPONSE|It's an avalanche!|1|Run!|already running",
			"running!",
			"[SKIP|2",
			"already running", //KEY
			"wait! my backpack . . . i forgot to grab it!", //KEY
			"it has all my food",
			"and the compass!",
			"[RESPONSE|Go back for it|1|Forget it|but i need that stuff! i can't . . .",
			"i'd better be quick about it",
			"[WAIT|5",
			"got it! im heading back down!",
			"i don't think im gonna . . .",
			"[SYS|Connection Lost",
			"[GAMEOVER|Ben was buried by the avalanche|wait! my backpack . . . i forgot to grab it!",
			
			"but i need that stuff! i can't . . .", //KEY
			"[WAIT|1",
			"oh crap",
			"[WAIT|1",
			"im going",
			"[SYS|Ben is busy|3",
			"Whoa. That was way too close",
			"I'm lucky there was a small ditch back there",
			"I slipped and fell in and the next thing I knew the avalanche had passed",
			"No sign of my stuff though. All I've got left is this phone", //That I had clenched in my fist?
			". . . and no spare batteries",
			"[WAIT|1",
			"And I can't believe I stuck the compass in my bag last night!",
			"What am I supposed to do now?",
			"Even if I can find my way without the compass . . .",
			". . . what am I going to do without food or water?",
			"[WAIT|5",
			"[RESPONSE|Ben?|1|You still there?|1",
			"[WAIT|3",
			"Yeah, I'm here",
			"[WAIT|1",
			"Just coming to terms with the fact that I'm probably not ever making it back",
			"[WAIT|1",
			"And trying to decide on my next move",
			"[RESPONSE|I don't know|1|You're gonna\nmake it!|Always the optimist",
			"Yeah, that makes two of us",
			"[SKIP|2",
			"Always the optimist", //KEY
			"I guess I'll just make it down the mountain for starters", //KEY
			"[SYS|Ben is busy|3",
			"Hey! I can't believe I'm just now noticing this . . .",
			"It's not snowing anymore",
			"Weird. Everything looks so different now that it's not all white and I can see past fifty feet",
			"[WAIT|1",
			"[RESEARCH|JACK:\nSorry to interrupt. I've actually got some good news for you, Ben",
			"[RESEARCH|Now don't get your hopes up just yet; we still have no idea where you are and finding you will be like searching for a needle in a haystack . . .",
			"[RESEARCH|. . . but we were finally able to send out a helicopter to search for you",
			"Great news!",
			"Just tell them, to find me, look for a mountain that's covered in snow",
			"[RESPONSE|Loads of\nhelp, Ben|I do what I can|That's no\nhelp at all|1",
			"Just telling you what I know",
			"[SKIP|2",
			"I do what I can", //KEY
			"[WAIT|1",
			"Ok, I'm gonna make my way down the mountain before another avalanche comes and kills me",
			"[SYS|Ben is busy|27",
			"Whoa. This view. It's breathtaking",
			"Without the blizzard, it's so . . .",
			"[WAIT|0.5",
			". . . peaceful",
			"[WAIT|1.5",
			"I'm sure you're jealous you're not here to see it",
			"[RESPONSE|So jealous|1|Nah, I'll let\nyou enjoy it|2",
			"Yeah, I mean, don't you wish now that you were the one stranded out here?",
			"I think you're missing out on an amazing opportunity", //KEY
			"[WAIT|1",
			"Well, since you can't be here, I guess you could settle for Googling this place",
			"Meanwhile, I'm gonna keep walking",
			"See you at the bottom",
			"[SYS|Ben is busy|71",
			
			"Well, I can't say I hiked down that mountain, cause I more or less slid down half of it last night",
			"But my feet are once again planted on firm ground, and that's all that matters",
			"[WAIT|1",
			"So, I can only estimate based on the sun, but it looks like this valley heads off in a north-westerly direction",
			"Not ideal for where I'm trying to go, but after my short excursion over the last range, I'm not about to begin round two",
			"[WAIT|2",
			"You know . . . that helicopter would be very welcome right about now. Getting kind of tired of walking everywhere",
			"[WAIT|2",
			"Maybe up ahead I'll find an easier pass through this range",
			"Anyways, I'm gonna have a quick breakfast and then get to it. Catch you later",
			"[SYS|Ben is busy|145",
			"Well, I still don't see a way over this range",
			"I'm also wondering if I'll ever find my way back without a compass",
			"And to top it all off, the satphone battery's almost dead",
			"[RESPONSE|It'll be ok|1|Just keep walking|Well yeah, I guess that's all I can do",
			"Yeah, we'll see",
			"[SKIP|SYS",
			"Well yeah, I guess that's all I can do", //KEY
			"[SYS|Ben is busy|32",
			"Um . . . There are people up ahead",
			"[WAIT|1",
			"Like, actual people",
			"What am I supposed to do?",
			"[RESPONSE|Stay away|1|Move closer|Ok, give me a minute",
			"Hmmm . . . I'll just get a little closer",
			"Don't worry. They won't see me",
			"[SKIP|SYS",
			"Ok, give me a minute", //KEY
			"[SYS|Ben is busy|1", //KEY
			"Ok, I have a better position now",
			"[WAIT|1",
			"They're quite a large group, many with packs on their backs. Hikers, maybe?",
			"[WAIT|1",
			"Several of them are carrying things over their shoulders . . . big sticks? or . . .",
			"[WAIT|1",
			"Guns", //KEY!!
			"Ok, that's worrying. I was starting to think they might be able to help me",
			"But now I'm not sure",
			"I mean, on one hand I don't really have a choice",
			"I have no idea where I am . . .",
			". . . I have no supplies or equipment . . .",
			". . . and this phone could die at any moment, leaving me completely cut off from everyone",
			"It's starting to flurry too, and the wind's picking up, so it's likely that the helicopter will have to leave me out here and return to base",
			"On the other hand, being captured, tortured, and shot is probably better than freezing or starving to death",
			"What's your verdict?",
			"[RESPONSE|Go and\nmeet them|Ok, I'm really trusting you this time|Better to\navoid them|1|",
			
			"Alright. As much as I want to be rescued, I guess it's not worth the risk",
			"I'll just keep looking for a way over this range",
			"[SYS|Ben is busy|33",
			"I can't believe it's blizzarding again",
			"I thought I was done with this",
			"It's really heavy too. Can't see a thing",
			"I hope that helicopter made it away safely",
			"The more I wander around, the more I wish I had trusted those people",
			"They probably know exactly where they're headed",
			"And here I am hopelessly lost",
			"I guess I'v--",
			"[SYS|Connection Lost",
			"[GAMEOVER|The satphone ran out of juice. Ben fought through the blizzard for hours before collapsing from exhaustion. He eventually froze to death.|Guns",
			
			"Ok, I'm really trusting you this time", //KEY
			"I'll see if I can get their attention",
			"[SYS|Ben is busy|30",
			"Oh my gosh. We definitely made the right choice",
			"I had to run to catch up with them, and by the time I reached them I was almost dying from exhaustion",
			"I'm sure I looked like a crazy man to them . . .",
			". . . running across the snow, waving my arms in the air . . . only to collapse right in front of them",
			"It's a wonder they didn't just shoot me out of fright",
			"[WAIT|1",
			"No, they've actually been incredible",
			"They woke me up a little while later, and I am telling you . . .",
			". . . after days of freezing my butt off and eating canned food . . .",
			". . . waking up to hot tea and bread, and in a tent . . . was heaven on earth",
			"[WAIT|1",
			"One of the men actually speaks a little English, if you can believe that!",
			"He told me they're on their way to the town of Karimabad, which is about thirty miles away, but much closer than Gilgit",
			"And he said they'd like for me to come with them!",
			"[RESPONSE|So glad\nto hear it!|1|I told you\nyou'd make it|1",
			"Thanks for sticking with me",
			"I never would've made it this far without your help",
			"[RESPONSE|It's my job|1|Anytime, Ben|1",
			"[RESEARCH|JACK:\nI've contacted our people in Gilgit. They're sending a jeep to meet you in Karimabad",
			"[RESEARCH|They'll meet you at the Darbar Hotel, right in the middle of town. Huge glass windows. Can't miss it",
			"[WAIT|1",
			"Ok, tell them I'll be there",
			"[WAIT|2",
			
			"[GAMEOVER|You have reached the end of the story.\n\nThanks for playing.|BEGINNING"
		]
		
		//let time2 = NSDate()
		//print(time2.timeIntervalSinceDate(time1))

	}
	
	
//VIEWDIDAPPEAR
	override func viewDidAppear(_ animated: Bool) {
		
		//ScrollToBottom - Normal function does not work here. Must be delayed
		if messagesViewed.count > Int(table.frame.height / table.rowHeight) {
			delay(0.1) {
				let indexPath = IndexPath(row: self.messagesViewed.count - 1, section: 0)
				self.table.scrollToRow(at: indexPath, at: .bottom, animated: false)
			}
		}
		
		//MARK - Alert: Update Detected
		if newGame == true {
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
