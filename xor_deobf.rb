#!/usr/bin/env ruby
require 'optparse'
require 'digest'

# begin
#   require 'filemagic'
# rescue LoadError
#   puts "[+] ruby-filemagic is not installed. Installing now..."
#   system("gem install ruby-filemagic --no-ri --no-rdoc")
#   exit 0
# end

# set the version of script
VERSION = "0.2"

# option parser
options = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage:"
  opt.separator "     #{File.basename($0)} -i <input_file> [-o <output_file>] -k <key>"
  opt.separator ""
  opt.separator "Examples:"
  opt.separator "     #{File.basename($0)} -i binary.exe -o binary_xor.exe -k key"
  opt.separator ""
  opt.separator "Options"

  opt.on("-i", "--input-file filername", "Input filename.") do |input_file|
    options[:input_file] = input_file
    options[:output_file] = "#{input_file}.xor"
  end
  opt.on("-o", "--output-file filername", "Output filename.") do |output_file|
    options[:output_file] = output_file
  end
  opt.on("-k", "--key key", "Key for XOR process.") do |key|
    options[:key] = key
  end
  opt.on("-v", "--version", "Display script version") do
    puts VERSION
    exit
  end
  opt.on("-h", "--help", "Display help messages") do
    puts opt_parser
    exit
  end
end

begin
  opt_parser.parse!
  mandatory = [:input_file, :key] #<------ array format
  missing = mandatory.select { |param| options[param].nil? }
  if not missing.empty?
    puts "Missing options: #{missing.join(', ')}"
    puts opt_parser
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts opt_parser
  exit
end

# read file byte by byte then create byte array with XOR result
begin
  File.open(options[:input_file], 'r') do |input_file|

    byte_arr = input_file.each_byte.each_with_index.map do |byte, i|
      key = options[:key]
      byte ^ key[i%key.size].ord # xor encoding
    end

    # Another way to do the above
    # index = 0
    # byte_arr = []
    # while (byte = input_file.read(1)) do
    #   key = options[:key]
    #   byte_arr << (byte.ord ^ key[index%key.size].ord) # xor encoding
    #   index += 1
    # end

    File.open(options[:output_file], 'w') { |output_file| output_file.write(byte_arr.pack('c*')) }
  end
rescue Exception => e
  puts e.message
end

# display the result
# fm = FileMagic.new
puts "[+] Input File"
puts "Filename: #{options[:input_file]}"
# puts "Type: #{fm.file(options[:input_file])}"
puts "Size: #{File.size(options[:input_file])}"
puts "MD5: #{Digest::MD5.file(options[:input_file])}"
puts "SHA1: #{Digest::SHA1.file(options[:input_file])}"
puts "SHA256: #{Digest::SHA256.file(options[:input_file])}"
puts
puts "[+] Output File"
puts "Filename: #{options[:output_file]}"
# puts "Type: #{fm.file(options[:output_file])}"
puts "Size: #{File.size(options[:output_file])}"
puts "MD5: #{Digest::MD5.file(options[:output_file])}"
puts "SHA1: #{Digest::SHA1.file(options[:output_file])}"
puts "SHA256: #{Digest::SHA256.file(options[:output_file])}"

__END__

Usage:
     xor_deobf.rb -i <input_file> [-o <output_file>] -k <key>

Examples:
     xor_deobf.rb -i binary.exe -o binary_xor.exe -k key

Options
    -i, --input-file filername       Input filename.
    -o, --output-file filername      Output filename.
    -k, --key key                    Key for XOR process.
    -v, --version                    Display script version
    -h, --help                       Display help messages