# frozen_string_literal: true

require 'spec_helper'

describe Boxr::BoxrError do
  describe '#message' do
    subject { described_class.new(status: status, body: response_body, header: header, boxr_message: boxr_message) }

    context 'header' do
      let(:status) { 400 }
      let(:response_body) do
        { "error" => "invalid_grant", "error_description" => "The authorization code has expired" }.to_json
      end
      let(:boxr_message) { nil }
      let(:expected_message) do
        { "error" => "invalid_grant", "error_description" => "The authorization code has expired", "status" => status }.to_json
      end
      let(:auth_header) { 'auth_header' }
      let(:header) do
        { 'WWW-Authenticate' => [auth_header] }
      end
      let(:expected_message) { "#{status}: #{auth_header}" }

      it 'is status and header' do
        expect(subject.message).to eq(expected_message)
      end
    end

    context 'response body has message and context info' do
      let(:message) { 'The authorization code has expired' }
      let(:context_info_error) { 'auth code' }
      let(:context_info) do
        { errors: [ { message: context_info_error }] }
      end
      let(:status) { 400 }
      let(:response_body) do
        { "error" => "invalid_grant", "message" => message, "context_info" => context_info }.to_json
      end
      let(:header) { nil }
      let(:boxr_message) { nil }
      let(:expected_message) { "#{status}: #{message}, #{context_info_error}" }

      it 'is response body message with context info errors and status' do
        expect(subject.message).to eq(expected_message)
      end
    end

    context 'boxr message' do
      let(:status) { 400 }
      let(:response_body) do
        { "error" => "invalid_grant", "error_description" => "The authorization code has expired" }.to_json
      end
      let(:header) { nil }
      let(:boxr_message) { 'The authorization code has expired' }

      it 'is boxr message' do
        expect(subject.message).to eq(boxr_message)
      end
    end

    context 'no header or boxr message' do
      let(:status) { 400 }
      let(:response_body) do
        { "error" => "invalid_grant", "error_description" => "The authorization code has expired" }.to_json
      end
      let(:header) { nil }
      let(:boxr_message) { nil }
      let(:expected_message) do
        { "error" => "invalid_grant", "error_description" => "The authorization code has expired", "status" => status }.to_json
      end

      it 'is string of status code and response body' do
        expect(subject.message).to eq(expected_message)
      end
    end
  end
end
