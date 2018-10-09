require 'jwt'

module GraphQL
  module Auth
    class ResetPassword
      class << self
        def url(token)
          url = I18n.locale === :fr ? 'nouveau-mot-de-passe' : 'new-password'
          "#{ENV['APP_URL']}/#{I18n.locale}/#{url}/#{token}"
        end
      end
    end
  end
end
