require "../src/counter/counter"
require "./spec_helper"

describe Collections::Counter do
  describe "#initialize" do
    it "creates an empty counter" do
      counter = Collections::Counter(Int32).new
      counter.empty?.should be_true
      counter.size.should eq(0)
      counter.total.should eq(0)
    end

    it "tallies occurrences from an enumerable" do
      counter = Collections::Counter(Char).new("mississippi".chars)
      counter['i'].should eq(4)
      counter['s'].should eq(4)
      counter['p'].should eq(2)
      counter['m'].should eq(1)
    end
  end

  describe "#[]" do
    it "returns 0 for absent keys without creating an entry" do
      counter = Collections::Counter(String).new
      counter["missing"].should eq(0)
      counter.size.should eq(0)
    end
  end

  describe "#increment and #<<" do
    it "increments by one via <<" do
      counter = Collections::Counter(Symbol).new
      counter << :a << :a << :b
      counter[:a].should eq(2)
      counter[:b].should eq(1)
    end

    it "increments by an arbitrary amount and returns the new count" do
      counter = Collections::Counter(Symbol).new
      counter.increment(:a, 5).should eq(5)
      counter.increment(:a, -2).should eq(3)
    end
  end

  describe "#[]=" do
    it "sets a count explicitly" do
      counter = Collections::Counter(String).new
      counter["x"] = 7
      counter["x"].should eq(7)
    end
  end

  describe "counts beyond Int32" do
    it "accumulates values larger than Int32::MAX without overflowing" do
      counter = Collections::Counter(Symbol).new
      big = 5_000_000_000_i64 # > Int32::MAX (~2.1e9)
      counter.increment(:fish, big)
      counter.increment(:fish, big)

      counter[:fish].should eq(10_000_000_000_i64)
      counter.total.should eq(10_000_000_000_i64)
    end
  end

  describe "#total" do
    it "sums all counts" do
      counter = Collections::Counter(Int32).new([1, 1, 2, 3, 3, 3])
      counter.total.should eq(6)
    end
  end

  describe "#most_common" do
    it "returns the n most common entries" do
      counter = Collections::Counter(Char).new("aaabbc".chars)
      counter.most_common(1).should eq([{'a', 3}])
      counter.most_common(2).should eq([{'a', 3}, {'b', 2}])
    end

    it "returns all entries sorted by count when given no argument" do
      counter = Collections::Counter(Char).new("aaabbc".chars)
      counter.most_common.map(&.last).should eq([3, 2, 1])
    end
  end

  describe "#elements" do
    it "yields each key repeated by its count, skipping non-positive" do
      counter = Collections::Counter(String).new
      counter["a"] = 3
      counter["b"] = 0
      counter["c"] = -1
      counter.elements.sort.should eq(["a", "a", "a"])
    end
  end

  describe "#delete" do
    it "removes a key and returns its previous count" do
      counter = Collections::Counter(Int32).new([1, 1])
      counter.delete(1).should eq(2)
      counter[1].should eq(0)
      counter.delete(9).should be_nil
    end
  end

  describe "#+" do
    it "sums counts and keeps only positive totals" do
      a = Collections::Counter(Char).new("aab".chars)
      b = Collections::Counter(Char).new("bcc".chars)
      sum = a + b
      sum['a'].should eq(2)
      sum['b'].should eq(2)
      sum['c'].should eq(2)
    end
  end

  describe "#-" do
    it "subtracts counts and drops non-positive results" do
      a = Collections::Counter(Char).new("aaab".chars)
      b = Collections::Counter(Char).new("abb".chars)
      diff = a - b
      diff['a'].should eq(2)
      diff['b'].should eq(0)
      diff.keys.should_not contain('b')
    end
  end

  describe "#==" do
    it "compares stored counts" do
      a = Collections::Counter(Int32).new([1, 2, 2])
      b = Collections::Counter(Int32).new([2, 1, 2])
      (a == b).should be_true
    end
  end
end
