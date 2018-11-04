extends Resource


#Cards.gd script
#
#
#
#



#Suits, values and color enums
enum {SPADES, CLUBS, DIAMONDS, HEARTS}
enum {ACE = 1, JACK = 11, QUEEN, KING}

const DECKSIZE = 52
var fields = [] #Array of arrays, each capable of storing dictionaries
var deck = [] #Array of dectionaries, item 0 in fields
var deckIndex = 0 #Sets the index of the field to be treated as the deck, 0 is default

func _init():
	#Create layout of cardpool and add a deck corresponding to them exactly
	fields.append(deck)
	addDeck(fields[deckIndex])

func addField(n = 1):
	var i = 0
	
	while i < n:
		var newArray = []
		fields.append(newArray)
		i += 1

func addDeck(currField, n = 1):
	var deckCount = 0
	while deckCount < n:
		var suit = SPADES
		var value = ACE
	
		var pos = 0
	
		while pos < DECKSIZE:
			var newCard = {}
			newCard["SUIT"] = suit
			newCard["VALUE"] = value
			newCard["FACE-UP"] = false
			#TODO replace with resize and indexing for performance
			currField.append(newCard)
		
			pos += 1
			value +=1
			if(value > KING):
				value = ACE
				suit += 1
		deckCount += 1

func getField(pos):
	return fields[pos]

func flipCard(card):
	if(card.FACE_UP == true):
		card.FACE_UP = false
	else:
		card.FACE_UP = true

func setRevealed(card, faceup):
	card.FACE_UP = faceup

func createCard(field, suit, value):
	var newCard = {}
	newCard["SUIT"] = suit
	newCard["VALUE"] = value
	
	field.append(newCard)

func destroyCard(field, index):
	field.remove(index)

func drawCard(handField):
	var drawnCard = fields[deckIndex].pop_front()
	handField.append(drawnCard)
	
	#return card in case player wishes to edit its face-up property
	return drawnCard

func passCard(card, currField, newField):
	var removeIndex = currField.find(card)
	
	newField.append(card)
	currField.remove(removeIndex)

func getCard(field, index):
	#TODO Create OOB exception handling
	var tempDeck = fields[field]
	
	return tempDeck[index]
	pass

func getSuit(currCard, mask = true):
	var n = currCard.SUIT
	
	if(mask == false):
		return n
	
	if(n == SPADES):
		return 's'
	elif(n == HEARTS):
		return 'h'
	elif(n == CLUBS):
		return 'c'
	else:
		return 'd'

func getValue(currCard, mask = true):
	var ret = currCard.VALUE
	
	if(ret > ACE and ret < JACK or mask == false):
		return ret
	
	if(ret == ACE):
		return 'A'
	elif(ret == JACK):
		return 'J'
	elif(ret == QUEEN):
		return 'Q'
	else:
		return 'K'

func getDescStr(currCard, maskV = true, maskS = true):
	var strRet = ""
	strRet += str(getValue(currCard, maskV))
	strRet += str(getSuit(currCard, maskS))
	return strRet

func getPoolSize():
	var i = 0
	var ret = 0
	
	for i in getFieldCount():
		ret += getFieldSize(i)
		i += 1
	
	return ret

func getFieldCount():
	return fields.size()

func getFieldSize(pos = 0):
	if(fieldExists(pos)):
		return fields[pos].size()

func fieldExists(pos):
	if(pos >= 0 or pos < fields.size()):
		return true
	else:
		print("Index out of bounds. Field ", pos, " has size: ", fields.size())
		return null

func shuffleField(pos = 0):   #Shuffle a particular field, mainDeck is default
	if(fieldExists(pos)):
		#Why does this not work?
		#fields[pos].shuffle()
		var currField = fields[pos]
		var currSize = currField.size() - 1
		var rand
	
		randomize()
	
		while currSize > 0:
			rand = randi()%currSize
			
			var a = currField[rand]
			#Swap
			currField[rand] = currField[currSize]
			currField[currSize] = a
		
			currSize -= 1

func shuffleAll():
	var i = 0
	while i < fields.size():
		shuffleField(i)
		i += 1

func sortField(pos = 0):
	if(fieldExists(pos)):
		fields[pos].sort_custom(CardSorter, "cardSort")

func sortAll():
	
	var i = 0
	while i < fields.size():
		sortField(i)
		i += 1

func printSummary():
	var i = 0
	var fCount = getFieldCount()
	
	print("There are ", fCount," fields")
	
	for i in fCount:
		print("Field ", i," has ", fields[i].size(), " elements")

class CardSorter:

	static func cardSort(a, b):
		if(b.VALUE < a.VALUE):
			return false
		else:
			return true
