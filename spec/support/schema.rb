ActiveRecord::Schema.define do
  self.verbose = false

  create_table :timestamps, :force => true do |t|
    t.datetime :timestamped_at
    t.boolean :marked_for_change
    t.integer :method1
    t.integer :method2
    t.string :ignored
  end

  create_table :without_timestamps, :force => true do |t|
  end

  create_table :ostracized, :force => true do |t|
  end

  create_table :bad_attributes, :force => true do |t|
    t.string :timestamped_at
  end
end
