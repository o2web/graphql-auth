require 'jwt'

module GraphQL
  module Auth
    class JwtManager
      ALGORITHM = 'HS256'
      EXPIRATION = 4.hours
      TYPE = 'Bearer'
      
      class << self
        def issue(payload)
          token = JWT.encode payload.merge(expiration),
                             auth_secret,
                             ALGORITHM
          set_type token
        end
    
        def decode(token)
          token = extract_token token
          decrypted_token = JWT.decode token,
                                       auth_secret,
                                       true,
                                       { algorithm: ALGORITHM }
          decrypted_token.first
        end

        private
        
        def auth_secret
          ENV['JWT_SECRET_KEY']
        end

        def set_type(token)
          "#{TYPE} #{token}"
        end

        def extract_token(token)
          token.gsub "#{TYPE} ", ''
        end
        
        def expiration
          exp = Time.now.to_i + EXPIRATION
          { exp: exp }
        end
      end
    end
  end
end
