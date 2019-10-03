class Types::Auth::Inputs::UpdateAccount < Types::BaseInputObject
  graphql_name 'UpdateAccountInput'
  description 'Update account arguments'

  argument :email, String, required: true do
    description "User's email"
  end
end
