module Tools
  def self.enum_from_file (*parts)
    File.read(File.join(parts)).each_line(chomp: true)
  end

  def self.autofetch
    enum_from_file(DAY, TEST)
  end

  def self.autoraw
    File.read(File.join(DAY, TEST))
  end
end
