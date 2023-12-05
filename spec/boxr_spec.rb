require 'spec_helper'

describe Boxr::Client do
  #PLEASE NOTE
  #These tests are intentionally NOT a series of unit tests.  The goal is to smoke test the entire code base
  #against an actual Box account, making real calls to the Box API.  The Box API is subject to frequent
  #changes and it is not sufficient to mock responses as those responses will change over time.  Successfully
  #running this test suite shows that the code base works with the current Box API.  The main premise here
  #is that an exception will be thrown if anything unexpected happens.

  #REQUIRED BOX SETTINGS
  # 1. The developer token used must have admin or co-admin priviledges
  # 2. Enterprise settings must allow Admin and Co-admins to permanently delete content in Trash

  #follow the directions in .env.example to set up your BOX_DEVELOPER_TOKEN
  #keep in mind it is only valid for 60 minutes

  #uncomment this line to see the HTTP request and response debug info in the rspec output
  # Boxr::turn_on_debugging

  it 'shows detailed errors' do
    expect do
      BOX_CLIENT.create_folder(nil, @test_folder)
    end.to raise_error(Boxr::BoxrError, "400: Bad Request, 'name' is required")
  end
end
