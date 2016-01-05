require 'yaml'

def get_env_value(string)
  string.split("=")[1].gsub("\"", "")
end


unless ARGV.length == 1
  puts "Incorrect number of arguments."
  exit
end

yml_file = ARGV[0]

unless yml_file.end_with? ".yml"
  puts "This script expects a YML file."
  exit
end

config = YAML.load_file(yml_file)

output = Hash.new

if config.has_key?("baseline")
  output["baseline"] = config["baseline"]
end

field_prefix = "smalltalk_"
allowed_fields = ["baseline", "baseline_group", "packages", "force_update",
          "run_script", "exclude_categories", "exclude_classes",
          "builderci", "tests"]

# TODO: Implement specification https://github.com/hpi-swa/smalltalkCI/issues/20
# allowed_fields.each { |field|
#   field_name = "#{field_prefix}#{field}"
#   if config.has_key?(field_name)
#     output[field] = config[field_name]
#   end
# }

if config.has_key?("env") and config["env"].has_key?("global")
  config["env"]["global"].each { |value|
    allowed_fields.each { |field|
      next if output.include? field
      if value.start_with?("#{field.upcase}=")
        output[field] = get_env_value(value)
      end
    }
  }
end

# Use first smalltalk value if $SMALLTALK is not set
if !ENV.has_key?("SMALLTALK") and config.has_key?("smalltalk")
  puts "config_smalltalk=(\"#{config["smalltalk"].first}\")"
end

# Print output
output.each { |key, value|
  puts "config_#{key}=(\"#{value}\")"
}
