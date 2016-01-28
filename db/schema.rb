# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110412025747) do

  create_table "categories", :force => true do |t|
    t.integer  "user_id"
    t.string   "label"
    t.integer  "size"
    t.integer  "listorder"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "goals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goaltype_id"
    t.string   "description"
    t.datetime "datecompleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completedflag"
    t.integer  "percentcomplete"
  end

  add_index "goals", ["goaltype_id"], :name => "index_goals_on_goaltype_id"
  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "goaltypes", :force => true do |t|
    t.string   "label"
    t.integer  "daysinperiod"
    t.integer  "listorder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "itemcolors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "listorder"
    t.string   "color"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taskhistories", :force => true do |t|
    t.integer  "task_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taskhistories", ["category_id"], :name => "index_taskhistories_on_category_id"
  add_index "taskhistories", ["task_id"], :name => "index_taskhistories_on_task_id"

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "itemcolor_id"
    t.integer  "percentcomplete"
  end

  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "salt"
    t.boolean  "premiumaccount"
    t.boolean  "adminaccount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "encrypted_password"
    t.string   "remember_token"
    t.string   "reset_code"
    t.datetime "accountexpiration"
    t.boolean  "percentcompleteenabled"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_code"], :name => "index_users_on_reset_code"

end
