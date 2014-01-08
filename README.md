# TeeRb - Several ways to capture and tee Ruby's standard input and output

  * Pipe calls to $stdout and $stderr to a file
  * Pipe calls to $stdout and $stderr to an instance of Ruby's logger class
  * Pipe calls to an instance of Ruby's logger class to $stdout

## Motivation and considerations

I wrote this gem for three reasons:

  * Have Ruby's logger library output to STDOUT/STDERR in addition to a file
  * Have the `puts` statements of external libraries go through my custom logger class
  * Tee STDOUT/STDERR to a file

In general, I consider redirecting Ruby's STDOUT and STDERR from within the program to be a last resort, because
another person using your program might not expect this special behavior.

Most of the time it is possible to use standard Unix tools to accomplish the same task without having to change your
program. Here are a few examples:

    $: ruby myscript.rb > my_file.log
    $: ruby myscript.rb | tee myfile.log

In particular, I consider it good practise to use the operating system's logging facilities (see `man logger`).
This allows to change the logging behaviour without changing the actual program:

    $: ruby myscript.rb | logger

If you want to have logs on the console as well:

    $: ruby myscript.rb | tee /dev/null | logger

## Problems

This only works for `$stdout` and `$stderr` and not for `STDOUT` and `STDERR`, since they are constants
that should not be reassigned/redefined.

## Installation

    $: gem install teerb

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
