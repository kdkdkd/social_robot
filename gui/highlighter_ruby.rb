require 'coderay'
require 'Qt'

class HighlighterRuby < Qt::SyntaxHighlighter
	def format(color, style='')
		clr = Qt::Color.new
		clr.setNamedColor(color)
		
	  
		format = Qt::TextCharFormat.new
		format.Foreground = ( Qt::Brush.new(clr))
		
		format.FontWeight = Qt::Font::Bold if 'bold' == style
		format.FontItalic = true if 'italic' == style
		format
	end
    def initialize(document)
		super(document)
		# Syntax styles that can be shared by all languages
		@styles = {
			'annotation' => format('#007'),
			'attribute-name' => format('#b48'),
			'attribute-value' => format('#700'),
			'binary' => format('#509'),
			'char' => format('#D20'),
			'class' => format('#B06','bold'),
			'class-variable' => format('#369'),
			'color' => format('#0A0'),
			'comment' => format('#777'),
			'complex' => format('#A08'),
			'constant' => format('#036','bold'),
			'decorator' => format('#B0B'),
			'definition' => format('#099','bold'),
			'directive' => format('#088','bold'),
			'doc' => format('#970'),
			'doc-string' => format('#D42','bold'),
			'doctype' => format('#34b'),
			'entity' => format('#800','bold'),
			'escape' => format('#666'),
			'exception' => format('#C00','bold'),
			'float' => format('#60E'),
			'function' => format('#06B','bold'),
			'global-variable' => format('#d70'),
			'hex' => format('#02b'),
			'imaginary' => format('#f00'),
			'include' => format('#B44','bold'),
			'inline-delimiter' => format('#666','bold'),
			'instance-variable' => format('#33B'),
			'integer' => format('#00D'),
			'key' => format('#60f'),
			'key' => format('#404'),
			'key' => format('#606'),
			'keyword' => format('#080','bold'),
			'label' => format('#970','bold'),
			'local-variable' => format('#963'),
			'namespace' => format('#707','bold'),
			'octal' => format('#40E'),
			'predefined' => format('#369','bold'),
			'predefined-constant' => format('#069'),
			'predefined-type' => format('#0a5','bold'),
			'preprocessor' => format('#579'),
			'pseudo-class' => format('#00C','bold'),
			'reserved' => format('#080','bold'),
			'symbol' => format('#A60'),
			'tag' => format('#070'),
			'type' => format('#339','bold'),
			'value' => format('#088'),
			'variable' => format('#037'),
			'operator' => format('#300'),
			'content' => format('#D20')
		}
   
	end
	

    def highlightBlock(text)
	    text.force_encoding("UTF-8")
		tokens = CodeRay.scan(text, :ruby).tokens()
		index = 0
		(tokens.length/2).times do |x| 
			key = tokens[x*2]
			value = tokens[x*2+1].to_s
			if key.class.name == "String"
				setFormat(index, key.length, @styles[value]) if @styles.has_key?(value)
				index += key.length
			end
		end
    end

	
end
