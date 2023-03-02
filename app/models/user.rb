class User < ApplicationRecord
#reforça a segurança e cria o digest
    has_secure_password

    validates :nome, presence: true, length: {minimum:3, maximum:50}, format: { without: /\s/ }, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: {minimum: 6}

    has_many :agendamentos

end
