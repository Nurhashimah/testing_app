# namespace :pick do
#   desc "Pick a random user as the winner"
#   task :winner => :environment do
#     puts "Winner: #{pick(User).name}"
#   end
# 
#   desc "Pick a random product as the prize"
#   task :prize => :environment do
#     puts "Prize: #{pick(Product).name}"
#   end
#   
#   desc "Pick a random prize and winner"
#   task :all => [:prize, :winner]
#   
#   def pick(model_class)
#     model_class.find(:first, :order => 'RAND()')
#   end
# end

namespace :update_field do

  desc "Upcase title of repositories"
  task :title_upcase => :environment do
    cnt=0
    Repository.where(title: 'test punye').each do |repo|
      repo.update(title: 'TEST PUNYE')
      cnt+=1
    end
    puts "#{cnt} titles upcased!"
  end
  
  desc "Downcase title of repositories"
  task :title_downcase => :environment do
    Repository.where(title: 'TEST PUNYE').update_all(title: "test punye")
    cnt=Repository.where(title: 'test punye').count
    puts "#{cnt} titles downcased!"
  end
  
  task :all => [:title_upcase, :title_downcase]
  
end

namespace :pick do
  
  desc "Display owner with repo owned"
  task :owner => :environment do
    repo=pick(Repository)
    puts "#{repo.title.titleize} (#{repo.id}) owned by #{repo.render_staff.titleize}"
  end
  
  def pick(model_class)
    model_class.order(updated_at: :desc).first
  end
  
end

namespace :trial do
  
  desc "checking available files"
  task :check, [:ctype] => [:environment] do |t, args|
    puts "Checking for #{args.ctype} tables"
  end
  
  desc "updating available files"
  task :update, [:utype] => [:environment] do |t, args|
    Rake::Task["trial:check"].invoke(args[:utype])
    puts "Updating #{args.utype} tables"
  end
  
  desc "checking wo environment" 
  task :check2, [:ctype] do |t, args|
    puts "Argument from update2 is #{args.ctype}"
  end
  
  desc "updating wo environment var" 
  task :update2 => :environment do
    Rake::Task["trial:check2"].invoke("useful, +ve pls")
  end
  
end