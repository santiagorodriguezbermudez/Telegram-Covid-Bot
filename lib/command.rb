

class Command
  attr_accessor :name :description :path
  def initialize(name, description, path)
    @name: name
    @description: description
    @path: path
  end
end