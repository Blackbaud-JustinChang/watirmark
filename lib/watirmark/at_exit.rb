module Watirmark
  def self.add_exit_task
    at_exit {
      begin
      puts "INSIDE EXIT CODE"
      puts "$! = #{$!.inspect}"
      puts "$!.nil? = #{$!.nil?}"
      puts "$!.is_a?(SystemExit) = #{$!.is_a?(SystemExit)}"
      puts "$!.success? = #{$!.success?}" if $!.is_a?(SystemExit)
      puts "$@ =  #{$@.inspect}"
      puts "$. =  #{$.}"
      puts "$? =  #{$?}"
      rescue
        puts "Exception thrown for exit"
      end

      if $!.nil? || $!.is_a?(SystemExit) && $!.success?
        code = 0
      else
        code = $!.is_a?(SystemExit) ? $!.status : 1
      end
      yield if block_given?
      puts "EXIT CODE IS #{code}"
      exit code
    }
  rescue Exception => e
    puts "THERE WAS AN EXIT ISSUE"
    puts e.inspect
    puts e.backtrace.join "\n"
  end
end
