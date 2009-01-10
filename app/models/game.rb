class Game < ActiveRecord::Base
  has_many :friend_codes

  def clean_code(code)
    return nil if code.nil? or code == ""

    slices = []
    code.gsub(/[ \-]*/, '').split('').each_slice(4){|slice| slices << slice.join("") }
    slices.join("-")
  end

  def code_is_valid_when_clean?(code)
    code_is_valid?(clean_code(code))
  end
end

