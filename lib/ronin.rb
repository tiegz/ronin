module Ronin
  module Base #:nodoc:
    # Ronin monitors your Process size (for POSIX servers) of your Rails app and logs
    # it to a ronin.log file. It is in a Hash-style format so you can easily load it in 
    # a script or irb when you need to analyze the data. To turn the Ronin on, make sure
    # ENV['RONIN'] is set to 'on'.
    #
    # Example log:
    # { :growth => 0.02, :request_time => 0.76, :start_rss => 52748, :end_rss => 53936, :delta_rss => 1188, :uri => '/daimyo/3.xml' }
    # 
    def self.included(base)
      base.instance_eval do
        
        # The Logger object used by Ronin
        @@ronin_logger = nil
        cattr_accessor :ronin_logger
        
        # The time Ronin will take to check RSS. The smaller the more accurate.
        @@ronin_precision = 0.0001
        cattr_accessor :ronin_precision

        # Show the RSS periodically everytime Ronin checks?
        @@ronin_periodic_log_enabled = true
        cattr_accessor :ronin_periodic_log_enabled
                
        puts "=> Ronin logger loaded." if ENV['RAILS_ENV'] != 'test'

        around_filter do |controller, action|
          self.ronin_logger = Logger.new("#{RAILS_ROOT}/log/ronin.log")
          start_rss = Process::Status.rss
          end_rss = 0
          ronin_logger.info start_rss if ronin_periodic_log_enabled
          start_time = Time.new

          action.call
        
          end_rss = Process::Status.rss
          end_time = Time.new
          delta_rss = end_rss - start_rss
          growth = ((Rational(delta_rss, end_rss).to_f)*1000).round.to_f/1000
        
          ronin_logger.info "{ :growth => #{growth}, :request_time => #{end_time - start_time}, :start_rss => #{start_rss}, :end_rss => #{end_rss}, :delta_rss => #{delta_rss}, :uri => '#{controller.request.request_uri}' }"
        end
      end # end instance_eval
    end
  end
end
