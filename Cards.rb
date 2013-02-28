class Card
	attr_accessor :number

	def initialize(number, suit)
		@suit = suit
		@number = number
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
	attr_accessor :cards

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
	
	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end
end

class WarGame
	def initialize(player_one_name = "Player 1", player_two_name = "Player 2", number_of_decks = 1)
		@shoe = Shoe.new(number_of_decks)
		@player_one = PlayerWar.new(@shoe.draw(26 * number_of_decks), player_one_name)
		@player_two = PlayerWar.new(@shoe.draw(26 * number_of_decks), player_two_name)
	end

	def play
		while @player_one.cards.count > 0 && @player_two.cards.count > 0
			WarDecider.new(@player_one, @player_two).run
		end

		if @player_one.cards.count == 0
			puts "#{@player_two.name} wins!"
		elsif @player_two.cards.count == 0
			puts "#{@player_one.name} wins!"
		end
	end
	
	def draw(number_of_cards = 1)
		card = @cards.sample(number_of_cards)
		@cards = @cards - card
		card
	end
end

class War
	def initialize(player_one, player_two, bounty)
		@player_one = player_one
		@player_two = player_two
		@bounty = bounty
	end

	def war
		if @player_one.cards.count == 3
			@bounty += @player_one.draw(2) + @player_two.draw(3)
		elsif @player_one.cards.count == 2
			@bounty += @player_one.draw(1) + @player_two.draw(3)
		elsif @player_one.cards.count == 1
			@bounty += @player_one.draw(0) + @player_two.draw(3)
		elsif @player_two.cards.count == 3
			@bounty += @player_one.draw(3) + @player_two.draw(2)
		elsif @player_two.cards.count == 2
			@bounty += @player_one.draw(3) + @player_two.draw(1)
		elsif @player_two.cards.count == 1
			@bounty += @player_one.draw(3) + @player_two.draw(0)
		else
			@bounty += @player_one.draw(3) + @player_two.draw(3)
		end
			puts "WAR! THE BOUNTY IS: #{@bounty}."
			puts "Press enter to continue."
			# gets
			WarDecider.new(@player_one, @player_two, @bounty).run
	end
end

class WarDecider
	def initialize(player_one, player_two, bounty = [])
		@player_one = player_one
		@player_two = player_two
		@bounty = bounty
	end

	def run
		player_one_card_war_decider = @player_one.draw_one
		player_two_card_war_decider = @player_two.draw_one
		@bounty += [player_one_card_war_decider, player_two_card_war_decider]
		
		puts
		puts "#{player_one_card_war_decider}"
		puts "vs."
		puts "#{player_two_card_war_decider}"
		puts
		if player_one_card_war_decider.value > player_two_card_war_decider.value
			@player_one.cards += @bounty
		elsif player_two_card_war_decider.value > player_one_card_war_decider.value
			@player_two.cards += @bounty
		elsif player_one_card_war_decider.value == player_two_card_war_decider.value
			War.new(@player_one, @player_two, @bounty).war
		end
		# puts
		# puts "#{@player_one.cards.count} cards"
		# puts "vs."
		# puts "#{@player_two.cards.count} cards"
		# puts
	end
end

class PlayerWar
	attr_accessor :cards
	attr_accessor :name

	def initialize(cards, name)
		@cards = cards
		@name = name
	end

	def draw(number_of_cards = 1)
		card = cards.sample(number_of_cards)
		@cards = cards - card
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

class Dealer < PlayerWar
	attr_accessor :cards

	def initialize(cards)
		@cards = cards
	end
end

class PlayerBlackjack < PlayerWar
	attr_accessor :cards
	attr_accessor :name

	def initialize(cards, name)
		@cards = cards
		@name = name
	end
end

class BlackjackGame
	def initialize(player_name = "Player", number_of_decks = 1, number_of_hands = 1)
		@shoe = Shoe.new(number_of_decks)
		@player = PlayerBlackjack.new([], player_name)
		@dealer = Dealer.new([])
		@number_of_hands = number_of_hands
		@dealer_win_count = 0
		@player_win_count = 0
	end

	def play
		while @number_of_hands > 0
			(@number_of_hands - 1)
			@player.cards.clear
			@dealer.cards.clear
			@player.cards << @shoe.draw(2)
			@dealer.cards << @shoe.draw(2)
			puts "You have #{@player.cards.flatten.first} showing and #{@player.cards.flatten.last} underneath."
			puts "Press ENTER to continue"
			hitorstand = gets.chomp
			@player.cards.flatten
			@dealer.cards.flatten
			while @player.cards.flatten.all.value < 22 && @dealer.cards.all.value < 22 && hitorstand != "stand"
				puts "The dealer is showing #{@dealer.cards.first}"
				puts "If you want to hit, type 'hit' if you want to stand type 'stand'"
				hitorstand.downcase
				if hitorstand == "hit"
					@player.cards << @shoe.draw_one
					puts "You draw #{@player.cards.last}"
				elsif hitorstand == "stand"
				end
			end
			if @player.cards.flatten.all.value > 21
				puts "#{player.name} busts. Dealer wins!"
			# 	@dealer_win_count + 1
			elsif @dealer.cards.flatten.all.value > 21
				puts "Dealer busts. #{player.name} wins!"
			# 	@player_win_count + 1
			elsif @dealer.cards.flatten.all.value < @player.cards.flatten[0..(@player.cards.count - 1)].value
				puts "#{player.name} wins!"
			# 	@player_win_count + 1
			elsif @player.cards.flatten.all.value < @dealer.cards.flatten[0..(@dealer.cards.count - 1)].value
				puts "Dealer wins!"
			# 	@dealer_win_count + 1
			end
			# puts "#{@player.name} has won #{@player_win_count} times."
			# puts "Dealer has won #{dealer_win_count} times."
		end
	end
end