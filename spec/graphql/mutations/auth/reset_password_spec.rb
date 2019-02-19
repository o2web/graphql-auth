# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::ResetPassword, type: :request do
  before do
    user = User.create!(
      email: 'email@example.com',
      password: 'password'
    )
    @reset_password_token = user.send_reset_password_instructions
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
    mutation($resetPasswordToken: String!, $password: String!, $passwordConfirmation: String!) {
      resetPassword(resetPasswordToken: $resetPasswordToken, password: $password, passwordConfirmation: $passwordConfirmation) {
        success
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
      "resetPasswordToken" => @reset_password_token,
      "password" => "password",
      "passwordConfirmation" => "password"
    }
  end

  let(:invalid_variables) do
    {
      "resetPasswordToken" => '1234567890',
      "password" => "password",
      "passwordConfirmation" => "password"
    }
  end

  subject { result }

  context 'when valid parameters are given' do
    it 'succeeds to reset the password' do
      subject
      expect(result['data']['resetPassword']['success']).to be_truthy
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

    it 'fails to reset the password' do
      subject
      expect(result['data']['resetPassword']['success']).to be_falsey
    end
  end
end
