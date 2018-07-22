if Meteor.isClient

	comp =
		layout: (content) ->
			view: -> m \div,
				m \.navbar-fixed, m \nav.green, m \.nav-wrapper,
					m \a.brand-logo.center, 'Konten Tabel'
					m \ul.right,
						m \li, m \a, \Login
				m \ul.fixed.side-nav,
					m \li.grey.lighten-2, m \a.center, m \b, 'Daftar Tabel'
					m \li, m \a,
						href: '/tabel'
						oncreate: m.route.link
						m \span, 'Semua Tabel'
					tabel.find!fetch!map (i) ->
						m \li, m \a,
							href: "/tabel/#{i.idtabel}"
							oncreate: m.route.link
							m \b, i.title.substring 0, 32
				m \div, style: "padding-left: 160px",
					m content

		unggah: ->
			fileInput = ({target}) ->
				Papa.parse target.files.0, complete: (res) ->
					reducer = (acc, val) ->
						if acc[val.0] then acc[val.0]push _.tail val
						else acc[val.0] = [_.tail val]
						acc
					reduced =  _.reduce res.data, reducer, {}
					_.map reduced, ([[title, ...], header, ...rows], idtabel) ->
						tabel.insert {idtabel, title, header, rows} if idtabel
			view: -> m \.container,
				m \br
				m \.btn, m \input,
					type: \file name: \Upload, onchange: fileInput

		tabel: ->
			view: ->
				datas =
					if m.route.param \idtabel
						[tabel.findOne idtabel: that]
					else tabel.find!fetch!
				m \.container, datas.map (i) ->
					m \h4, i.title
					m \table,
						m \tr, i.header.map (j) -> m \th, j
						i.rows.map (j) ->
							m \tr, j.map (k) -> m \td, k

	Meteor.subscribe \tabel, onReady: ->
		m.route document.body, \/semua,
			'/tabel': comp.layout comp.tabel
			'/tabel/:idtabel': comp.layout comp.tabel
			'/unggah': comp.layout comp.unggah
