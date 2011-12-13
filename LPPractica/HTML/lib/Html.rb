#!usr/bin/env ruby
# Autora: Haridian Rodriguez Perez
# Practica: HTML DSL
# Fecha: 31-12-11

class Html
    
    def initialize(&b)
        @p = [[]]
        instance_eval &b
    end
    
    def build_attr(h)
        return '' if h.nil? or h.empty?
        h.inject('') { |a, b| a = %{#{a} #{b[0]} = "#{b[1]}"} }
    end

    def method_missing(tag, *args)
        #lanzar una excepción si se está intentando llamar a un sitio raro
        test = ""
        textattr = ""
        if block_given?
            @p.push []
            yield
            text = @p.pop.join(' ')
        else
            text = args.shift
        end
        textattr = build_attr(args.shift)
        text = "<#{tag}#{textattr}> #{text} </#{tag}>\n"
        @p[-1].push text
        text
    end
    
    def to_s
        @p.flatten.join("\n")
    end
    
end

if __FILE__ == $0
    q= Html.new {  
        html {
            head(:dir => "chazam", :lang => "spanish") { title "My wonderful home page" }
            body do
                h1 "Welcome to my home page!", :class => "chuchu", :lang => "spanish"
                b "My hobbies:"
                ul do
                    li "Juggling"
                    li "Knitting"
                    li "Metaprogramming"
                end #ul
            end # body
        }
    }
    puts "#{q}"
end