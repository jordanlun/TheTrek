//
//  MessageList.swift
//  The Trek
//
//  Created by Jordan Lunsford on 3/30/17.
//  Copyright © 2017 Jordan Lunsford. All rights reserved.
//



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



import Foundation


let masterMessageList = [
	
	//DAY 1
	
	"[RESEARCH|JACK:\nGot someone on line 2. Everyone else is busy. Should I patch you through?", //KEY
	"[RESPONSE|Go ahead|WAIT|Nah|1",
	"[GAMEOVER|The caller was ignored.\nHe eventually froze to death.|RESEARCH",
	"[WAIT|0.5", //KEY; 0.5
	"[SYS|Receiving transmission",
	"[WAIT|0.5",
	"Hello?",
	"[WAIT|0.3",
	"Is anyone there?",
	"[RESPONSE|Yes, I'm here|1|Who is this?|My name is Ben",
	"Finally! You've got to help me",
	"[RESPONSE|What's wrong?|1|Who are you?|My name is Ben",
	"I should start at the beginning",
	"My name is Ben", //KEY (2)
	"A few days ago I came over to Pakistan on a business trip",
	"My meetings wrapped up early and I still had a few days in the country",
	"Knowing how I feel about mountains, a friend of mine suggested I fly up north",
	"So I took his advice and found a travel agency with helicopter tours . . . and that's what brought me here",
	"[WAIT|1.5",
	"As we were nearing Gil--",
	"[SYS|Static",
	"[WAIT|1.5",
	"[RESPONSE|Ben?|1|You there?|1",
	"[WAIT|1",
	"Yeah, I'm still here",
	"Must be the blizzard",
	"[RESPONSE|Blizzard?|1|So what\nhappened?|Oh, so as we were nearing Gilgit I asked the pilot to take me on a pass over one of the ranges . . .",
	"Yeah, there's quite a storm out there",
	"I'm fine in here . . . for now",
	"I'm taking shelter in the helicopter wreckage",
	"[RESPONSE|What happened?|1|Wreckage?|1",
	"Oh, so as we were nearing Gilgit I asked the pilot to take me on a pass over one of the ranges . . .",
	". . . the Karakoram I think he called it", //KEY
	"But he told me it was getting late and that the wind was starting to pick up, and said we needed to land",
	"However . . . it is Pakistan . . . there isn't much you can't do with a bit of cash",
	"[WAIT|1.5",
	"But we should not have kept going.",
	"That was a mistake",
	"[WAIT|1",
	"Soon we were dealing with a full on blizzard, and by that time it was too late to do anything",
	"I don't really know what happened . . .",
	". . . but suddenly the chopper rocked sideways and we fell",
	"[WAIT|2.5",
	"The pilot . . . he's . . . dead",
	"[WAIT|1.5",
	"His restraint didn't hold up and I, uh, I think he hit his head . . .",
	"[WAIT|1",
	"There's a . . . a lot of blood.",
	"[RESPONSE|Try not to look|1|What's your status?|. . .", //Could be keep calm -> stranded in the middle of nowhere?
	"I can't seem to help it though",
	"My eyes keep drifting over to him, just lying there across the dashboard",
	"Ugh, so much blood . . . I think I'm going to be sick",
	"[RESPONSE|Are you injured?|Miraculously, I seem to be ok, apart from a few bruises|What's your status?|1",
	". . .", //KEY
	"[WAIT|1.5",
	"Besides the fact that I'm stranded out in the middle of nowhere trying not to freeze to death?",
	"[RESPONSE|Yes, besides that.|1|Are you injured?|1",
	"Miraculously, I seem to be ok, apart from a few bruises", //KEY
	"And I've had a little bit of time to get over the shock of the whole thing",
	"My cell phone's useless out here, so without any means of contacting anyone I just sat for a bit trying wrap my head around it all",
	"Finally I got gave up and began to look for a radio or something",
	"Lucky this backpack was in here",
	"That's where I found this satellite phone . . . also a few extra batteries, canned food, some water, and a compass",
	"I guess the pack's in here in case of emergencies",
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
	"I'm somewhere in the vicinity of Gilgit . . .",
	". . . somewhere east of the city",
	"For all I know though, I could be twenty miles away . . . or a hundred",
	"[WAIT|1",
	"So, what are the chances of another helicopter coming by to pick me up?",
	"[RESPONSE|Not good|So you're saying I have to . . . walk?|Jack?|1",
	"[RESEARCH|JACK:\nPickup right now is a no-go. Local sources are measuring wind speeds of up to sixty miles an hour",
	"[WAIT|1",
	"So you're saying I have to . . . walk?", //KEY
	"[RESPONSE|I'm afraid so|1|Yes|1",
	"Fun",
	"It would definitely help to know exactly where I was",
	"But if I'm east of Gilgit, I guess I just head west",
	"[WAIT|2.5",
	"Brrr. It's getting pretty frigid in here",
	"[WAIT|1",
	"How should I start?",
	"[RESPONSE|Start walking|1|Search the wreckage|Ok, give me a minute",
	
	"You sure I should go out in this?",
	"It’ll already be hard to hike with this wind, but in the dark too . . .",
	"[RESPONSE|Yes, get going|1|No, wait\nuntil morning|Yeah, someone would have to be pretty dumb to go out in this weather",
	
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
	
	"Yeah, someone would have to be pretty dumb to go out in this weather",
	"So what should I do instead?",
	"[RESPONSE|Search the wreckage|Ok, give me a minute|Get some sleep|1",
	"Ok then, I guess I’ll talk to you in the morning",
	"[SKIP|[SYS|Ben is busy|472",
	
	"Ok, give me a minute", //KEY (2)
	"[SYS|Ben is busy|3",
	"Didn't find much",
	"Just an empty water bottle, a few candy wrappers . . . oh, and half a donut wedged under one of the seats",
	"[RESPONSE|That's too bad|Yeah . . .|Ooh, a donut!|1|",
	"Uh, no thanks",
	"I think I'll take the canned food . . . and leave the stale, half-eaten donut",
	"[WAIT|1.5",
	"[SKIP|2",
	"Yeah . . .",
	"Anyways, I'm gonna get some shut-eye. Talk to you in the morning",
	
	"[SYS|Ben is busy|472", // KEY
	
	
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
	"[RESPONSE|Head out now|Good thinking. I am starting to feel a little claustrophobic in here, and it’ll feel good to finally be making some progress|Eat something|1",
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
	"So, I could keep following the trail and hope I don't end up too far north",
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
	"[GAMEOVER|Ben lost his footing and fell\nto his death.|Well, I'm now face to face with another mountain, and the trail I've been following curves off in a more northerly direction",
	
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
	"I'm gonna get climbing",
	
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
	
	"Yeah, I guess chances of survival up here are pretty slim",
	"Ok, here we go",
	"I just have to make it down in one piece",
	"I think in the future I would . . .",
	"ahh!",
	"[SYS|Connection Lost",
	"[GAMEOVER|Ben slipped and hit his head on a rock. He eventually froze to death.|Argh . . .",
	
	"Ok, I guess I'll see if the little I have with me is enough to keep warm", //KEY
	"[WAIT|1.5",
	"Can't see a thing out here",
	"If only I thought to bring a flashlight with me.",
	"Or a blanket",
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
	"it has all my food. . .",
	". . . and the compass!",
	"[RESPONSE|Go back for it|1|Forget it|but i need that stuff! i can't . . .",
	"i'd better be quick about it",
	"[WAIT|5",
	"got it! im heading back down!",
	"i don't think im gonna . . .",
	"[SYS|Connection Lost",
	"[GAMEOVER|Ben was buried by the avalanche.|wait! my backpack . . . i forgot to grab it!",
	
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
	"On the other hand, freezing to death sounds more attractive to me than being captured, tortured, and shot",
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
	"Wow. We definitely made the right choice",
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
	"[WAIT|1",
	"Ben out.",
	"[WAIT|2",
	"[SYS|Connection Lost",
	"[WAIT|2.5",
	"[GAMEOVER|You have reached the end of the story.\n\nThanks for playing.|BEGINNING"
]
