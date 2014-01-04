namespace :issue do
  task :greet do
    puts "Hello World!"
  end

  task :ask => :greet do
    puts "How are you?"
  end

  desc "Pick the first issue in the database"
  task :first => :environment do
    issue = Issue.first
    puts "Selected Issue is #{issue.name}"
  end

  task :last => :environment do
    issue = Issue.last
    puts "Selected Issue is #{issue.name}"
    # puts "Prize: #{pick(Product).name}"
  end

  task :all => [:first, :last]
  def pick(model_class)
    model_class.find(:first, :order => 'RAND()')
  end
end
