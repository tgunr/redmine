require_dependency 'setting'

module SidebarSettingPatch

    def self.included(base)
        base.class_eval do
            unloadable

            available_settings['plugin_sidebar'] = {
                'default' => {
                    :policy => :global,
                    :pages  => { }
                },
                'serialized' => true
            }

            def self.plugin_sidebar
                self[:plugin_sidebar]
            end

            # Copy of: def self.[]=(name, v)
            def self.plugin_sidebar=(v)
                setting = find_or_default(:plugin_sidebar)
                setting.value = (v ? v : '')
                setting.save((Rails::VERSION::MAJOR < 3) ? false : { :validate => false })
                @cached_settings[:plugin_sidebar] = nil if @cached_settings
                Rails.cache.delete("chiliproject/setting/plugin_sidebar")
                setting.value
            end

        end
    end

end
