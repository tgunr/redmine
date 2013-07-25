class Download < ChiliProject::Liquid::Tags::Tag

    def initialize(tag_name, markup, tokens)
        markup = markup.strip
        if markup =~ %r{^\((.*)\)$}
            markup = $2
        end

        if markup.present?
            @options = {}
            markup.split(',').each do |arg|
                if arg.strip =~ %r{^([^=]+)\=(.*)$}
                    name, value = $1.strip.downcase.to_sym, $2.strip
                    if value =~ %r{^(["'])(.*)\1$}
                        value = $2
                    end
                    @options[name] = value
                end
            end
        else
            @options = {}
        end

        super
    end

    def render(context)
        button = ''

        if @options[:project]
            project = Project.find_by_identifier(@options[:project])
        elsif context['project'].present?
            project = Project.find_by_identifier(context['project'].identifier)
        elsif context.registers[:object].respond_to?(:project)
            project = context.registers[:object].project
        end

        if project && project.versions.any?
            download = DownloadButton.from_options(project, @options)
            if download && !download.disabled?
                latest_version = context.registers[:view].latest_version(project)
                if latest_version && download.version && latest_version.id != download.version.id
                    @options.merge!(:class => 'old-version')
                end
                button = context.registers[:view].download_button(project, download, @options)
            end
        end

        button
    end

end
