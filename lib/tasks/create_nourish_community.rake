namespace :release do
  task create_nourish_community: :environment do
    Community.find_or_create_by(slug: 'nourish').update(name: 'Nourish')
  end
end
