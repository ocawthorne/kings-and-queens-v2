require 'open-uri'
require 'nokogiri'

require_relative './monarch.rb'
require_relative './dynasty.rb'

class Scraper

    def get_page
        Nokogiri::HTML(open("https://www.britannica.com/topic/Kings-and-Queens-of-Britain-1856932"))
    end

    def scrape_1
        rows = self.get_page.xpath("//table/tbody/tr")
        rows.each do |row|
            td = row.css("td") # The "td" label in CSS falls beneath each "tr" label, where "tr" describes a row in the table and "td" describes each column of the row in order.
            next if td[1].text == "Commonwealth (1653–59)" # Special exception. There is a header in the table which is treated like another data point and is skipped over.
            args = td.map { |i| i.text } # Produces a string-only array like ["", NAME, DYNASTY, REIGN] and uses this in initialization.
            next if args[1].split(" ")[-1] == "(restored)" # Skips over data if the monarch is reinstated, in other words does not duplicate.
            args[2] = "Commonwealth" if args[2] == "" # Special categorisation for Oliver and Richard Cromwell
            args[2] = "Plantagenet" if args[2].split(": ")[0] == "Plantagenet" # Plantagenet has two further divisions - Lancaster and York - which are unified into one.
            monarch = Monarch.new(args[1], Dynasty.find_create_dynasty(args[2]), args[3]) # Uses last 3 elements of array to initialize Monarch. Initializes or finds dynasties.
            monarch.url = row.css(".md-crosslink").map { |el| el["href"] } # In one instance, this creates an array of two URLs (William III & Mary II)
        end
    end

    def self.scrape_2(monarch) # Passes in an instance of a Monarch which already has a URL association from the first scrape.
        parsed_monarch = Nokogiri::HTML(open(monarch.url[0]))
        monarch.title = parsed_monarch.css(".topic-identifier").text 
        monarch.bio = parsed_monarch.css(".topic-content p")[1..2].text # First paragraph is shown at first, but more can be seen through CLI if requested.
        # num-paragraphs = parsed_monarch.css("p").to_a.count
    end

end