_ = require 'lodash'
Hbs = require 'handlebars'
fs = require 'fs'
mkdirp = require 'mkdirp'

Templates = {}


Character_Compiled_Templates = {}

# fs.readFile 'a.hbs', 'utf8', (err, data) ->
# 	console.log "error" if err

# 	template = Hbs.compile data
# 	console.log template

# 	console.log template (id: 'Matt', attributes: ["hello", "world"])


ReadTemplates = =>

	dir = './templates'

	files = fs.readdirSync dir

	for file in files
		dot_index = file.indexOf '.'
		file_name_without_ext = file.slice 0, dot_index

		console.log "#{file} is located at #{dir+file}, the '.' is located at #{dot_index}, file name without ext: #{file_name_without_ext}"
		Templates[file_name_without_ext] = fs.readFileSync "#{dir}/#{file}", 'utf8' 

	console.log "Templates are read"

CreateCharacterString = (character) =>
	Attributes = AssignAttributes character.attributes
	DefaultValues = AssignDefaultValues character.attributes
	Curves = AssignCurves character.curves

	console.log "Creating character\nAttributes: #{JSON.stringify Attributes}\nDefaultValues: #{JSON.stringify DefaultValues}\nCurves: #{JSON.stringify Curves}\n"
	template = Hbs.compile Templates.character

	return template (class_name: "#{FormatIDToClassName(character.id)}", id: character.id, attributes: Attributes, values: DefaultValues, curves: Curves)


FormatIDToClassName = (value) =>
	console.log "Uppercasing #{value}\nValue At index 0 is #{value[0]}\n"

	first_char = value[0]

	if typeof(first_char) is 'string'
		first_char_uppercased = first_char.toUpperCase()
	else
		first_char_uppercased = first_char

	first_char_uppercased = value[0].toUpperCase()
	new_value = "c#{first_char_uppercased}#{value.substring 1, value.length}"
	
	return new_value

AssignAttributes = (attributes) =>

	console.log "Creating Attributes\nAttributes: #{JSON.stringify attributes}\n"

	attributes_string = []
	for attribute in attributes
		console.log "Attribute #{attribute.key} being created\nTemplate: #{JSON.stringify Templates[attribute.type]}\n"

		template_string = if Templates[attribute.type]? then Templates[attribute.type] else Templates['Default']

		# template = Hbs.compile Templates[attribute.type]
		template = Hbs.compile template_string

		compiled_string = template attribute
		console.log "Compiled String: #{compiled_string}\n"
		attributes_string.push compiled_string

	return attributes_string

	# for each attribute
		# get the template based on the data type
		# push the HBS compiled template to the Attributes array

AssignDefaultValues = (attributes) =>
	default_value_strings = []

	for attribute in attributes
		if attribute.default_value?

			if typeof(attribute.default_value) is 'string'
				template = Hbs.compile '{{key}} = "{{default_value}}"'
			else
				template = Hbs.compile '{{key}} = {{default_value}}'

			default_value_strings.push template attribute

	return default_value_strings
	# for each attribute 
		# if default value isn't null
			# push compiled method to the default values array

AssignCurves = (curves) =>
	curves_string = []

	for curve, index in curves
		curve.index = index
		template = Hbs.compile 'Curves[{{index}}] = new Level { Damage = {{damage}}, Cost = {{cost}} }'
		curves_string.push template curve

	return curves_string

module.exports = (model, path) =>
	ReadTemplates()

	console.log "Model\n#{JSON.stringify model}\n"

	for character in model.characters
		console.log "Character ID:#{character.id}\nValues: #{JSON.stringify character}\n"
		Character_Compiled_Templates[FormatIDToClassName character.id] = CreateCharacterString character

	mkdirp.sync "#{path}/code"

	for key, val of Character_Compiled_Templates
		fs.writeFileSync "#{key}.cs", val, 'utf8' 


# Read the Templates into the array

# For each character
	# Assign Attributes
	# Assign Default Values
	# Assign Curves
	# Compile to character ScriptableObject file string

# Compile character strings to each file prefixed with c'characterName' (hungarian notation)
