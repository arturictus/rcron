require 'erlectricity'

receive do |f|
  f.when([:execute, String]) do |command|
    f.send!([:result, [:ok, Rcron.call(command)]])
    f.receive_loop
  end
end
