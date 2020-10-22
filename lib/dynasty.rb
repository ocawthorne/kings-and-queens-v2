class Dynasty
    attr_accessor :name

    @@all = []
    @@tempMonarchs = [] # tempMonarchs only used as temporary storage for if a user searches by dynasty in CLI. Resets every time such list is requested.

    def initialize(name)
        @name = name
        @@all << self
    end

    def self.all
        @@all
    end

    def self.tempMonarchs
        @@tempMonarchs
    end

    def self.list_monarchs_by_dynasty(index)
        @@tempMonarchs = Monarch.all.select {|monarch| monarch.dynasty == self.all[index]}
        puts self.all[index].name.upcase.green
        @@tempMonarchs.each_with_index {|monarch, i| puts "#{i+1}. #{monarch.name}"}
    end

    def self.find_create_dynasty(name)
        found_dynasty = self.all.find { |dynasty| dynasty.name == name }
        found_dynasty ? found_dynasty : self.new(name)
    end

    def self.print_dynasties_for_selection
        self.all.each_with_index {|dyn, i| puts "#{i+1}. #{dyn.name}"}
    end

end