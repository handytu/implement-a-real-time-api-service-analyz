# qu45_implement_a_rea.rb
# A real-time API service analyzer

require 'net/http'
require 'json'
require 'benchmark'

class APIServiceAnalyzer
  def initialize(api_url, api_key)
    @api_url = api_url
    @api_key = api_key
    @request_count = 0
    @total_response_time = 0
  end

  def analyze
    loop do
      start_time = Time.now
      response = send_request
      end_time = Time.now
      process_response(response, end_time - start_time)
    end
  end

  private

  def send_request
    http = Net::HTTP.new(@api_url, 443)
    http.use_ssl = true

    request = Net::HTTP::Get.new @api_url
    request['Authorization'] = "Bearer #{@api_key}"

    response = http.request(request)
    JSON.parse(response.body)
  end

  def process_response(response, response_time)
    @request_count += 1
    @total_response_time += response_time

    puts "Request ##{@request_count} - Response code: #{response['status']}"
    puts "Response time: #{response_time.round(2)} seconds"
    puts "Average response time: #{@total_response_time / @request_count} seconds"
    puts "------------------------"
  end
end

# Example usage
analyzer = APIServiceAnalyzer.new('https://api.example.com', 'my_api_key')
analyzer.analyze