require File.join(File.dirname(__FILE__), '../app/helpers/download_helper')

class DownloadHook  < Redmine::Hook::ViewListener
    include Redmine::I18n
    include DownloadHelper

    def view_layouts_base_html_head(context = {})
        styles = stylesheet_link_tag('download', :plugin => 'download')
        if defined? ChiliProject
            styles << stylesheet_link_tag('chiliproject', :plugin => 'download')
        end
        if File.exists?(File.join(File.dirname(__FILE__), "../assets/stylesheets/#{Setting.ui_theme}.css"))
            styles << stylesheet_link_tag(Setting.ui_theme, :plugin => 'download')
        end
        if File.exists?(File.join(File.dirname(__FILE__), "../assets/stylesheets/custom.css"))
            styles << stylesheet_link_tag('custom', :plugin => 'download')
        end
        styles
    end

    render_on :view_layouts_base_content, :partial => 'download/warning'
    render_on :view_layouts_base_sidebar, :partial => 'download/sidebar'

    #render_on :view_projects_roadmap_version_bottom, :partial => 'download/version'

end
