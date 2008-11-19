module Stick

  # Provides basic statistical methods, i.e., sum, average, variance,
  # standard deviation, min and max.
  #
  module Enumerable

    # Generates a hash mapping each unique element in the array
    # to the relative frequency, i.e. the probablity, of
    # it appearence.
    #
    #   CREDIT: Brian Schröder

    def probability
      probs = Hash.new(0.0)
      size = 0.0
      each do | e |
        probs[e] += 1.0
        size += 1.0
      end
      probs.keys.each{ |e| probs[e] /= size }
      probs
    end

    # old def
    #
    #   def probability
    #     arr = self.to_a
    #     probHash = Hash.new
    #     size = arr.size.to_f
    #     arr.uniq.each do |i|
    #       ct = arr.inject(0) do |mem,obj|
    #         obj.eql?(i) ? (mem+1) : mem
    #       end
    #       probHash[i] = ct.to_f/size
    #     end
    #     probHash
    #   end

    # Shannon's entropy for an array - returns the average
    # bits per symbol required to encode the array.
    # Lower values mean less "entropy" - i.e. less unique
    # information in the array.
    #
    #   %w{ a b c d e e e }.entropy  #=>
    #
    #   CREDIT: Derek

    def entropy
      arr = to_a
      probHash = arr.probability
      # h is the Shannon entropy of the array
      h = -1.to_f * probHash.keys.inject(0.to_f) do |sum, i|
        sum + (probHash[i] * (Math.log(probHash[i])/Math.log(2.to_f)))
      end
      h
    end

    # Returns the maximum possible Shannon entropy of the array
    # with given size assuming that it is an "order-0" source
    # (each element is selected independently of the next).
    #
    #   CREDIT: Derek

    def ideal_entropy
      arr = to_a
      unitProb = 1.0.to_f / arr.size.to_f
      (-1.to_f * arr.size.to_f * unitProb * Math.log(unitProb)/Math.log(2.to_f))
    end

    # Generates a hash mapping each unique symbol in the array
    # to the absolute frequency it appears.
    #
    #  CREDIT: Brian Schröder

    def frequency
      #probs = Hash.new(0)
      #each do |e|
      #  probs[e] += 1
      #end
      #probs
      inject(Hash.new(0)){|h,v| h[v]+=1; h}
    end

    # Returns all items that are equal in terms of the supplied block.
    # If no block is given objects are considered to be equal if they
    # return the same value for Object#hash and if obj1 == obj2.
    #
    #   [1, 2, 2, 3, 4, 4].commonality # => { 2 => [2], 4 => [4] }
    #
    #   ["foo", "bar", "a"].commonality { |str| str.length }
    #   # => { 3 => ["foo, "bar"] }
    #
    #   # Returns all persons that share their last name with another person.
    #   persons.collisions { |person| person.last_name }
    #
    #   CREDIT: Florian Gross

    def commonality( &block )
      had_no_block = !block
      block ||= lambda { |item| item }
      result = Hash.new { |hash, key| hash[key] = Array.new }
      self.each do |item|
        key = block.call(item)
        result[key] << item
      end
      result.reject! do |key, values|
        values.size <= 1
      end
      #return had_no_block ? result.values.flatten : result
      return result
    end

    # Like commonality but returns an array of duplicates.

    #def collisions(&blk) #:yield:
    #  a = []
    #  commonality(&blk).each{ |k,v| a.concat(v) }
    #  a.uniq
    #end

    # Returns sum.  When a block is given, summation is taken over the 
    # each result of block evaluation.
    #
    def sum
      sum = 0.0
      if block_given?
        each{|i| sum += yield(i)}
      else
        each{|i| sum += i}
      end
      sum
    end

    def average(&blk)
      sum(&blk)/size
    end

    alias_method :avg, :average

    def variance(&blk)
      sum2 = if block_given?
               sum{|i| j=yield(i); j*j}
             else
               sum{|i| i**2}
             end
      sum2/size - average(&blk)**2
    end

    alias_method :var, :variance

    def standard_deviation(&blk)
      Math::sqrt(variance(&blk))
    end

    alias_method :std, :standard_deviation

    def Min(&blk)
      if block_given?
        if min = find{|i| i}
          min = yield(min)
          each{|i|
            j = yield(i)
            min = j if min > j
          }
          min
        end
      else
        min()
      end
    end

    def Max(&blk)
      if block_given?
        if max = find{|i| i}
          max = yield(max)
          each{|i|
            j = yield(i)
            max = j if max < j
          }
          max
        end
      else
        max()
      end
    end

  end

  # class String
  #
  #   NOTE: String#entropy has been deprecated.
  #   Use str.chars.entropy instead.
  #   def entropy
  #     split(//).entropy
  #   end
  #
  #   # Not needed b/c ideal_entropy is only dependent on size.
  #   # def ideal_entropy
  #   #   self.split(//).ideal_entropy
  #   # end
  #
  # end

end


module Enumerable #:nodoc:
  include Stick::Enumerable
end

