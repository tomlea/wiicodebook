class WiiConsole < Game
  def code_is_valid?(code)
    code =~ /^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/
  end
end

