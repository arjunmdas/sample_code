class Polynomial
    def self.new(inputs)
        raise ArgumentError, "Need atleast 2 coefficients" if inputs.length < 2
        exponent = inputs.length - 1
        str1 = ""
        inputs.each do |input|
            if (input != 0) && (!input.is_a? String)
                str1 += exponent < inputs.length-1 && input > 0 ? "+": ""  # Requires "+" if not first element and  if +ve.
                str1 += input.abs!= 1 ? "#{input}": input < 0 ? "-" : ""   # coefficient of the polynomial if not 1, if "-1",add - 
                str1 += exponent != 0 ? "x" : ""    
                if exponent > 1                                       
                    str1 += "^#{exponent}"                                 # x - print "x" if exponent if not 0
                else
                    str1 += (0 == exponent) && (1 == input.abs) ? "1" : "" # print exponent value if not 1 - also handle conrner case for 1*x^0
                end
            elsif input.is_a?(String)
                raise ArgumentError, "Accepts only Numbers"                
            end
            exponent -= 1 
        end
        str1
    end
end

#Usage:
#puts Polynomial.new([3,-4,1,0,6]) # => -3x^4-4x^3+x^2+6
#puts Polynomial.new([1,1,1]) # => x^2+2