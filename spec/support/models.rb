# Model that has nothing to do with this
class Ostracized < ActiveRecord::Base
  self.table_name = :ostracized
end

# Basic AR model
class Timestamp < ActiveRecord::Base
end

# Model with invalid attribute (not a timestamp)
class BadAttribute < ActiveRecord::Base
  updates_timestamp_on :timestamped_at
end

# Model with timestamp attribute, using faulty associations
class BadAssociations < Timestamp
  self.table_name = :timestamps
  updates_timestamp_on :timestamped_at, :using => [:herpderp]
end

# Model with timestamp attribute, no associations
class WithoutAssociations < Timestamp
  self.table_name = :timestamps
  updates_timestamp_on :timestamped_at
end

# Model with timestamp attribute, using association
class WithAssociations < Timestamp
  self.table_name = :timestamps
  updates_timestamp_on :timestamped_at, :using => [:method1, :method2]
end

# Model that doesn't have the attribute
# in the schema, but tries to use it anyway - this should fail!
class WithoutTimestamp < ActiveRecord::Base
  updates_timestamp_on :timestamped_at
end