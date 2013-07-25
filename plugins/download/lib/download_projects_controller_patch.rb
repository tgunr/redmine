require_dependency 'projects_controller'

module DownloadProjectsControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :add_file, :download
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def add_file_with_download
            add_file_without_download
            container = params[:version_id].blank? ? @project : @project.versions.find_by_id(params[:version_id])
            if container.is_a?(Version) && container.closed?
                download = DownloadButton.find_by_project_id(@project.id)
                if download && download.file_id.to_i > 0
                    attachment = Attachment.find(download.file_id.to_i)
                    if (attachment.container <=> container) == 0
                        flash[:warning] = l(:warning_consider_changing_file)
                    end
                end
            end
        end

    end

end
