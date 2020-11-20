# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::SignUp, type: :request do
  let!(:user) do
    User.create!(email: 'email@example.com', password: 'password', confirmed_at: DateTime.now)
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

  subject { result }

  context 'when valid parameters are given' do
    let(:variables) do
      {
        'email' => 'email@example.com',
        'password' => 'password',
        'rememberMe' => false
      }
    end

    it 'sign in the user' do
      subject
      expect(result['data']['signIn']['success']).to be_truthy
      expect(result['data']['signIn']['user']['email']).to eq(User.last.email)
    end
  end

  context 'when invalid parameters are given' do
    let(:variables) do
      {
        'email' => 'email@example.com',
        'password' => 'password2',
        'rememberMe' => false
      }
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

  context 'when user is locked' do
    before do
      user.lock_access!
    end

    let(:variables) do
      {
        'email' => 'email@example.com',
        'password' => 'password',
        'rememberMe' => false
      }
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
