puts "Hello from Yzz::SidePair file!"

# This class represents a pair of a negward and posward side (Yzz::Side instance)
# of a Yzz cell along a certain dimension.
# 
class Yzz::SidePair
  attr_reader :zz, :dimension, :negward, :posward
  alias p posward
  alias n negward

  def initialize( zz: ( raise ArgumentError, ":zz missing!" ),
                  dimension: ( raise ArgumentError, ":dimension missing!" ),
                  negward_neighbor: nil,
                  posward_neighbor: nil )
    @zz, @dimension = zz, dimension
    @negward = Yzz::Side.new( zz: zz,
                              dimension: dimension,
                              direction: :negward,
                              neighbor: negward_neighbor )
    @posward = Yzz::Side.new( zz: zz,
                              dimension: dimension,
                              direction: :posward,
                              neighbor: posward_neighbor )
  end

  # Links a neighbor posward.
  # 
  def >> new_neighbor
    new_neighbor.along( dimension ).tap { posward << new_neighbor }
  end

  # Crossovers a new neighbor posward.
  # 
  def * new_neighbor
    posward * new_neighbor
  end

  # Returns posward neighbor.
  # 
  def P; posward.neighbor end

  # Returns negward neighbor.
  # 
  def N; negward.neighbor end

  # Returns the string briefly describing the instance.
  # 
  def to_s
    "#<Yzz::SidePair: #{zz} along #{dimension}>"
  end

  # Instance inspect string.
  # 
  def inspect
    to_s
  end
end # class Yzz::SidePair