namespace :installation do
  desc "TODO"


  task pingall: :environment do
    # ping all nagano prod servers
    Installation.ping_all_installation(1)
  end

end
