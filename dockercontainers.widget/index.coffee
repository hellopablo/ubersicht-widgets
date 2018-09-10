style: """
	color: white
	right: 30px
	bottom: 30px
	font-size: 13px
	font-family: SFNS Display, 'Helvetica Neue', sans-serif
	text-shadow: 1px 1px 0 rgba(#000, 0.4)
	background-color: rgba(0, 0, 0, 0.5)
	padding: 12px
	border-radius: 3px
	border: 1px solid #222

	table
		margin: 0 auto
		td
			padding: 0px
			padding-bottom: 0.5rem;
		td.actions
			padding-left: 0.5rem;
		tr:last-child
			td
				padding-bottom: 0;

	table:empty + .actions
		display: none;

	.ip
		opacity: 0.6
		font-size: 13px

	.indicator
		font-size: 20px
		padding: 0 12px
		&.running
			color: rgb(153, 227, 160)
		&.stopped
			color: rgb(244, 115, 94)
	.restart, .shell
		cursor: pointer
		padding: 3px 5px
		border: none
		border-radius: 2px
		background-color: #CCC

	small
		display: block;
		color: #999;
		margin-top: 0.25rem;

	.actions
		margin-top: 0.5rem;

	.kill,.pstorm,.terminal
		display: inline-block;
		width: 100%;
		border: 0;
		padding: 5px;
		color: #fff;
		background: #D7262E;
		margin-top: 0.5rem;
		width: 33%;

	.pstorm
		background: #7E3AEC;
	.terminal
		background: #222;
"""

command: "dockercontainers.widget/helper.sh getStatus"

refreshFrequency: 5000

render: -> """
	<div>
  	<table></table>
  	<div class="actions">
	  	<button class="kill">☠️</button><!--
	  	--><button class="pstorm">✏️</button<!--
	  	--><button class="terminal">🖥</button>
  	</div>
	</div>
"""

afterRender: (domEl) ->

	$(domEl).on 'click', '.restart', (e) =>
		image = $(e.currentTarget).attr 'data-image'
		@run "dockercontainers.widget/helper.sh restart " + image

	$(domEl).on 'click', '.shell', (e) =>
		image = $(e.currentTarget).attr 'data-image'
		@run "dockercontainers.widget/helper.sh shell " + image

	$(domEl).on 'click', '.kill', (e) =>
		@run "dockercontainers.widget/helper.sh kill"

	$(domEl).on 'click', '.pstorm', (e) =>
		@run "dockercontainers.widget/helper.sh pstorm"

	$(domEl).on 'click', '.terminal', (e) =>
		@run "dockercontainers.widget/helper.sh terminal"

update: (output, domEl) ->
	machines 	= output.split("\n")
	table = $(domEl).find('table')

	table.html('')

	renderMachine = (image, name, size, status) -> """
		<tr>
			<td>
				#{ name }
			</td>
		</tr>
	"""

	for machine in machines
		[image, name, size, status] = machine.split('|')
		if image.length > 0
			table.append renderMachine(image, name, size, status)
