module ModelFactoryMixin
  
  def model_factory
    ModelFactory.new
  end
  
  class ModelFactory
    @@next_integer = 0
    
    def region(options = {})
      create Region, options, :name => "Waitakere#{next_integer}", :city => 'Waitakere', :country => 'New Zealand', :center_lat => 1.0, :center_lon => 1.0, :default_zoom => 5
    end
    
    def area(options = {})
      create Area, options, :name => "Swanson#{next_integer}", :center_lat => 1.0, :center_lon => 1.0, :default_zoom => 5, :region => (options[:region] || region)
    end
    
    def pin(options = {})
      create Pin, options, :name => "Craig's Vegie Garden",
        :grow_food => true,
        :region => region,
        :lat => 10.0,
        :long => 20.0,
        :street_address => '17 Kay Rd',
        :suburb => 'Swanson',
        :city => 'Waitakere',
        :country => 'New Zealand'      
    end
    
    def user(options = {})
      create User, options, :email_address => "user#{next_integer}@craigambrose.com"
    end
        
    protected
    
      def next_index(model)
        (model.maximum(:index) || 0) + 1
      end
      
      def create(klass, options, attributes = {})
        klass.create!(attributes.merge(options))
      end
      
      def next_integer
        @@next_integer += 1
      end
    
  end
  
end