class Issues
	constructor:  (@q, @http, @repo) ->

	data: []

	index: ->
		r = @q.defer()
		@http.get("/repo/#{@repo}/issues.json").success (issues) =>
			@data = issues
			r.resolve @data
		r.promise

	create: (title, body, options={}) ->
		@http.post("/repo/#{@repo}/issues.json", {title:  title, body: body, options: options})
			.success (issue) =>
				@data.unshift issue

	update: (number, title, body, options={}) ->
		@http.put("repo/#{@repo}/issues/#{number}.json", {title: title, body: body, options: options})
			.success (issue) =>
				for _,i in @data when _.number.toString() == number
					@data[i] = issue

	destroy: (number, options={}) ->
		@http.delete("repo/#{@repo}/issues/#{number}.json", {options: options})
			.success (issue) =>
				for _,i in @data when _.number.toString() == number
					@data.splice i, 1

	get: (number) ->
		(i for i in @data when i.number.toString() == number)[0]


class kelasiTlineIssues extends Issues
	constructor: (q, http) ->
		super q, http, 'Kelasi/kelasiTline'

timeline_model.factory 'kelasiTlineIssues',
	['$q', '$http', ($q, $http)->
		new kelasiTlineIssues $q, $http
	]


class kelasiIssues extends Issues
	constructor: (q, http) ->
		super q, http, 'Kelasi/kelasi'

timeline_model.factory 'kelasiIssues',
	['$q', '$http', ($q, $http)->
		new kelasiIssues $q, $http
	]
