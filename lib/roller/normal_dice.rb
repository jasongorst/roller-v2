module Roller
  class NormalDice
    PATTERN = /^(?<number>\d+)?[dD](?<sides>\d+)(?<modifier>[+-]\d+)?$/

    attr_accessor :number, :sides
    attr_reader :rolls, :total

    def initialize(number, sides, modifier = 0)
      @number = number
      @sides = sides
      @modifier = modifier
    end

    def self.parse(args)
      match = args.match(PATTERN)
      raise(ArgumentError, "Invalid die notation: #{args}") if match.nil?

      number = if match[:number].nil?
                 1
               else
                 Integer(match[:number])
               end

      raise(ArgumentError, 'Number of dice can\'t be zero.') if number.zero?

      sides = Integer(match[:sides])
      raise(ArgumentError, 'Number of sides can\'t be zero.') if sides.zero?

      modifier = if match[:modifier].nil?
                   0
                 else
                   Integer(match[:modifier])
                 end

      new(number, sides, modifier)
    end

    def roll
      @rolls = Array.new(@number) { rand(1..@sides) }
      @total = @rolls.inject(:+) + @modifier

      self
    end

    def modifier
      if @modifier.zero?
        ''
      else
        format('%+d', @modifier)
      end
    end
  end
end
