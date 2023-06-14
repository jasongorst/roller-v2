# frozen_string_literal: true

require 'abbrev'

module Roller
  class WoD
    DEFAULT_DIFFICULTY = 6

    attr_reader :number, :difficulty, :explode, :rolls, :extra_rolls

    def initialize(number, difficulty, explode = true)
      @number = number
      @difficulty = difficulty
      @explode = explode
    end

    def self.parse(args)
      # format: number difficulty [noexplode]
      args = args.split
      number = Integer(args.shift) rescue raise(ArgumentError, 'Invalid number of dice.')

      diff_str = args.shift
      difficulty = if diff_str
                     Integer(diff_str) rescue raise(ArgumentError, 'Invalid difficulty.')
                   else
                     DEFAULT_DIFFICULTY
                   end

      explode = !Abbrev.abbrev(['noexplode']).keys.include?(args.shift)

      new(number, difficulty, explode)
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
