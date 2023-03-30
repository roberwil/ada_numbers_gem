class String
  def title_case
    self.split(' ').map { |w| w.capitalize }.join ' '
  end
end
