# frozen_string_literal: true

class ResponseMock
  attr_accessor :headers

  def initialize(headers:)
    self.headers = headers
  end

  def set_header(key, v)
    headers[key] = v
  end
end