# frozen_string_literal: true

module Roller
  class WoD
    private_class_method :parse_args

    DEFAULT_DIFFICULTY = 6

    attr_reader :number, :difficulty, :explode, :rolls, :extra_rolls

    def initialize(number, difficulty, explode: true)
      @number = number
      @difficulty = difficulty
      @explode = explode
    end

    def self.parse(args)
      new(*parse_args(args))
    end

    def self.noexplode_parse(args)
      new(*parse_args(args), explode: false)
    end

    def self.parse_args(args)
      args = args.split

      begin
        number = Integer(args.shift)
      rescue StandardError
        raise ArgumentError, 'Invalid number of dice.'
      end

      diff_str = args.shift
      if diff_str
        begin
          difficulty = Integer(diff_str)
        rescue StandardError
          raise ArgumentError, 'Invalid difficulty.'
        end
      else
        difficulty = DEFAULT_DIFFICULTY
      end

      [number, difficulty]
    end

    def roll
      @rolls = roll_dice(@number)

      @extra_rolls = []
      @extra_rolls = roll_exploding_dice(@rolls) if @explode

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
