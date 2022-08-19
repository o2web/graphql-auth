# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::SignOut, type: :request do
  let!(:user) do
    user = User.create!(
      email: 'email@example.com',
      password: 'password'
    )
  end

  let(:result) do
    GraphqlSchema.execute(
      query_string,
      variables: variables,
      context: context
    )
  end

  let(:query_string) do
    <<-GRAPHQL
    mutation($refresh_token: String!) {
      resetPassword(refresh_token: $refresh_token) {
        success
        errors {
          field
          message
        }
        user
      }
    }
    GRAPHQL
  end

  let(:context) do
    {
      current_user: nil,
      response: ResponseMock.new(headers: {}),
    }
  end

  subject { result }

  context "when valid paramters are given" do
    let(:variables) do
      {
        "refresh_token" => user.refresh_token
      }
    end

    it "sign out the user" do
      subject

      expect(result.dig(["data"]["success"])).to be_truthy
    end
  end
  context "when invalid paramters are given" do
    let(:variables) do
      {
        "refresh_token" => nil
      }
    end

    it "returns error message" do
      subject

      expect(result.dig(["data"]["success"])).to be_falsey
      expect(result.dig(["data"]["user"])).to nil
    end
  end
end
