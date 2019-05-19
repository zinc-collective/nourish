task populate_production_appropriate_data: :environment do
  Community.find_or_create_by(slug: 'nourish').update(name: 'Nourish')
end
