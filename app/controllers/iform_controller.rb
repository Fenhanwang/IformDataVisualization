class IformController < ApplicationController
	require 'uri'
	require 'net/http'
	require 'net/https'
	require 'jwt'

	def index
		key = "c2f6f8b5793ef3be05fb29a77b2135e6e9645d2d"
		pages = "290743542"
		pagestwo = "290743563"
		pagesthree = "290743566"

		labelArray = []
		dataArray = []
		caloiesArray = []
		distanceArray = []
		headerme = get_data_from_form(key, pages)
		@headerme = headerme["RECORDS"]
		@headerme.each do |d|
			result = get_specific_data_from_one_form(key, pages, d["ID"].to_s)
			labelArray.push(result[0]["record"]["my_element"])
			dataArray.push(result[0]["record"]["steps"].to_i)
			caloiesArray.push(result[0]["record"]["calories"])
			distanceArray.push(result[0]["record"]["distances"])
			puts dataArray
			
		end
		gon.labelOne = labelArray.reverse
		gon.dataOne = dataArray
		gon.caloiesOne = caloiesArray
		gon.distanceOne = distanceArray

		labelArray = []
		dataArray = []
		caloiesArray = []
		distanceArray = []
		headerme = get_data_from_form(key, pagestwo)
		@headerme = headerme["RECORDS"]
		@headerme.each do |d|
			result = get_specific_data_from_one_form(key, pagestwo, d["ID"].to_s)
			labelArray.push(result[0]["record"]["my_element"])
			dataArray.push(result[0]["record"]["steps"].to_i)
			caloiesArray.push(result[0]["record"]["calories"])
			distanceArray.push(result[0]["record"]["distances"])
			puts dataArray
		end
		gon.labelTwo = labelArray.reverse
		gon.dataTwo = dataArray
		gon.caloiesTwo = caloiesArray
		gon.distanceTwo = distanceArray



		labelArray = []
		dataArray = []
		caloiesArray = []
		distanceArray = []
		headerme = get_data_from_form(key, pagesthree)
		@headerme = headerme["RECORDS"]
		@headerme.each do |d|
			result = get_specific_data_from_one_form(key, pagesthree, d["ID"].to_s)
			labelArray.push(result[0]["record"]["my_element"])
			dataArray.push(result[0]["record"]["steps"].to_i)
			caloiesArray.push(result[0]["record"]["calories"])
			distanceArray.push(result[0]["record"]["distances"])
			puts dataArray
		end
		gon.labelThree = labelArray.reverse
		gon.dataThree = dataArray
		gon.caloiesThree = caloiesArray
		gon.distanceThree = distanceArray

		# respond_to do |format|
		# 	format.html
  #   		format.js { render :layout=>false }
  # 		end

	end


	private
	def get_access_token
		payload = {
					"iss"=>"e2d08ae128e092423c2ae7760ffd745230e00812", 
					"aud"=>"https://loadapp.iformbuilder.com/exzact/api/oauth/token",
					"exp"=>(Time.now+200).to_i,
					"iat"=>Time.now.to_i
				}
		@EncodeString = JWT.encode(payload, "982d1b54237ad5e3ea06bf45c51ccaab62df8c0c")

		@toSend = {
				    "date" => "2012-07-02",
				    "aaaa" => "bbbbb",
				    "cccc" => "dddd"
				   }.to_json		
		uri = URI.parse("https://loadapp.iformbuilder.com/exzact/api/oauth/token")
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
		req['foo'] = 'bar'
		req.body = "[ #{@toSend} ]"
		res = https.request(req)
		puts "Response #{res.code} #{res.message}: #{res.body}"
	end

	def get_data_from_form(key, pages)
		keyToSend = "Bearer "+key
		urlstring = "https://loadapp.iformbuilder.com/exzact/api/profiles/357477/pages/"+pages+"/records"
		uri = URI.parse(urlstring)

		uri = URI.parse(urlstring)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri)
		request.add_field("Host", "server.iformbuilder.com")
		request.add_field("Authorization", keyToSend)
		request.add_field("X-IFORM-API-VERSION", "5.1")

		response = http.request(request)
		JSON.parse(response.body)
	end

	def get_specific_data_from_one_form(key,pages,id)
		keyToSend = "Bearer "+key
		urlstring = "https://loadapp.iformbuilder.com/exzact/api/profiles/357477/pages/"+pages+"/records/"+id+"/feed?FORMAT=JSON"
		uri = URI.parse(urlstring)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri)
		request.add_field("Host", "server.iformbuilder.com")
		request.add_field("Authorization", keyToSend)
		request.add_field("X-IFORM-API-VERSION", "5.1")

		response = http.request(request)
		JSON.parse(response.body)
	end
end
