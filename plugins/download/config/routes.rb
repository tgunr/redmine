if Rails::VERSION::MAJOR < 3

    ActionController::Routing::Routes.draw do |map|
        map.connect('projects/:id/download', :controller => 'download', :action => 'edit', :conditions => { :method => :post })
    end

else

    post 'projects/:id/download', :to => 'download#edit'

end
