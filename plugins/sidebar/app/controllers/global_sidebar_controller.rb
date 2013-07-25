class GlobalSidebarController < ApplicationController
    layout 'admin'

    before_filter :require_admin

    def pages
        @settings = Setting.plugin_sidebar
        if request.post? && params[:sidebar_settings]
            @settings = params[:sidebar_settings]
            Setting.plugin_sidebar = params[:sidebar_settings]
            flash[:notice] = l(:notice_successful_update)
            redirect_to(:controller => 'global_sidebar', :action => 'pages')
        end
    end

end
