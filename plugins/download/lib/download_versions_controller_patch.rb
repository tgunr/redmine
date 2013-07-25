require_dependency 'versions_controller'

module DownloadVersionsControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, CommonMethods)
        if base.method_defined?(:create) && base.method_defined?(:update)
            base.send(:include, Redmine11XMethods)
        else
            base.send(:include, Redmine10XMethods)
        end
        base.class_eval do
            unloadable
            if method_defined?(:create) && method_defined?(:update)
                alias_method_chain :create, :download
                alias_method_chain :update, :download
            else
                alias_method_chain :new, :download
                alias_method_chain :edit, :download
            end
        end
    end

    module ClassMethods
    end

    module Redmine10XMethods

        def new_with_download
            new_without_download
            if request.post? && flash[:notice]
                if update_download_button(@version)
                    flash[:warning] = l(:warning_file_id_reset_to_automatic)
                end
            end
        end

        def edit_with_download
            edit_without_download
            if request.post? && flash[:notice]
                if update_download_button(@version)
                    flash[:warning] = l(:warning_file_id_reset_to_automatic)
                end
            end
        end

    end

    module Redmine11XMethods

        def create_with_download
            create_without_download
            if flash[:notice]
                if update_download_button(@version)
                    flash[:warning] = l(:warning_file_id_reset_to_automatic)
                end
            end
        end

        def update_with_download
            update_without_download
            if flash[:notice]
                if update_download_button(@version)
                    flash[:warning] = l(:warning_file_id_reset_to_automatic)
                end
            end
        end

    end

    module CommonMethods

        def update_download_button(version)
            if version.closed?
                download = DownloadButton.find_by_project_id(version.project.id)
                if download && download.file_id.to_i > 0
                    attachment = Attachment.find(download.file_id.to_i)
                    if (attachment.container <=> version) < 0
                        Rails.logger.debug "Switching to automatic file detection for download button: #{download.id} (project id: #{download.project_id})"
                        download.update_attributes(:file_id => 0, :url => nil)
                        return true
                    end
                end
            end
            false
        end

    end

end
