module ProcessExtensions
  # Measures the RSS size of the current Process
  def rss
    `ps -o rss -p #{Process.pid}`.split.last.to_i
  end
end
