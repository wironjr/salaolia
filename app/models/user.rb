class User < ApplicationRecord
#reforça a segurança e cria o digest
    has_secure_password

    validates :nome, presence: true, length: {minimum:3, maximum:50}
    validates :password, presence: true, length: {minimum: 6}

end
