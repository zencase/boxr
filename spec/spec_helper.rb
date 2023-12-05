# frozen_string_literal: true

require 'dotenv'; Dotenv.load
require 'simplecov'; SimpleCov.start { add_filter "_spec" }
require 'boxr'
require 'awesome_print'

BOX_CLIENT = Boxr::Client.new # using ENV['BOX_DEVELOPER_TOKEN']
BOX_SERVER_SLEEP = 5
TEST_FOLDER_NAME = 'Boxr Test'
SUB_FOLDER_NAME = 'sub_folder_1'
SUB_FOLDER_DESCRIPTION = 'This was created by the Boxr test suite'
TEST_FILE_NAME = 'test file.txt'
TEST_FILE_NAME_CUSTOM = 'test file custom.txt'
DOWNLOADED_TEST_FILE_NAME = 'downloaded test file.txt'
COMMENT_MESSAGE = 'this is a comment'
REPLY_MESSAGE = 'this is a comment reply'
CHANGED_COMMENT_MESSAGE = 'this comment has been changed'
TEST_USER_LOGIN = "test-boxr-user@#{('a'..'z').to_a.shuffle[0,10].join}.com" # needs to be unique across anyone running this test
TEST_USER_NAME = "Test Boxr User"
TEST_GROUP_NAME= "Test Boxr Group"
TEST_TASK_MESSAGE = "Please review"
TEST_WEB_URL = 'https://www.box.com'
TEST_WEB_URL2 = 'https://www.google.com'

RSpec.configure do |config|
  config.before(:each) do
    puts "-----> Resetting Box Environment"
    sleep BOX_SERVER_SLEEP
    root_folders = BOX_CLIENT.root_folder_items.folders
    test_folder = root_folders.find{|f| f.name == TEST_FOLDER_NAME}
    if(test_folder)
      BOX_CLIENT.delete_folder(test_folder, recursive: true)
    end
    new_folder = BOX_CLIENT.create_folder(TEST_FOLDER_NAME, Boxr::ROOT)
    @test_folder = new_folder

    all_users = BOX_CLIENT.all_users
    test_users = all_users.select{|u| u.name == TEST_USER_NAME}
    test_users.each do |u|
      BOX_CLIENT.delete_user(u, force: true)
    end
    sleep BOX_SERVER_SLEEP
    test_user = BOX_CLIENT.create_user(TEST_USER_NAME, login: TEST_USER_LOGIN)
    @test_user = test_user

    all_groups = BOX_CLIENT.groups
    test_group = all_groups.find{|g| g.name == TEST_GROUP_NAME}
    if(test_group)
      BOX_CLIENT.delete_group(test_group)
    end
  end
end
