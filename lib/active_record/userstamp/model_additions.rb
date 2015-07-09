module ActiveRecord::Userstamp::ModelAdditions; end
ActiveRecord::Base.send(:include, ActiveRecord::Userstamp::Stampable)
ActiveRecord::Base.send(:include, ActiveRecord::Userstamp::Stamper)
