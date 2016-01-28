module ModelHelper

  def verifyEOL
    if self.description.scan("\\n").count == 0
      self.description = self.description + "\n"
    end
  end

 end