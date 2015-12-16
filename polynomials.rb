class Polynomial
    def self.new(inputs)
        raise ArgumentError, "Need atleast 2 coefficients" if inputs.length < 2
        exponent = inputs.length-1
        #str = ""
        str1 = ""
        inputs.each do |input|
            if (input!=0) && (!input.is_a? String)
                #str += (input.abs!=1 ? input>0 ? (exponent < inputs.length-1 ? "+#{input}":"#{input}") :"#{input}" : input>0 ? "":"-") + (exponent!=0 ? "x" : "") + (exponent>1 ? "^#{exponent}" : (0 == exponent) && (1==input.abs)? "1" : "")
                str1 += exponent < inputs.length-1 && input > 0 ? "+": "" #Requires "+" or not
                str1 += input.abs!=1 ? "#{input}": input < 0 ? "-" : ""   #coefficient 
                str1 += exponent!=0 ? "x" : ""                            #x - print if not 0   
                str1 += exponent>1 ? "^#{exponent}" : (0 == exponent) && (1==input.abs)? "1" : "" #print exponent value
            elsif input.is_a?(String)
                raise ArgumentError, "Accepts only integers"                
            end
            exponent-=1 
        end
        #puts str
        str1
    end
end

puts Polynomial.new([-3,-4,1,0,6]) # => -3x^4-4x^3+x^2+6
puts Polynomial.new([1,0,2]) # => x^2+2