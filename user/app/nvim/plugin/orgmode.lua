require('orgmode').setup({

  org_agenda_files = {'~/Nextcloud/org/*'},
  org_default_notes_file = '~/Nextcloud/org/refile.org',
  org_capture_templates = {
	r = {
      description = "Repo",
      template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
      target = "~/Nextcloud/org/repos.org",
		},

	T = {
		description = 'Todo',
	    template = '* TODO %?\n %u',
  		target = '~/Nextcloud/org/todo.org'
		}
  }	
})
