require_dependency 'projects_helper'

module DownloadProjectsHelperPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :project_settings_tabs, :download
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def project_settings_tabs_with_download
            tabs = project_settings_tabs_without_download
            if User.current.allowed_to?(:manage_download_button, @project)
                tabs.push({ :name    => 'download',
                            :action  => :manage_download,
                            :partial => 'projects/settings/download',
                            :label   => :locale_download })
            end
            tabs
        end

    end

end
