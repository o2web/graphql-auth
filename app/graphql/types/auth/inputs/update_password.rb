class Types::Auth::Inputs::UpdatePassword < Types::BaseInputObject
  description 'Update password arguments'

  argument :current_password, String, required: true do
    description "User's current password"
  end

  argument :password, String, required: true do
    description "User's new password"
  end

  argument :password_confirmation, String, required: true do
    description "User's new password confirmation"
  end
end
