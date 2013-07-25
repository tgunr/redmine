require 'redmine'

require_dependency 'sidebar_hook'

Rails.logger.info 'Starting Sidebar Content Plugin for Redmine'

Rails.configuration.to_prepare do
    unless String.method_defined?(:html_safe)
        String.send(:include, SidebarStringHTMLSafePatch)
    end
    unless ActionView::Base.included_modules.include?(SidebarContentHelper)
        ActionView::Base.send(:include, SidebarContentHelper)
    end
    unless ProjectsHelper.included_modules.include?(SidebarProjectsHelperPatch)
        ProjectsHelper.send(:include, SidebarProjectsHelperPatch)
    end
    unless ProjectsController.included_modules.include?(SidebarProjectsControllerPatch)
        ProjectsController.send(:include, SidebarProjectsControllerPatch)
    end
    unless Setting.included_modules.include?(SidebarSettingPatch)
        Setting.send(:include, SidebarSettingPatch)
    end
end

Redmine::Plugin.register :sidebar do
    name 'Sidebar content'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com/'
    description 'Specify sidebar content per project.'
    url 'http://projects.andriylesyuk.com/projects/sidebar-content'
    version '0.1.0'

    permission :manage_sidebar, { :sidebar => [ :edit, :preview, :pages ] }, :require => :member

    menu :admin_menu, :sidebar,
                    { :controller => 'global_sidebar', :action => 'pages' },
                      :caption => :label_sidebar,
                      :after => :enumerations
end
