# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mutations::Auth::ForgotPassword, type: :request do
  let!(:user) { User.create!(email: 'user@example.com', password: 'password', confirmed_at: DateTime.now) }

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

  subject { result }

  context 'when valid parameters are given' do
    let(:variables) do
      {
        'email' => user.email
      }
    end

    before do
      subject
    end

    it 'sends a reset password instructions email' do
      email = ActionMailer::Base.deliveries.find{|email| email[:To].value == variables['email'] }

      expect(email[:To].value).to eq(user.email)
      expect(email[:Subject].value).to eq('Reset password instructions')
    end

    it 'returns a success' do
      expect(result['data']['forgotPassword']['errors']).to match_array([])
      expect(result['data']['forgotPassword']['success']).to be_truthy
      expect(result['data']['forgotPassword']['valid']).to be_truthy
    end
  end

  context 'when invalid parameters are given' do
    let(:variables) do
      {
        'email' => 'bademail@example.com'
      }
    end

    before do
      subject
    end

    it 'does not sends a reset password instructions email' do
      email = ActionMailer::Base.deliveries.find{|email| email[:To].value == variables['email'] }
      expect(email).to be_nil
    end

    it 'gives no clue about the failure' do
      subject
      expect(result['data']['forgotPassword']['errors']).to match_array([])
      expect(result['data']['forgotPassword']['success']).to be_truthy
      expect(result['data']['forgotPassword']['valid']).to be_truthy
    end
  end

  context 'when user is locked' do
    let!(:locked_user) { User.create!(email: 'locked_user@example.com', password: 'password', confirmed_at: DateTime.now) }

    let(:variables) do
      {
        'email' => locked_user.email
      }
    end

    before do
      locked_user.lock_access!
      subject
    end

    it 'does not sends a reset password instructions email' do
      email = ActionMailer::Base.deliveries.find{|email| email[:To].value == variables['email'] }
      expect(email).to be_nil
    end

    it 'gives no clue about the failure' do
      subject
      expect(result['data']['forgotPassword']['errors']).to match_array([])
      expect(result['data']['forgotPassword']['success']).to be_truthy
      expect(result['data']['forgotPassword']['valid']).to be_truthy
    end
  end
end
