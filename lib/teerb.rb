require "teerb/version"
require 'logger'

module TeeRb
  class IODelegate
    def initialize(*targets)
       @targets = targets
    end

    def write(*args)
      @targets.each {|t| t.write(*args)}
    end

    def puts(*args)
      write(*args)
      write("\n")
    end

    def put(*args)
      write(*args)
    end

    def close
      @targets.each(&:close)
    end
  end

  class LoggerIODelegate
    def initialize(logger, log_level)
       @logger    = logger
       @log_level = log_level
    end

    def write(*args)
      @logger.send(@log_level, *args) unless args == ["\n"]
    end

    def puts(*args)
      write(*args)
    end

    def put(*args)
      write(*args)
    end

    def close
      @logger.close
    end
  end


  class Tee
    def initialize(*logfiles, &block)
      @stdout_tee      = IODelegate.new(*([STDOUT] + logfiles))
      @stderr_tee      = IODelegate.new(*([STDERR] + logfiles))
      @original_stdout = $stdout
      @original_stderr = $stderr

      if block_given?
        enable
        yield
        disable
      end
    end

    def enable
      $stdout = @stdout_tee
      $stderr = @stderr_tee
    end

    def disable
      $stdout = @original_stdout
      $stderr = @original_stderr
    end
  end

  #sends stdout to logger.info
  #sends stderror to logger.error
  #sends everything to STDOUT
  class LoggerTee
    def initialize(logger)
      @stdout_tee      =  IODelegate.new(LoggerIODelegate.new(logger, :info) , STDOUT)
      @stderr_tee      =  IODelegate.new(LoggerIODelegate.new(logger, :error), STDERR)

      @original_stdout = $stdout
      @original_stderr = $stderr

      if block_given?
        enable
        yield
        disable
      end
    end

    def enable
      $stdout = @stdout_tee
      $stderr = @stderr_tee
    end

    def disable
      $stdout = @original_stdout
      $stderr = @original_stderr
    end
  end
end
