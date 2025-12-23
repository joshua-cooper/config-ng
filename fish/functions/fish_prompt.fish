function fish_prompt
	set -l last_status $status
	set -l last_pipestatus $pipestatus
	set -l color_normal (set_color normal)

	set -l pwd_string (prompt_pwd)$color_normal

	if fish_is_root_user
		set pwd_string " "(set_color $fish_color_cwd_root)$pwd_string
	else
		set pwd_string " "(set_color $fish_color_cwd)$pwd_string
	end

	set -l status_string ""

	if not contains $last_status 0 141
		set -l color_status (set_color $fish_color_status)
		set -l separator $color_normal"|"$color_status
		set -l pipestatus_string (
			fish_status_to_signal $last_pipestatus \
				| string join $separator
		)

		set status_string (
			string join "" \
				" " \
				$color_status \
				$pipestatus_string \
				$color_normal
		)

		if test "$last_status" -ne "$last_pipestatus[-1]"
			set status_string (
				string join "" \
					$status_string \
					" -> " \
					$color_status \
					$last_status \
					$color_normal
			)
		end
	end

	set -l info_string (
		string join "" -- \
			(prompt_login) \
			$pwd_string \
			(fish_vcs_prompt) \
			$status_string
	)

	printf "%s\n> " $info_string
end
