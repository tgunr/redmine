require 'redmine'

require_dependency 'download_hook'

Rails.logger.info 'Starting Download Plugin for Redmine'

Rails.configuration.to_prepare do
    unless ActionView::Base.included_modules.include?(DownloadHelper)
        ActionView::Base.send(:include, DownloadHelper)
    end
    unless VersionsController.included_modules.include?(DownloadVersionsControllerPatch)
        VersionsController.send(:include, DownloadVersionsControllerPatch)
    end
    begin
        unless FilesController.included_modules.include?(DownloadFilesControllerPatch)
            FilesController.send(:include, DownloadFilesControllerPatch)
        end
    rescue NameError
        unless ProjectsController.included_modules.include?(DownloadProjectsControllerPatch)
            ProjectsController.send(:include, DownloadProjectsControllerPatch)
        end
    end
    unless AttachmentsController.included_modules.include?(DownloadAttachmentsControllerPatch)
        AttachmentsController.send(:include, DownloadAttachmentsControllerPatch)
    end
    unless ProjectsHelper.included_modules.include?(DownloadProjectsHelperPatch)
        ProjectsHelper.send(:include, DownloadProjectsHelperPatch)
    end

    if defined? ChiliProject::Liquid::Tags
        require_dependency 'chiliproject/liquid/tags/download'

        ChiliProject::Liquid::Tags.register_tag('download', Download, :html => true)
    end
end

Redmine::Plugin.register :download do
    name 'Download button'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com/'
    description 'Adds Download button to projects.'
    url 'http://projects.andriylesyuk.com/projects/download-button'
    version '0.1.0'

    permission :manage_download_button, { :projects => :settings, :download => :edit }, :require => :member
end

unless defined? ChiliProject::Liquid::Tags

    Redmine::WikiFormatting::Macros.register do
        desc "Inserts Download button in Wiki page."
        macro :download do |page, args|
            button = ''

            options = {}
            args.each do |arg|
                if arg =~ %r{^([^=]+)\=(.*)$}
                    options[$1.downcase.to_sym] = $2
                end
            end

            if options[:project]
                project = Project.find_by_identifier(options[:project])
            elsif page.respond_to?(:project)
                project = page.project
            end

            if project && project.versions.any?
                download = DownloadButton.from_options(project, options)
                if download && !download.disabled?
                    latest_version = latest_version(project)
                    if latest_version && download.version && latest_version.id != download.version.id
                        options.merge!(:class => 'old-version')
                    end
                    button = download_button(project, download, options)
                end
            end

            button
        end
    end

end
