# Loads the ronin log in a giant hash!
def results(reload=false)
  if @results.nil? || reload
    open("log/ronin.log").read.split("\n").map { |line| eval(line) rescue nil }.reject { |h| h.nil? } rescue {}
  else 
    @results
  end
end
