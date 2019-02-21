# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::ValidateToken, type: :request do
  before do
    @user = User.create!(
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
    mutation {
      validateToken {
        success
        valid
        user {
          email
        }
      }
    }
    GRAPHQL
  end

  let(:context) do
    {
      current_user: @user,
      response: ResponseMock.new(headers: {}),
    }
  end

  let(:variables) { {} }

  subject { result }

  context 'when user is logged in' do
    it 'succeeds to validate the token' do
      subject

      expect(result['data']['validateToken']['success']).to be_truthy
      expect(result['data']['validateToken']['user']['email']).to eq(@user.email)
    end
  end

  context 'when user is not logged in' do
    let(:context) do
      {
        current_user: nil,
        response: ResponseMock.new(headers: {}),
      }
    end

    it 'fails to validate the token' do
      subject

      expect(result['data']['validateToken']['success']).to be_falsey
      expect(result['data']['validateToken']['user']).to be_nil
    end
  end
end
