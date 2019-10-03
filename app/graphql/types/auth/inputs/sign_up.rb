class Types::Auth::Inputs::SignUp < Types::BaseInputObject
  graphql_name 'SignUpInput'
  description 'Sign up arguments'

  argument :email, String, required: true do
    description "New user's email"
  end

  argument :password, String, required: true do
    description "New user's password"
  end

  argument :password_confirmation, String, required: true do
    description "New user's password confirmation"
  end
end
