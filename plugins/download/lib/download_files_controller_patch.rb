require_dependency 'files_controller'

module DownloadFilesControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :create, :download
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def create_with_download
            create_without_download
            container = params[:version_id].blank? ? @project : @project.versions.find_by_id(params[:version_id])
            if container.is_a?(Version)
                if container.closed?
                    download = DownloadButton.find_by_project_id(@project.id)
                    if download && download.file_id.to_i > 0
                        attachment = Attachment.find(download.file_id.to_i)
                        if (attachment.container <=> container) == 0
                            flash[:warning] = l(:warning_consider_changing_file)
                        end
                    end
                else
                    flash[:warning] = l(:warning_wont_be_used_for_download_button) + ': ' + l(:warning_version_not_closed)
                end
            else
                flash[:warning] = l(:warning_wont_be_used_for_download_button) + ': ' + l(:warning_not_in_version)
            end
        end

    end

end
