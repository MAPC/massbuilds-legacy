class DevelopmentSearch < FortyFacets::FacetSearch
  model 'Development'

  range :height     
  range :stories    
  range :year_compl 
  range :prjarea    
  range :singfamhu  
  range :twnhsmmult 
  range :lgmultifam 
  range :tothu      
  range :gqpop      
  range :rptdemp    
  range :emploss    
  range :estemp     
  range :commsf     
  range :hotelrms   
  range :onsitepark 
  range :total_cost 

  text :name
  text :status
  text :desc
  text :project_url
  text :mapc_notes
  text :tagline
  text :address
  text :city
  text :state
  text :zip_code
end
