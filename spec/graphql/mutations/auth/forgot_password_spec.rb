# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::ForgotPassword, type: :request do
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
    mutation($email: String!) {
     forgotPassword(email: $email) {
       errors {
         field
         message
       }
       success
       valid
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
      "email" => "email@example.com"
    }
  end

  let(:invalid_variables) do
    {
      "email" => "bademail@example.com"
    }
  end

  subject { result }

  context 'when valid parameters are given' do
    before do
      subject
    end

    it 'sends a reset password instructions email' do
      expect(ActionMailer::Base.deliveries.last[:To].value).to eq(User.last.email)
      expect(ActionMailer::Base.deliveries.last[:Subject].value).to eq('Reset password instructions')
    end

    it 'returns a success' do
      expect(result['data']['forgotPassword']['errors']).to match_array([])
      expect(result['data']['forgotPassword']['success']).to be_truthy
      expect(result['data']['forgotPassword']['valid']).to be_truthy
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

    it 'gives no clue about the failure' do
      subject
      expect(result['data']['forgotPassword']['errors']).to match_array([])
      expect(result['data']['forgotPassword']['success']).to be_truthy
      expect(result['data']['forgotPassword']['valid']).to be_truthy
    end
  end
end
