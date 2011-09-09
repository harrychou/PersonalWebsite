module ApplicationHelper
	def title
		base_title = "HarryChou"
		if @title.nil?
			base_title
		else
			"#{base_title} > #{@title}"
		end
	end
end
