class CLI

    @@bookmarks = []

    def run
        puts "Hello, welcome to Monarch Explorer!".green
        sleep(1)
        puts "Loading all divinely-appointed monarchs...".blue
        Scraper.new.scrape_1
        puts "Done!".green
        sleep(1)
        puts "\nHere, you will be able to read about all British monarchs since 802 AD.".green
        puts "Press any key to continue to the main menu."
        STDIN.getch
        main_menu
    end

    def main_menu
        puts "\nWelcome to the Main Menu. Please make a selection. Type \"menu\" at any stage to return here."
        puts "1. Display all monarchs."
        puts "2. Search by house/dynasty."
        puts "3. View bookmarks."
        puts "4. Delete all bookmarks."
        puts "5. Exit."
        user_input = 0
        until (1..5).to_a.include?(user_input.to_i)
            user_input = user_input_method
            if (1..5).to_a.include?(user_input.to_i)
                [method(:monarch_menu), method(:dynasty_menu), method(:bookmark_view), method(:bookmark_delete), method(:goodbye)][user_input.to_i-1].call
            elsif user_input.to_s.downcase == "menu"
                main_menu
            else
                puts "Invalid input."
            end
        end
    end

    def monarch_menu
        puts "--------------------"
        puts "ALL MONARCHS".green
        Monarch.print_monarchs_for_selection
        puts "--------------------"
        puts "Please enter a number to read more about a monarch, or type menu to return to the main menu."
        user_input = 0
        until (1..Monarch.all.count).to_a.include?(user_input.to_i)
            user_input = user_input_method
            if (1..Monarch.all.count).to_a.include?(user_input.to_i)
                select_to_index = user_input.to_i-1
                result = Monarch.all[select_to_index]
                result.print_monarch_bio
            elsif user_input.to_s.downcase == "menu"
                main_menu
            else
                puts "Invalid input."
            end
        end
        puts "\nSave this monarch into bookmarks? (Y/N)"
        user_input = user_input_method
        bookmark_add_or_check(user_input, result)
        sleep(0.5)
        puts "Keep looking around this menu? (Y/N) - N will take you back to main menu."
        user_input = user_input_method
        if user_input.to_s.downcase == "y"
            monarch_menu
        else
            main_menu
        end
    end

    def dynasty_menu
        puts "--------------------"
        puts "HOUSES AND DYNASTIES".green
        Dynasty.print_dynasties_for_selection
        puts "--------------------"
        puts "Which dynasty or house would you like to focus on?"
        user_input = 0
        until (1..Dynasty.all.count).to_a.include?(user_input.to_i)
            user_input = user_input_method
            if user_input.to_s.downcase == "menu"
                main_menu
            elsif (1..Dynasty.all.count).to_a.include?(user_input.to_i)
                puts "--------------------"
                Dynasty.list_monarchs_by_dynasty(user_input.to_i-1)
                puts "--------------------"
                puts "Please enter a number to read more about a monarch, type \"back\" to return to dynasties, or type \"menu\" to return to the main menu."
                user_input = 0
                until (1..Dynasty.tempMonarchs.count).to_a.include?(user_input.to_i)
                    user_input = user_input_method
                    if user_input.to_s.downcase == "menu"
                        main_menu
                    elsif user_input.to_s.downcase == "back"
                        dynasty_menu
                    elsif (1..Dynasty.tempMonarchs.count).to_a.include?(user_input.to_i)
                        result = Dynasty.tempMonarchs[user_input.to_i-1]
                        result.print_monarch_bio
                    else
                        puts "Invalid input."
                    end
                end
                puts "\nSave this monarch into bookmarks? (Y/N)"
                user_input = user_input_method
                bookmark_add_or_check(user_input, result)
                sleep(0.5)
                puts "Keep looking around this menu? (Y/N) - N will take you back to the main menu."
                user_input = user_input_method
                if user_input.to_s.downcase == "y"
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

    def bookmark_add_or_check(user_input, result)
        if user_input.to_s.downcase == "y"
            if @@bookmarks.include?(result)
                puts "This monarch is already in your bookmarks!".yellow
            else
                @@bookmarks << result
                puts "Added to bookmarks!".green
            end
        end
    end

    def bookmark_delete
        if @@bookmarks.count == 0 then puts "\nYou have no bookmarks to delete." ; sleep(1) ; main_menu end
        puts "\nAre you sure you want to clear #{@@bookmarks.count} record"+(@@bookmarks.count != 1 ? "s" : "")+"? (Y/N)"
        user_input = user_input_method
        if user_input.to_s.downcase == "y"
            @@bookmarks = []
            puts "Monarchs deposed!".red
            sleep(1)
        end
        main_menu
    end

    def goodbye
        puts ""
        disp_top = "          ".on_white+"   ".on_red+"          ".on_white
        disp_middle = "  God save the Queen!  ".white.on_red
        puts disp_top, disp_top , disp_middle, disp_top, disp_top, ""
        if @@bookmarks.count > 0
            saved_bookmarks = @@bookmarks.map {|bookmark| bookmark.name.green}.join(", ")
            puts "You saved bookmarks for: #{saved_bookmarks}. Don't forget to look into them!" 
        end
        sleep(1)
        exit
    end

    def user_input_method
        print ">> "
        gets.chomp
    end

end