#!/usr/bin/env ruby -w
require "lib/encoded_polyline/core"
require 'benchmark'

if ARGV.empty?
	seed = (rand * 1000000).to_i.abs
else
	seed = ARGV[0].to_i
end
srand seed

def rsign
  (rand(2) == 1) ? -1 : 1
end

random_walk = [[rand * 180 * rsign, rand * 180 * rsign]]
99.times do
  lat = random_walk.last[0] + rand * 0.01 * rsign
  long =random_walk.last[1] + rand * 0.01 * rsign
  random_walk << [lat, long]
end

random_walk_text = EncodedPolyline.encode_points(random_walk)

points_length = random_walk.inspect.gsub(' ','').to_s.length
compressed_length = random_walk_text.length

puts random_walk.join(" ")
puts random_walk_text
puts seed
puts "\n"

Benchmark.bm(20) do |x|
  x.report("encoding") do
    10000.times do |i|
      EncodedPolyline.encode_points(random_walk)
    end
  end

  x.report("decoding") do
    10000.times do |i|
      EncodedPolyline.decode_points(random_walk_text)
    end
  end
end
