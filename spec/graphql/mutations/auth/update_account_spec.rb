# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::UpdateAccount, type: :request do
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
    mutation($currentPassword: String!, $password: String!, $passwordConfirmation: String!) {
      updateAccount(currentPassword: $currentPassword, password: $password, passwordConfirmation: $passwordConfirmation) {
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
      current_user: @user,
      response: ResponseMock.new(headers: {}),
    }
  end

  let(:variables) do
    {
      "currentPassword" => "password",
      "password" => "newpassword",
      "passwordConfirmation" => "newpassword"
    }
  end

  let(:invalid_variables) do
    {
      "currentPassword" => "badpassword",
      "password" => "newpassword",
      "passwordConfirmation" => "newpassword"
    }
  end

  subject { result }

  context 'when the user is logged in' do
    let(:context) do
      {
        current_user: @user,
        response: ResponseMock.new(headers: {}),
      }
    end

    context 'when valid parameters are given' do
      it 'succeeds to update the account' do
        subject

        expect(result['data']['updateAccount']['success']).to be_truthy
        expect(result['data']['updateAccount']['user']['email']).to eq(@user.email)
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

      it 'fails to update the account' do
        subject
        expect(result['data']['updateAccount']['success']).to be_falsey
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
      it 'fails to update the account' do
        subject
        expect(result['data']['updateAccount']['success']).to be_falsey
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

      it 'fails to update the account' do
        subject
        expect(result['data']['updateAccount']['success']).to be_falsey
      end
    end
  end
end
