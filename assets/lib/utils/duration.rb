# from https://gist.github.com/tim-evans/d0ba1e8f05a55b76c49c

class Duration
  def initialize(number_in_ms)
    @value = number_in_ms
  end

  def self.parse(string)
    string ||= ''
    value = string.scan(/([\d.-]+)(ms|s|m|h|d)/).reduce(0) do |total, parsed_duration|
      number, unit = parsed_duration
      total + case unit
              when 'ms'
                number.to_i
              when 's'
                number.to_i * 1_000
              when 'm'
                number.to_i * 60_000
              when 'h'
                number.to_i * 3_600_000
              when 'd'
                number.to_i * 86_400_000
              end
    end
    self.new(value)
  end

  def milliseconds
    @value
  end

  def seconds
    @value / 1_000
  end

  def minutes
    @value / 60_000
  end

  def hours
    @value / 3_600_000
  end
end
