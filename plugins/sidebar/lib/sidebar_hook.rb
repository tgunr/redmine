class SidebarHook  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        if context[:request].format == 'text/html'
            if SidebarPage.sidebar_enabled?("#{context[:request].params['controller']}/#{context[:request].params['action']}", context[:project])
                context[:controller].send(:render_to_string, :partial => 'sidebar/empty')
            end
        end

        stylesheet_link_tag('sidebar', :plugin => 'sidebar')
    end

    render_on :view_projects_show_sidebar_bottom, :partial => 'sidebar/project'
    render_on :view_issues_sidebar_issues_bottom, :partial => 'sidebar/issues'
    render_on :view_layouts_base_sidebar,         :partial => 'sidebar/base'

end
