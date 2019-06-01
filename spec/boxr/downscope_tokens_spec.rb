require 'spec_helper'

describe 'downscope tokens' do
  it 'requests downscope tokens' do
    app_user_id = @test_user.id
    jwt_token = Boxr.get_user_token(app_user_id).access_token
    scopes = %w[item_upload item_preview base_explorer]
    downscope_token = Boxr.downscope_token(jwt_token, scopes: scopes)
    expect(downscope_token.access_token).to_not be_nil
    expect(downscope_token.restricted_to).to be_kind_of(Array)

    app_user_client = Boxr::Client.new(jwt_token)
    app_user_folder = app_user_client.create_folder(TEST_FOLDER_NAME, Boxr::ROOT)

    ui_element_downscope_token = Boxr.downscope_token_for_box_ui_element(jwt_token, app_user_folder.id)
  end
end
