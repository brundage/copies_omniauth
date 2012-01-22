ActiveRecord::Schema.define(:version => 0) do

  create_table :active_record_profiles, :force => true do |t|
    t.string :name, :null => false
    t.string :uid, :null => false
    t.string :token, :null => false
  end

end
