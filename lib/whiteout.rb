require "whiteout/version"
require "optparse"

# TODO handle directories more appropriately
# TODO add man page

module Whiteout
  def self.execute(*args)
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: whiteout file1 [...]"

      opts.on('-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end

    begin
      opts.parse!

      if !$stdin.tty? || args[0] == '-'
        puts self.clean($stdin.read)
      else
        if args.empty?
          puts opts
          exit
        end

        args.each do |file|
          abort "Can't find #{file}" unless File.exists?(file)

          contents = File.read(file)

          # TODO consider writing to a temporary file and moving into place
          File.open(file, 'w') do |f|
            f.write(self.clean(contents))
          end
        end
      end
    rescue OptionParser::InvalidOption => e
      warn e
      puts opts
    end
  end

  def self.clean(str)
    str.gsub(/[ \t]+$/, '')
  end
end
