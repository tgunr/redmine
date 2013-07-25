if Rails::VERSION::MAJOR < 3

    ActionController::Routing::Routes.draw do |map|
        map.connect('/sidebar/:id/edit', :controller => 'sidebar', :action => 'edit')
        map.connect('/sidebar/:id/preview', :controller => 'sidebar', :action => 'preview')
        map.connect('/sidebar/:id/pages', :controller => 'sidebar', :action => 'pages')
        map.connect('/sidebar/pages', :controller => 'global_sidebar', :action => 'pages')
    end

else

    match '/sidebar/:id/edit', :to => 'sidebar#edit'
    match '/sidebar/:id/preview', :to => 'sidebar#preview'
    match '/sidebar/:id/pages', :to => 'sidebar#pages'
    match '/sidebar/pages', :to => 'global_sidebar#pages'

end
