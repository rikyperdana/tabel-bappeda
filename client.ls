if Meteor.isClient

	comp =
		layout: (content) ->
			view: -> m \div,
				m \.navbar-fixed, m \nav.green, m \.nav-wrapper,
					m \a.brand-logo.center, 'Daftar Tabel'
					m \ul.right,
						m \li, m \a, \Login
						m \li, m \a, \Register
				m \ul.fixed.side-nav,
					m \li, m \a.center, m \b, 'Menu Pilihan'
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

		semua: ->
			view: -> m \.container,
				tabel.find!fetch!map (i) -> m \div,
					m \h5, i.title
					m \table,
						m \tr, i.header.map (j) -> m \th, j
						i.rows.map (j) ->
							m \tr, j.map (k) -> m \td, k

	Meteor.subscribe \tabel, onReady: ->
		m.route document.body, \/semua,
			'/semua': comp.layout comp.semua
			'/unggah': comp.layout comp.unggah
