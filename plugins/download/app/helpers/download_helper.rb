module DownloadHelper

    def download_button(project, download = nil, options = {})
        if download && download.file_id.to_i > 0
            attachment = Attachment.find(download.file_id.to_i)
            if attachment && attachment.container.is_a?(Version)
                version = attachment.container
            end
        end
        version = latest_version(project) if version.nil?

        if version && (options[:force] || version.attachments.any? || (download && download.file_id.to_i < 0))
            return render(:partial => 'download/button',
                          :locals  => { :label   => download_label(version, download),
                                        :package => download_package(version, download),
                                        :link    => download_link(version, download),
                                        :style   => options[:class],
                                        :align   => options[:align] })
        end
    end

private

    def latest_version(project)
        project.versions.find(:all, :include => :attachments).sort.reverse.each do |version|
            return version if version.is_a?(Version) && version.closed?
        end
        nil
    end

    def download_link(version, download)
        if download && download.file_id.to_i < 0
            download.url
        elsif download && download.file_id.to_i > 0
            attachment = Attachment.find(download.file_id.to_i)
            if attachment
                url_for(
                    :controller => 'attachments',
                    :action     => 'download',
                    :id         => attachment,
                    :filename   => attachment.filename
                )
            end
        else
            if version.attachments.any?
                url_for(
                    :controller => 'attachments',
                    :action     => 'download',
                    :id         => version.attachments.last,
                    :filename   => version.attachments.last.filename
                )
            end
        end
    end

    def download_label(version, download = nil)
        if download && download.file_id.to_i < 0
            download.label.present? ? h(download.label) : l(:locale_download)
        elsif version.attachments_visible?
            download && download.label.present? ? h(download.label) : l(:locale_download)
        else
            l(:locale_authorize)
        end
    end

    def download_package(version, download = nil)
        package = ''
        if download && download.file_id.to_i < 0
            package = download.package.present? ? h(download.package) : h(version.project.name)
            package += ' ' + h(version.name) if download.include_version?
        elsif version.attachments_visible?
            package = download && download.package.present? ? h(download.package) : h(version.project.name)
            package += ' ' + h(version.name) if !download || download.include_version?
        else
            package = l(:locale_to_download)
        end
        package
    end

end
