require 'spec_helper'

describe "webhook operations" do
  it 'invokes webhook operations' do
    puts 'create webhooks'
    resource_id = @test_folder.id
    type = 'folder'
    triggers = ['FOLDER.RENAMED']
    address =  'https://example.com'
    new_webhook = BOX_CLIENT.create_webhook(resource_id, type, triggers, address)
    new_webhook_id = new_webhook.id
    expect(new_webhook.created_at).to_not be_empty

    puts 'get webhooks'
    all_webhooks = BOX_CLIENT.webhooks
    expect(all_webhooks.entries.first.id).to eq(new_webhook_id)

    single_webhook = BOX_CLIENT.webhook(new_webhook_id)
    expect(single_webhook.id).to eq(new_webhook_id)

    puts 'update webhooks'
    new_address = 'https://foo.com'
    updated_webhook = BOX_CLIENT.update_webhook(new_webhook, address: new_address)
    expect(updated_webhook.address).to eq(new_address)

    puts 'delete webhooks'
    deleted_webhook = BOX_CLIENT.delete_webhook(updated_webhook)
    expect(deleted_webhook).to be_empty
  end
end
