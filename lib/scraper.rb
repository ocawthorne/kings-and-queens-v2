class Scraper

    def get_page
        Nokogiri::HTML(open("https://www.britannica.com/topic/Kings-and-Queens-of-Britain-1856932"))
    end

    def scrape_1
        rows = self.get_page.xpath("//table/tbody/tr")
        rows.each do |row|
            td = row.css("td") # The "td" label in CSS falls beneath each "tr" label, where "tr" describes a row in the table and "td" describes each column of the row in order.
            next if td[1].text == "Commonwealth (1653–59)"
            args = td.map { |i| i.text.tr(" ","") } # Produces a string-only array like ["", NAME, DYNASTY, REIGN] and uses this in initialization.
            next if args[1].split(" ")[-1] == "(restored)" # Avoids duplication.
            args[2] = "None (Interregnum)" if args[2] == "" # Special categorisation for Oliver and Richard Cromwell.
            args[2] = "Plantagenet" if args[2].split(": ")[0] == "Plantagenet" # Alternatively, args[2] = args[2].split(": ")[0] works, but this method is safer.
            args[1] = args[1].chop if args[1][-1].to_i != 0 # Some names have footnote numbers. String values are equal to 0 when converted to_i.
            url = row.css(".md-crosslink").map { |el| el["href"] } # In one instance, this creates an array of two URLs (William III & Mary II)
            Monarch.new(args[1], Dynasty.find_create_dynasty(args[2]), args[3], url) # Uses last 3 elements of array to initialize Monarch. Initializes or finds dynasties.
        end
    end

    def self.scrape_2(monarch) # Passes in an instance of a Monarch which already has a URL association from the first scrape.
        parsed_monarch = Nokogiri::HTML(open(monarch.url[0]))
        monarch.title = parsed_monarch.css(".topic-identifier").text 
        monarch.bio = parsed_monarch.css(".topic-content p")[1..2].text
    end

end