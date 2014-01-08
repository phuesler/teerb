# TeeRb - Several ways to capture and tee Ruby's standard input and output

  * Pipe calls to $stdout and $stderr to a file
  * Pipe calls to $stdout and $stderr to an instance of Ruby's logger class
  * Pipe calls to an instance of Ruby's logger class to $stdout

## Usage


    # Tee $stdout and $stderr to several files
    log_file = File.open("debug.log", "a")
    tee = TeeRb::Tee.new(log_file)
    tee.enable

    puts 'puts hello'
    $stdout.puts 'stdout hello'
    $stderr.puts 'stderr hello'

    tee.disable

    puts 'puts hello'
    $stdout.puts 'stdout hello'
    $stderr.puts 'stderr hello'

    # same as above but with block syntax
    log_file = File.open("debug.log", "a")
    TeeRb::Tee.new(log_file) do
      puts 'puts hello'
      $stdout.puts 'stdout hello'
      $stderr.puts 'stderr hello'
    end


    # Capture $stdout and $stderr and send it through `logger`
    require 'logger'
    log_file = File.open("debug.log", "a")
    logger = Logger.new(log_file)
    tee = TeeRb::LoggerTee.new(logger)
    tee.enable

    logger.warn "hello"
    $stderr.puts "stderr hello"
    puts "stdout hello"


    # Pipe calls to an instance of Ruby's logger class to $stdout
    require 'logger'
    log_file = File.open("debug.log", "a")
    logger = Logger.new(TeeRb::IODelegate.new(log_file, STDOUT))
    logger.warn "warn"
    $stderr.puts "stderr hello"
    puts "stdout hello"

## Problems

This only works for `$stdout` and `$stderr` and not for `STDOUT` and `STDERR`, since they constants
that should not be reassigned.
