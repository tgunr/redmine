class CreateSidebarSettings < ActiveRecord::Migration

    def self.up
        create_table :sidebar_settings do |t|
            t.column :project_id, :integer, :null => false
            t.column :pages,      :text
        end
        add_index :sidebar_settings, :project_id, :unique => true, :name => :sidebar_settings_project_id
    end

    def self.down
        drop_table :sidebar_settings
    end

end
