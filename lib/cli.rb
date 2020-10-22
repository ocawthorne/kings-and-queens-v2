require 'io/console'
require 'colorize'

require_relative "./scraper.rb"

class CLI

    @@bookmarks = []

    def run
        puts "Hello, welcome to Monarch Explorer!".green
        sleep(1)
        puts "Loading all divinely-appointed monarchs...".blue
        Scraper.new.scrape_1
        puts "Done!".green
        sleep(1)
        main_menu
    end

    def main_menu
        puts "\nWelcome to the Main Menu. Please make a selection. Type \"menu\" at any stage to return here."
        puts "Here, you will be able to read about all British monarchs since 802 AD."
        puts "1. Display all monarchs."
        puts "2. Search by house/dynasty."
        puts "3. View bookmarks."
        puts "4. Delete all bookmarks."
        puts "5. Exit."
        user_input = 0
        until (1..5).to_a.include?(user_input)
            user_input = gets.chomp
            # if (1..5).to_a.include?(user_input.to_i)
            #     [monarch_menu, dynasty_menu, bookmark_view, bookmark_delete, goodbye][user_input.to_i-1]
            #     binding.pry
            if user_input.to_i == 1
                monarch_menu
            elsif user_input.to_i == 2
                dynasty_menu
            elsif user_input.to_i == 3
                bookmark_view
            elsif user_input.to_i == 4
                bookmark_delete
            elsif user_input.to_i == 5
                goodbye
            elsif user_input.downcase == "menu"
                main_menu
            else
                puts "Invalid input."
            end
        end
    end

    def monarch_menu
        puts "--------------------"
        Monarch.print_monarchs_for_selection
        puts "--------------------"
        puts "Please enter a number to read more about a monarch, or type menu to return."
        user_input = 0
        until (1..Monarch.all.count).to_a.include?(user_input.to_i)
            user_input = gets.chomp
            if (1..Monarch.all.count).to_a.include?(user_input.to_i)
                select_to_index = user_input.to_i - 1
                result = Monarch.all[select_to_index]
                result.print_monarch_bio
            elsif user_input.downcase == "menu"
                main_menu
            else
                puts "Invalid input."
            end
        end
        puts "\nSave this monarch into bookmarks? (Y/N)"
        user_input = gets.chomp
        @@bookmarks << result ; puts "Added to bookmarks!".green if user_input.downcase == "y"
        sleep(0.5)
        puts "Keep looking around this menu? (Y/N) - N will take you back to main menu."
        user_input = gets.chomp
        if user_input.downcase == "y"
            monarch_menu
        else
            main_menu
        end
    end

    def dynasty_menu
        puts "--------------------"
        Dynasty.print_dynasties_for_selection
        puts "--------------------"
        puts "Which dynasty or house would you like to focus on?"
        user_input = 0
        until (1..Dynasty.all.count).to_a.include?(user_input.to_i)
            user_input = gets.chomp
            if user_input == "menu"
                main_menu
            elsif (1..Dynasty.all.count).to_a.include?(user_input.to_i)
                puts "--------------------"
                Dynasty.list_monarchs_by_dynasty(user_input.to_i - 1)
                puts "--------------------"
                puts "Please enter a number to read more about a monarch, type \"back\" to return to dynasties, or type \"menu\" to return."
                user_input = 0
                until (1..Dynasty.tempMonarchs.count).to_a.include?(user_input.to_i)
                    user_input = gets.chomp
                    if user_input.downcase == "menu"
                        main_menu
                    elsif user_input.downcase == "back"
                        dynasty_menu
                    elsif (1..Dynasty.tempMonarchs.count).to_a.include?(user_input.to_i)
                        result = Dynasty.tempMonarchs[user_input.to_i - 1]
                        result.print_monarch_bio
                    else
                        puts "Invalid input."
                    end
                end
                puts "\nSave this monarch into bookmarks? (Y/N)"
                user_input = gets.chomp
                @@bookmarks << result ; puts "Added to bookmarks!".green if user_input.downcase == "y"
                sleep(0.5)
                puts "Keep looking around this menu? (Y/N) - N will take you back to main menu."
                user_input = gets.chomp
                if user_input.downcase == "y"
                    dynasty_menu
                else
                    main_menu
                end
            else
                puts "Invalid input."
            end
        end
    end

    def bookmark_view
        @@bookmarks.each do |bookmark|
            puts "[-+-]"
            puts "#{bookmark.name[-1].to_i != 0 ? bookmark.name.chop : bookmark.name} (reigned #{bookmark.reign} AD)".green
            puts "#{bookmark.title.upcase}. Dynasty: #{bookmark.dynasty.name.upcase}"
            puts "\n#{bookmark.bio}"
            puts "--------------------"
            sleep(0.5)
        end
        if @@bookmarks.count == 0
            puts "\nYou do not have any monarchs bookmarked!"
            sleep(1)
            main_menu 
        end
        puts "Press any key to return to the main menu.\n"
        STDIN.getch
        main_menu
    end

    def bookmark_delete
        if @@bookmarks.count == 0 then puts "\nYou have no bookmarks to delete." ; sleep(1) ; main_menu end
        puts "\nAre you sure you want to clear #{@@bookmarks.count} record"+(@@bookmarks.count != 1 ? "s" : "")+"? (Y/N)"
        user_input = gets.chomp
        if user_input.downcase == "y"
            @@bookmarks = []
            puts "Monarchs deposed!".red
            sleep(1)
        end
        main_menu
    end

    def goodbye
        puts ""
        disp_top = "          ".on_white+"   ".on_red+"          ".on_white
        disp_middle = "                       ".on_red
        puts disp_top, disp_top , disp_middle, disp_top, disp_top
        puts "\n  God save the Queen!".red
        sleep(1)
        exit
    end

end

CLI.new.run