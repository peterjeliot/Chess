module Chess
  def other_color(color)
    (color == :white) ? :black : :white
  end

  def pairwise_add(arr1, arr2)
    arr1.zip(arr2).map { |pair| pair.reduce(:+) }
  end
end
