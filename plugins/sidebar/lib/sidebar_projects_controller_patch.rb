require_dependency 'projects_controller'

module SidebarProjectsControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :settings, :sidebar
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def settings_with_sidebar
            settings_without_sidebar
            @sidebar ||= SidebarContent.find_by_project_id(@project.id)
        end

    end
end
