require 'net/http'
require 'json'
require "openssl"

class HomeController < ApplicationController
  CURRENCIES = [
    {code: 'USD-BRL'},
    {code: 'EUR-BRL'},
    {code: 'BTC-BRL'}
  ]
  def index 
    @chart_data = []

    CURRENCIES.each do |currency|
      url = URI("https://economia.awesomeapi.com.br/json/daily/#{currency[:code]}/15")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # 🚨 ignora SSL (só para testes!)
      response = http.get(url.request_uri)
      data = JSON.parse(response.body) rescue nil

      hash = {}
      data.each do |entry|
        date = Time.at(entry['timestamp'].to_i).strftime('%d/%m/%Y')
        rate = entry['high']
        hash[date] = rate

      end
      @chart_data << {name: currency[:code], data: hash}
    end
  end
end
