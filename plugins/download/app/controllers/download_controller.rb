class DownloadController < ApplicationController
    before_filter :find_project
    before_filter :find_download_button

    def edit
        if request.post?
            if @download
                if params[:download][:file_id].to_i < 0 && params[:download][:url].blank?
                    @download.destroy
                    @download = nil
                else
                    @download.update_attributes(params[:download])
                end
            else
                @download = DownloadButton.new(params[:download].merge(:project => @project))
                @download.save
            end
        end
        if Rails::VERSION::MAJOR < 3
            render(:update) do |page|
                page.replace_html('tab-content-download', :partial => 'projects/settings/download')
            end
        end
    end

private

    def find_project
        @project = Project.find(params[:id])
        render_404 unless @project.versions.any?
    rescue ActiveRecord::RecordNotFound
        render_404
    end

    def find_download_button
        @download = DownloadButton.find_by_project_id(@project.id)
    end

end
