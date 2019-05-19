namespace :release do
  task create_nourish_community: :environment do
    Community.create(name: "Nourish", slug: "nourish")
  end
end
