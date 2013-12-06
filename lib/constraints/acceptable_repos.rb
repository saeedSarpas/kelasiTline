class AcceptableRepos
	def self.matches?(req)
		%r(/repo/Kelasi/(kelasi|kelasiTline)/.*) === req.fullpath
	end
end
