class Monarch
    attr_reader :name, :dynasty, :reign, :url # Read-only to prevent adjustments.
    attr_accessor :title, :bio # Must be attribute accessors for the second scrape to set these vars.

    @@all = []

    def initialize(name, dynasty, reign, url)
        @name = name
        @dynasty = dynasty
        @reign = reign
        @url = url
        # @title = title
        # @bio = bio
        @@all << self
    end

    def self.sort_by_name
        # @@all.map {|monarch| monarch.name}.sort
        @@all.sort_by(&:name)
    end

    def self.all
        @@all
    end

    def self.print_monarchs_for_selection
        self.all.each_with_index { |monarch, i| puts "#{i+1}. #{monarch.name} (reigned #{monarch.reign} AD)" }
    end

    def print_monarch_bio
        print "\e[2J\e[f"
        Scraper.scrape_2(self)
        puts "[-+-]"
        puts "#{self.name} (reigned #{self.reign} AD)".green
        puts "#{self.title.upcase}. Dynasty: #{dynasty.name.upcase}"
        puts ""
        puts self.bio
        puts "\n(Read more at #{url.join(" and ")})"
    end

end