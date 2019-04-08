# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::UpdatePassword, type: :request do
  let!(:user) do
    User.create!(
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
    mutation($currentPassword: String!, $password: String!, $passwordConfirmation: String!) {
      updatePassword(currentPassword: $currentPassword, password: $password, passwordConfirmation: $passwordConfirmation) {
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

  subject { result }

  context 'when the user is logged in' do
    let(:context) do
      {
        current_user: user,
        response: ResponseMock.new(headers: {}),
      }
    end

    context 'when valid parameters are given' do
      let(:variables) do
        {
          'currentPassword' => 'password',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'succeeds to update the password' do
        subject

        expect(result['data']['updatePassword']['success']).to be_truthy
        expect(result['data']['updatePassword']['user']['email']).to eq(user.email)
      end
    end

    context 'when invalid parameters are given' do
      let(:variables) do
        {
          'currentPassword' => 'badpassword',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'fails to update the password' do
        subject
        expect(result['data']['updatePassword']['success']).to be_falsey
      end
    end

    context 'when user is locked' do
      before do
        user.lock_access!
      end

      let(:variables) do
        {
          'currentPassword' => 'badpassword',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'fails to update the password' do
        subject
        expect(result['data']['updatePassword']['success']).to be_falsey
      end
    end
  end

  context 'when the user not is logged in' do
    let(:context) do
      {
        current_user: nil,
        response: ResponseMock.new(headers: {}),
      }
    end

    context 'when valid parameters are given' do
      let(:variables) do
        {
          'currentPassword' => 'password',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'fails to update the password' do
        subject
        expect(result['data']['updatePassword']['success']).to be_falsey
      end
    end

    context 'when invalid parameters are given' do
      let(:variables) do
        {
          'currentPassword' => 'badpassword',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'fails to update the password' do
        subject
        expect(result['data']['updatePassword']['success']).to be_falsey
      end
    end

    context 'when user is locked' do
      before do
        user.lock_access!
      end

      let(:variables) do
        {
          'currentPassword' => 'badpassword',
          'password' => 'newpassword',
          'passwordConfirmation' => 'newpassword'
        }
      end

      it 'fails to update the password' do
        subject
        expect(result['data']['updatePassword']['success']).to be_falsey
      end
    end
  end
end
