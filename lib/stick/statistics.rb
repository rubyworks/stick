module Math
  EPSILON = 0.000000001

	def Math::float_equal(a, b, epsilon=EPSILON)
		c = a - b
		c *= -1.0 if c < 0
    c < epsilon
	end
end

module Stick

  # = Statistics
  #
  # == Acknowlegements
  #
  #  * Daniel Cutting & David Symonds for statarray.rb
  #
  module Statistics

    # Provides basic statistical methods, i.e., sum, average, variance,
    # standard deviation, min and max.
    #
    # TODO: General clean-up. Some of these methods have two implementations.
    # ----  They need to be reduced to one.
    #
    module Enumerable

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

      # Mean average.
      def mean(&blk)
        s = size
        return 0.0 if s == 0
        sum(&blk) / s
      end

      alias_method :average, :mean

      alias_method :avg, :mean

	    alias_method :arithmetic_mean, :mean

      #
	    def median
		    return 0 if self.size == 0
		    tmp = sort
		    mid = tmp.size / 2
		    if (tmp.size % 2) == 0
			    (tmp[mid-1] + tmp[mid]).to_f / 2
		    else
			    tmp[mid]
		    end
	    end
	
	    # The sum of the squared deviations from the mean.
      #
	    def summed_sqdevs
		    return 0 if size < 2
		    m = mean
		    map{ |x| (x - m) ** 2 }).sum
	    end

      #
      def variance(&blk)
        sum2 = if block_given?
                 sum{|i| j=yield(i); j*j}
               else
                 sum{|i| i**2}
               end
        sum2/size - average(&blk)**2
      end

      alias_method :var, :variance
	
	    # Variance of the sample.
      #
	    def variance2
		    # Variance of 0 or 1 elements is 0.0
		    return 0.0 if size < 2
		    summed_sqdevs / (size - 1)
	    end
	
	    # Variance of a population.
      #
	    def pvariance
		    # Variance of 0 or 1 elements is 0.0
		    return 0.0 if size < 2
		    summed_sqdevs / size
	    end

      def standard_deviation(&blk)
        Math::sqrt(variance(&blk))
      end

      alias_method :std, :standard_deviation
	
	    # Standard deviation of a sample.
      #
	    def stddev
		    Math::sqrt(variance2)
	    end

	    # Standard deviation of a population.
      #
	    def pstddev
		    Math::sqrt(pvariance)
	    end
	
	    # Calculates the standard error of this sample.
	    def stderr
		    return 0.0 if size < 2
		    stddev/Math::sqrt(size)
	    end
	
	    # Returns the confidence interval for this sample as [lower,upper].
	    # doc can be 90, 95, 99 or 999, defaulting to 95.
	    def ci(doc = 95)
		    limit = climit(doc)
		    [mean-limit,mean+limit]
	    end
	
	    # Returns E, the error associated with this sample for the given degree of
	    # confidence.
	    def climit(doc = 95)
		    TTable::t(doc,size)*stderr
	    end
	
	    # Calculates the relative mean difference of this sample.
	    # Makes use of the fact that the Gini Coefficient is half the RMD.
	    def relative_mean_difference
		    return 0.0 if Math::float_equal(mean,0.0)
		    gini_coefficient * 2
	    end

	    alias_method :rmd, :relative_mean_difference
	
	    # The average absolute difference of two independent values drawn from
	    # the sample. Equal to the RMD * the mean.
	    def mean_difference
		    relative_mean_difference * mean
	    end

	    alias_method :absolute_mean_difference, :mean_difference

	    alias_method :md, :mean_difference
	
	    # One of the Pearson skewness measures of this sample.
	    def pearson_skewness2
		    3*(mean-median)/stddev
	    end
	
	    # The skewness of this sample.
	    def skewness
		    fail "Buggy"
		    return 0.0 if size < 2
		    m = mean
		    s = inject(0) { |sum,xi| sum+(xi-m)**3 }
		    s.to_f/(size*variance**(3/2))
	    end
	
	    # The kurtosis of this sample.
	    def kurtosis
		    fail "Buggy"
		    return 0.0 if size < 2
		    m = mean
		    s = 0
		    each { |xi| s += (xi-m)**4 }
		    (s.to_f/((size-1)*variance**2))-3
	    end
	
	    # Calculates the Theil index (a statistic used to measure economic
	    # inequality). http://en.wikipedia.org/wiki/Theil_index
	    # TI = \sum_{i=1}^N \frac{x_i}{\sum_{j=1}^N x_j} ln \frac{x_i}{\bar{x}}
	    def theil_index
		    return -1 if size <= 0 or any? { |x| x < 0 }
		    return 0 if size < 2 or all? { |x| Math::float_equal(x,0) }
		    m = mean
		    s = sum.to_f
		    inject(0) do |theil,xi|
			    theil + ((xi > 0) ? (Math::log(xi.to_f/m) * xi.to_f/s) : 0.0)
		    end
	    end
	
	    # Closely related to the Theil index and easily expressible in terms of it.
	    # http://en.wikipedia.org/wiki/Atkinson_index
	    # AI = 1-e^{theil_index}
	    def atkinson_index
		    t = theil_index
		    (t < 0) ? -1 : 1-Math::E**(-t)
	    end
	
	    # Calculates the Gini Coefficient (a measure of inequality of a distribution
	    # based on the area between the Lorenz curve and the uniform curve).
	    # http://en.wikipedia.org/wiki/Gini_coefficient
	    # GC = \frac{1}{N} \left ( N+1-2\frac{\sum_{i=1}^N (N+1-i)y_i}{\sum_{i=1}^N y_i} \right )
	    def gini_coefficient2
		    return -1 if size <= 0 or any? { |x| x < 0 }
		    return 0 if size < 2 or all? { |x| Math::float_equal(x,0) }
		    s = 0
		    sort.each_with_index { |yi,i| s += (size - i)*yi }
		    (size+1-2*(s.to_f/sum.to_f)).to_f/size.to_f
	    end
	
	    # Slightly cleaner way of calculating the Gini Coefficient.  Any quicker?
	    # GC = \frac{\sum_{i=1}^N (2i-N-1)x_i}{N^2-\bar{x}}
	    def gini_coefficient
		    return -1 if size <= 0 or any? { |x| x < 0 }
		    return 0 if size < 2 or all? { |x| Math::float_equal(x,0) }
		    s = 0
		    sort.each_with_index { |li,i| s += (2*i+1-size)*li }
		    s.to_f/(size**2*mean).to_f
	    end
	
	    # The KL-divergence from this array to that of q.
	    # NB: You will possibly want to sort both P and Q before calling this
	    # depending on what you're actually trying to measure.
	    # http://en.wikipedia.org/wiki/Kullback-Leibler_divergence
	    def kullback_leibler_divergence(q)
		    fail "Buggy."
		    fail "Cannot compare differently sized arrays." unless size = q.size
		    kld = 0
		    each_with_index { |pi,i| kld += pi*Math::log(pi.to_f/q[i].to_f) }
		    kld
	    end
	
	    # Returns the Cumulative Density Function of this sample (normalised to a fraction of 1.0).
	    def cdf(normalised = 1.0)
		    s = sum.to_f
		    sort.inject([0.0]) { |c,d| c << c[-1] + normalised*d.to_f/s }
	    end
      
	    #
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

      #
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

=begin
	    def stats
		    if size != 0
			    return %Q/#{"%12.2f" % sum} #{"%12.2f" % average} #{"%12.2f" % stddev} #{"%12.2f" % min} #{"%12.2f" % max} #{"%12.2f" % median} #{"%12.2f" % size}/
		    else
			    return %Q/<error>/
		    end
	    end
	
	    def to_stats
		    { :sum => sum, :mean => mean, :stddev => stddev, :min => min, :max => max, :median => median, :size => size }
	    end

	    def self.stats_header
		    %Q/#{"%12s" % "Sum"} #{"%12s" % "Avg."} #{"%12s" % "Std.dev."} #{"%12s" % "Min."} #{"%12s" % "Max."} #{"%12s" % "Median"} #{"%12s" % "Size"}/
	    end
=end

      # Generates a hash mapping each unique element in the array
      # to the relative frequency, i.e. the probablity, of
      # it appearence.
      #
      # CREDIT: Brian Schröder
      #
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

    end


    # module String
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

end

module Enumerable #:nodoc:
  include Stick::Statistics::Enumerable
end

