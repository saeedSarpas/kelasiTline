class Milestones
	constructor: (@q, @http, @repo) ->

	data: []

	index: ->
		r = @q.defer()
		@http.get("/repo/#{@repo}/milestones.json").success (milestones) ->
			@data = milestones
			r.resolve @data
		r.promise

	create: (title, options={}) ->
		@http.post("/repo/#{@repo}/milestones.json", {title:  title, options: options})
			.success (milestones) =>
				@data.unshift milestones

class kelasiTlineMilestones extends Milestones
	constructor: (q, http) ->
		super q, http, 'Kelasi/kelasiTline'

timeline_model.factory 'kelasiTlineMilestones',
	['$q', '$http', ($q, $http)->
		new kelasiTlineMilestones $q, $http
	]

class kelasiMilestones extends Milestones
	constructor: (q, http) ->
		super q, http, 'Kelasi/kelasi'

timeline_model.factory 'kelasiMilestones',
	['$q', '$http', ($q, $http)->
		new kelasiMilestones $q, $http
	]
