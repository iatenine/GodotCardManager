extends Node

const c = preload("res://scripts/cards.gd")

func _ready():
	#Examples of how to use the cards.gd script
	#c.new() creates a pool of 52 cards, from which a "deck" can be created as a field
	var cards = c.new()
	var mainDeck = cards.fields[0]
	cards.shuffleAll()
	var passCard = mainDeck[0]
	
	cards.addField()
	var hand = cards.fields[1]
	
	cards.passCard(passCard, mainDeck, hand)
	cards.printSummary()
	cards.addField()
	cards.drawCard(hand)
	cards.drawCard(cards.fields[2])
	cards.printSummary()
	
	var i = 0
	var card
	
	while i < hand.size():
		card = cards.getCard(1, i)
		print(card)
		print(cards.getDescStr(card))
		i += 1
