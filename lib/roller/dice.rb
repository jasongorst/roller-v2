# frozen_string_literal: true

module Roller
  class Dice
    PATTERN = /^(?<number>\d+)?[dD](?<sides>\d+)(?<modifier>[+-]\d+)?$/

    attr_reader :number, :sides, :rolls, :total

    def initialize(number, sides, modifier = 0)
      @number = number
      @sides = sides
      @modifier = modifier
    end

    def self.parse(args)
      match = args.match PATTERN

      raise ArgumentError, "Invalid die notation: #{args}" unless match

      number = begin
                 Integer(match[:number])
               rescue StandardError
                 1
               end
      sides = Integer(match[:sides])
      modifier = begin
                   Integer(match[:modifier])
                 rescue StandardError
                   0
                 end

      new(number, sides, modifier)
    end

    def roll
      @rolls = Array.new(@number) { rand(1..@sides) }
      @total = @rolls.inject(:+) + @modifier

      self
    end

    def modifier
      if @modifier.to_i == 0
        ''
      else
        sprintf('%+d', @modifier)
      end
    end
  end
end
