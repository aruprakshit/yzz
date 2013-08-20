# encoding: utf-8

require_relative 'yzz/version'
require_relative 'yzz/side'
require_relative 'yzz/side_pair'

# Yzz implements Ted Nelson's zz (hyperorthogonal, Zig-Zag...) structure. It
# provides a mixin that imbues objects with zz properties.
# 
# A zz structure consists of zz objects, which exist in multiple dimensions. Zz
# objects can be connected by directed edges -- connections. Connected objects
# are called neighbors. Each connection belongs to some dimension. A zz object
# is considered as having two <em>sides</em> in each dimension: posward side and
# negward side. A connection always points away from the posward side, and
# towards the neighbor's negward side. In each dimension, zz object can have at
# most one posward and one negward neighbor. A zz object can be connected to
# itself, forming a loop.
# 
# To these basic properties, Ted Nelson adds a bunch of other terminology.
# A rank is a series of zz objects connected along one dimension. A rank viewed
# horizontally is referred to as row. A rank viewed vertically is referred to
# as column.
# 
# Mixin defining Zz structure (aka. hyperorthogonal structure). As represented
# by YTed::Zz, a Zz structure is a collection of objects, whose connectivity is
# defined in a multidimensional space in such way, that each object, along each
# dimension, has at most one posward neighbor, and one negward neighbor. The
# relation is bijective: If B is a posward neighbor of A along some dimension,
# then A must be a negward neighbor of B along that dimension, and vice-versa.
# 
module Yzz
  # Adds initialization of the @zz_dimensions hash to #initialize.
  # 
  def initialize *args
    @zz_dimensions = Hash.new { |ꜧ, missing_dimension|
      ꜧ[ missing_dimension ] = Yzz::SidePair
        .new( zz: self, dimension: missing_dimension )
    } # initialize the @zz_dimensions hash
    super # and proceed as usual
  end

  # Returns a SidePair instance along the requested dimension.
  # 
  def along dimension
    @zz_dimensions[ dimension ]
  end

  # Returns all sides actually connected to a zz object.
  # 
  def connections
    @zz_dimensions.map { |_, pair| [ pair.negward, pair.posward ] }
      .reduce( [], :+ ).select { |side| side.neighbor.is_a_zz? }
  end
  alias connectivity connections

  # Returns all neighbors of a zz object.
  # 
  def neighbors
    connections.map &:neighbor
  end

  # Returns all sides facing another zz object supplied as argument. (Note that
  # this can be <em>more than 1</em> side: object A can be connected to B along
  # more than 1 dimension.
  # 
  def towards other
    connectivity
      .select { |side| side.neighbor == other }
      .map { |side| [ side.dimension, side.direction] }
      .map { |dim, dir| dir == :posward ? "#{dim} ->" : "-> #{dim}" }
  end

  # Short string describing the object.
  # 
  def to_s
    "#<Yzz, #{connections.size} conn.>"
  end

  # Inspect string of the object.
  # 
  def inspect
    to_s
  end
end

class Object
  def is_a_zz?
    is_a? ::Yzz
    # class_complies? ::YTed::Zz
  end
end
