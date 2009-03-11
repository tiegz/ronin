if ENV['RONIN'] and ENV['RONIN'] == 'on'
  require 'rational'

  ActionController::Base.send(:include, Ronin::Base)
  Process::Status.send(:extend, Ronin::ProcessExtensions)

  ActionController::Base.ronin_periodic_log_enabled = false
  ActionController::Base.ronin_precision = 0.0001
end