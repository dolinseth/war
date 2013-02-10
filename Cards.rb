class Card
	def initialize(number, suit)
		@suit = suit
		@number = number
	end
	
	def number
		@number
	end

	def values
		{"J" => 11, "Q" => 12, "K" => 13, "A" => 14}
	end

	def value
		if ["J", "Q", "K", "A"].include? @number
			values[@number]
		else
			@number.to_i
		end
	end

	def suit
		if @suit == "spades"
			puts "spades"
		elsif @suit == "hearts"
			puts "hearts"
		elsif @suit == "clubs"
			puts "clubs"
		elsif @suit == "diamonds"
			puts "diamonds"
		end
	end
	
	def to_s
		"#{@number} of #{@suit}"
	end

	def color
		if @suit == "spades" || @suit == "clubs"
			puts "black"
		elsif @suit == "hearts" || @suit == "diamonds"
			puts "red"
		end
	end

	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end	
end

class Deck
	def initialize
		@cards = []
		["spades", "hearts", "clubs", "diamonds"].each do |suit|
			["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"].each do |number|
				@cards << Card.new(number, suit)
			end
		end
	end

	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end

	def cards
		@cards
	end
	
	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end
end

class WarGame
	def initialize(player_one_name = "Player 1", player_two_name = "Player 2", number_of_decks = 1)
		@player_one_name = player_one_name
		@player_two_name = player_two_name
		@shoe = Shoe.new(number_of_decks)
		@player_one = Player.new(@shoe.draw(26 * number_of_decks))
		@player_two = Player.new(@shoe.draw(26 * number_of_decks))
	end

	def play
		while @player_one.cards.count > 0 && @player_two.cards.count > 0
			player_one_card_one = @player_one.draw_one
			player_two_card_one = @player_two.draw_one
			puts "#{player_one_card_one} vs. #{player_two_card_one}"
			if player_one_card_one.value > player_two_card_one.value
				@player_one.cards << player_two_card_one
			elsif player_two_card_one.value > player_one_card_one.value
				@player_two.cards << player_one_card_one
			elsif player_one_card_one.value == player_two_card_one.value
				@player_two.cards << player_one_card_one
				# War.new(@player_one, @player_two).war
			end
			puts "#{@player_one.cards.count} vs. #{@player_two.cards.count}"
		end

		if @player_one.cards.count == 0
			puts "player two wins!"
		elsif @player_two.cards.count == 0
			puts "player one wins!"
		end
	end
	
	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end
end

# class War
# 	def initialize(player_one, player_two)
# 		@player_one = player_one
# 		@player_two = player_two
# 		@player_one_card_war_bounty = @player_one.draw(3)
# 		@player_two_card_war_bounty = @player_two.draw(3)
# 		@player_one_card_war_decider = @player_one.draw_one
# 		@player_two_card_war_decider = @player_two.draw_one
# 	end

# 	def war
# 		if @player_one_card_war_decider.value > @player_two_card_war_decider.value
# 			player_one.cards << player_two_card_war_decider
# 			player_one.cards << player_two_card_war_bounty
# 		elsif player_two_card_war_decider.value > player_one_card_war_decider.value
# 			player_two.cards << player_one_card_war_decider
# 			player_two.cards << player_one_card_war_bounty
# 		elsif player_one_card_one.value == player_two_card_one.value
# 			War.new.war
# 		end
# 	end
	
# 	def draw(number_of_cards = 1)
# 		card = @cards.sample(number_of_cards)
# 		@cards = @cards - card
# 		card
# 	end
# end

class Player
	def initialize(cards)
		@cards = cards
	end
	
	def cards
		@cards
	end
	
	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end

	def draw_one
		draw(1).first
	end
end

class Shoe
	def initialize(number_of_decks = 1)
		@number_of_decks = number_of_decks
		@cards = []
		number_of_decks.times do
			@cards << Deck.new.cards
		end
		@cards = @cards.flatten
	end

	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end
end