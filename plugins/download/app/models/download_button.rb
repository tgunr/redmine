class DownloadButton < ActiveRecord::Base
    belongs_to :project

    validates_presence_of :project
    validates_length_of :label, :package, :maximum => 30
    validates_length_of :url, :maximum => 255
    validates_format_of :url, :with => /^https?:\/\//i, :if => Proc.new { |button| !button.url.blank? }

    def version
        if @version
            @version
        elsif file_id.to_i > 0
            attachment = Attachment.find_by_id(file_id)
            if attachment && attachment.container.is_a?(Version)
                @version = attachment.container
            end
        end
        @version ||= nil
    end

    # {{download(enable=true,
    #            url=http://projects.andriylesyuk.com/projects/redmine-download,
    #            version_id=1,
    #            version=0.0.1,
    #            file_id=1,
    #            file=download_0.0.1.tar.bz2,
    #            label=Get,
    #            package=Download Button,
    #            include_version=false)}}
    def self.from_options(project, options = {})
        download = DownloadButton.find_by_project_id(project) || DownloadButton.new(:project => project)

        if options[:enable]
            if options[:enable] == 'true' || options[:enable] == '1'
                download.disabled = false
            elsif options[:enable] == 'false' || options[:enable] == '0'
                download.disabled = true
            end
        end

        if options[:url]
            download.file_id = -1
            download.url = options[:url]
        end

        version = nil
        version_set = nil
        if options[:version_id]
            version = Version.find_by_id(options[:version_id])
            if version
                if version.attachments.any?
                    download.file_id = version.attachments.last.id
                    version_set = true
                else
                    version = nil
                    version_set = false
                end
            else
                version_set = false
            end
        end
        if options[:version] && !(version_set === true)
            version = Version.find_by_name(options[:version], :conditions => { :project_id => project.id })
            if version
                if version.attachments.any?
                    download.file_id = version.attachments.last.id
                    version_set = true
                else
                    version = nil
                    version_set = false
                end
            else
                version_set = false
            end
        end
        return nil if version_set === false

        file_set = nil
        if options[:file_id]
            attachment = Attachment.find_by_id(options[:file_id])
            if attachment && attachment.container.is_a?(Version) && attachment.container.project.id == project.id
                version = attachment.container
                download.file_id = attachment.id
                file_set = true
            else
                file_set = false
            end
        end
        if options[:file] && !(file_set === true)
            if version_set === true
                conditions = { :container_type => 'Version', :container_id => version.id }
            else
                versions = project.versions.collect{ |version| version.id }
                conditions = "container_type = 'Version' AND #{Attachment.table_name}.container_id IN (#{versions.join(', ')})"
            end
            attachment = Attachment.find_by_filename(options[:file], :conditions => conditions)
            if attachment
                version = attachment.container
                download.file_id = attachment.id
                file_set = true
            else
                file_set = false
            end
        end
        return nil if file_set === false

        if options[:label]
            download.label = options[:label]
        end

        if options[:package]
            download.package = options[:package]
        end

        if options[:include_version]
            if options[:include_version] == 'true' || options[:include_version] == '1' || options[:include_version] === true
                download.include_version = true
            elsif options[:include_version] == 'false' || options[:include_version] == '0' || options[:include_version] === false
                download.include_version = false
            end
        end

        download
    end

protected

    def validate
        if !disabled? && file_id.to_i < 0 && url.blank?
            errors.add(:url, :blank)
        end
    end

end
