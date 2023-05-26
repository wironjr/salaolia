module AgendamentosHelper
    include Pagy::Frontend

    def maiusculo(nome)
		nome_array = nome.split(" ")
		upper = nome_array.map(&:capitalize)
		upper_all = upper.join(" ")
		upper_all
	end
end
