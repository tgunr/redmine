require_dependency 'attachments_controller'

module DownloadAttachmentsControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :destroy, :download
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def destroy_with_download
            if @attachment.container.is_a?(Version) && @attachment.container.closed?
                download = DownloadButton.find_by_project_id(@attachment.container.project.id)
                if download && download.file_id.to_i > 0
                    download.update_attributes(:file_id => 0)
                    flash[:warning] = l(:warning_file_id_reset_to_automatic)
                end
            end
            destroy_without_download
        end

    end

end
