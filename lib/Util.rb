# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Util
  def self.media_path(file)
    File.join(File.dirname(__FILE__), 'media', file)
  end
end
