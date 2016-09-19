require 'net/http' 
require 'net/smtp'
require 'uri'
require 'pp'
require 'yaml'
require 'date'

config = YAML.load_file('config.yaml')
domains = config["domains"]
from_email = config["from_email"]
to_email = config["to_email"]

smtp_server = config["smtp"]["server"]
smtp_port = config["smtp"]["port"]
smtp_account = config["smtp"]["account"]
smtp_password = config["smtp"]["password"]
smtp_domain = config["smtp"]["domain"]

def basic_message from, to, subject, message
now = Time.now.strftime("%d/%m/%Y %H:%M")
pp now
<<END_OF_MESSAGE
From: #{from}
To: #{to}
Subject: #{subject}
Date: #{now}
--
#{now}
--
#{message}

END_OF_MESSAGE
end

domains.each do |site|
	domain = site["domain"]
	site["subdomains"].each do |subdomain|
		uri = URI("http://#{subdomain}#{site["domain"]}")
		begin
			response = Net::HTTP.get_response(uri)
			if response.code != "200"
				pp "Error: #{uri.host}\nCode: #{response.code}\n Sending mail..."
				smtp = Net::SMTP.new(smtp_server, smtp_port)
				smtp.enable_starttls
				smtp.start(smtp_domain, smtp_account, smtp_password, :login) do |s|
					begin
				  		s.send_message(basic_message(from_email, to_email, "::WARN:: #{uri.host} ", "Code: #{response.code}\n\n Response:\n#{response.body}"), from_email, to_email)
				  	rescue Exception => e
						pp "::::: Mail Error :::::" 
						pp e
					end
				end
				pp "Mail sent."
			end
		rescue Exception => e
			pp "::::: Error :::::" 
			pp e
		end
	end
end