# Counter as a tally that grows fast — an Advent of Code 2021 Day 6 style
# lanternfish population model.
#
# Each fish has an internal timer 0..8. Every day, timers decrement; a fish at 0
# resets to 6 and spawns a new fish at 8. Instead of tracking millions of fish
# individually, we keep a Counter of "how many fish have each timer value".
#
# The population passes Int32's range within ~90 days, which is exactly why
# Counter stores its counts as Int64.
#
# Run with: crystal run examples/lanternfish.cr
require "../src/collections"

initial_timers = [3, 4, 3, 1, 2]
counter = Collections::Counter(Int32).new(initial_timers)

days = 256
days.times do
  next_day = Collections::Counter(Int32).new
  (0..8).each do |timer|
    count = counter[timer]
    next if count.zero?

    if timer.zero?
      next_day.increment(6, count) # parents reset to 6
      next_day.increment(8, count) # newborns start at 8
    else
      next_day.increment(timer - 1, count)
    end
  end
  counter = next_day
end

puts "After #{days} days there are #{counter.total} lanternfish."
puts "Most common timer values: #{counter.most_common(3)}"
