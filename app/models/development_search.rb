class DevelopmentSearch < FortyFacets::FacetSearch
  model 'Development'

  text  :name, name: 'Name'
  range :total_cost, name: 'Total Cost'
end
