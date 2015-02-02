# `active_record-attr_updated_by`
[![Build Status](https://travis-ci.org/JakeTheSnake3p0/active_record-attr_updated_by.svg?branch=master)](https://travis-ci.org/JakeTheSnake3p0/active_record-attr_updated_by?branch=master)

Updates the timestamp of the attribute you specify based on other attributes.

For example, let's say you wanted to have your event RSS feed update only when the `start_time` or `end_time` attributes have changed. We don't want it to be updated if a user makes a typo edit to the description! Instead of using `updated_at`, we will use `rss_updated_at` in our feed view.

**Note:** `rss_updated_at` must exist in your database schema; otherwise you'll receive an error. Run your migrations as you see fit.

## Requirements

`AciveRecord`

## Step 1 - Install

Add this line to your application's Gemfile:

```ruby
gem 'active_record-attr_updated_by', :git => 'https://github.com/JakeTheSnake3p0/active_record-attr_updated_by.git'
```

And then execute:

    $ bundle

## Step 2 - Create Migration

```ruby
class AddRssTimestampToEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :rss_updated_at
    end
  end
end
```

## Step 3 - Update Your Model
```ruby
class Event < ActiveRecord::Base
  updates_timestamp_on :rss_updated_at, :using => [:start_time, :end_time]
end
```

## Step 4 - Profit!
`active_record-attr_updated_by` will update `rss_updated_at` just before saving the model. Your views will change (or not) accordingly.
