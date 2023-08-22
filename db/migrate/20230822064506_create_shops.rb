class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops, id: :uuid do |t|
      t.string :store_url
      t.string :scope, array: true, default: []
      t.string :auth_session_id
      t.string :state
      t.string :shopify_session_id
      t.string :access_token
      t.datetime :expires_at
      t.boolean :is_online

      t.timestamps
    end
  end
end
