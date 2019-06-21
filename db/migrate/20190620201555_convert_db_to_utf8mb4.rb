class ConvertDbToUtf8mb4 < ActiveRecord::Migration
  def change
    config = Rails.configuration.database_configuration

    # database
    execute('ALTER DATABASE ' + config[Rails.env]["database"] + ' CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    
    # tables
    execute('ALTER TABLE hat_requests CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE messages CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE votes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE invitation_requests CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE taggings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE tags CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE keystores CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE invitations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE moderations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE hidden_stories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE stories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE hats CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE read_ribbons CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE suggested_taggings CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE tag_filters CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE schema_migrations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
    execute('ALTER TABLE suggested_titles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;')
  end
end
