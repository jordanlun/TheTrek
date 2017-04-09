//: Playground - noun: a place where people can play

import UIKit

var messageIndex = -1
var newMessageIndex = -1

var messageArray = [String]()


func advanceToMessage(_ message : AnyObject) {
	//MARK - Can advance by number or to next RESEARCH, SYS, WAIT, or specific message
	let msg = message as! String
	if let _ = Int(msg) {
		newMessageIndex += Int(msg)!
	} else if msg == "RESEARCH" || msg == "SYS" || msg == "WAIT" {
		while msg != splitMessage(messageList[newMessageIndex])[0] {
			newMessageIndex += 1
		}
	} else {
		while msg != messageList[newMessageIndex] {
			if newMessageIndex < messageList.count - 2 {
				newMessageIndex += 1
			} else {
				print("advanceToMessage error|Index: \(newMessageIndex)")
				return
			}
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




let messageList = masterMessageList
print(messageList)



while messageIndex <= messageList.count - 1 {
	messageIndex += 1
	newMessageIndex = messageIndex
	
	let message = messageList[messageIndex]
	
	if message.characters.first! == "[" {
		messageArray = splitMessage(message)
	} else {
		messageArray = ["MESSAGE", message]
	}
	
	if messageArray[0] == "RESPONSE" {
		advanceToMessage(messageArray[1] as AnyObject)
	}
}