module Roller
  class WorldOfDarkness
    EXPLODE = "explode"
    DEFAULT_DIFF_STR = 6

    attr_accessor :number, :difficulty, :explode
    attr_reader :rolls, :extra_rolls

    def initialize(number, difficulty, explode: false)
      @number = number
      @difficulty = difficulty
      @explode = explode
    end

    def self.parse(args)
      # FORMAT: {number of dice} {difficulty} ["explode"]
      args = args.split

      number_str = args.shift
      number = Integer(number_str) rescue 0
      raise(ArgumentError, "Invalid number of dice: #{number_str}.") unless number.positive?

      diff_str = args.shift || DEFAULT_DIFF_STR
      difficulty = Integer(diff_str) rescue 0
      raise(ArgumentError, "Invalid difficulty: #{diff_str}.") if difficulty < 2 || difficulty > 10

      explode_str = args.shift

      explode = if explode_str
        EXPLODE.start_with?(explode_str.downcase)
      else
        false
      end

      new(number, difficulty, explode: explode)
    end

    def roll
      @rolls = roll_dice(@number)

      @extra_rolls = if @explode
                       roll_exploding_dice(@rolls)
                     else
                       []
                     end

      self
    end

    def successes
      @rolls.count { |r| r >= @difficulty }
    end

    def failures
      @rolls.count { |r| r == 1 }
    end

    def extra_successes
      @extra_rolls.count { |r| r >= @difficulty }
    end

    def check
      successes + extra_successes - failures
    end

    def success?
      check.positive?
    end

    def failure?
      check.zero?
    end

    def botch?
      check.negative?
    end

    private

    def roll_dice(number)
      Array.new(number) { rand(1..10) }
    end

    def roll_exploding_dice(rolls)
      tens_count = tens(rolls)

      if tens_count.positive?
        exploding_roll = roll_dice(tens_count)
        exploding_roll + roll_exploding_dice(exploding_roll)
      else
        []
      end
    end

    def tens(rolls)
      rolls.count { |r| r == 10 }
    end
  end
end
