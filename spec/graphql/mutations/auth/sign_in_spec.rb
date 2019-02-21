# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::SignUp, type: :request do
  before do
    User.create!(email: 'email@example.com', password: 'password')
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
    mutation($email: String!, $password: String!, $rememberMe: Boolean!) {
      signIn(email: $email, password: $password, rememberMe: $rememberMe) {
        success
        user {
          email
        }
        errors {
          field
          message
        }
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

  let(:variables) do
    {
      "email" => "email@example.com",
      "password" => "password",
      "rememberMe" => false
    }
  end

  let(:invalid_variables) do
    {
      "email" => "email@example.com",
      "password" => "password2",
      "rememberMe" => false
    }
  end

  subject { result }

  context 'when valid parameters are given' do
    it 'sign in the user' do
      subject
      expect(result['data']['signIn']['success']).to be_truthy
      expect(result['data']['signIn']['user']['email']).to eq(User.last.email)
    end
  end

  context 'when invalid parameters are given' do
    let(:result) do
      GraphqlSchema.execute(
        query_string,
        variables: invalid_variables,
        context: context
      )
    end

    it 'fails to sign in the user' do
      subject
      expect(result['data']['signIn']['success']).to be_falsey
      expect(result['data']['signIn']['user']).to be_nil
      expect(result['data']['signIn']['errors'].first['message']).to eq(
        I18n.t('devise.failure.invalid', authentication_keys: I18n.t('activerecord.attributes.user.email'))
      )
    end
  end
end
