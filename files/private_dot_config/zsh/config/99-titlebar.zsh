# Initially based off of https://github.com/pawel-slowik/zsh-term-title

: ${TERM_TITLE_SET_MULTIPLEXER:=1}

function __is_remote_session() {
	# SSH, mosh, eterminal detection
	[[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $MOSH_CONNECTION || -n $ETERM_SESSION_ID ]]
}

function __term_set_title() {
	emulate -L zsh
	local term_is_known=0 term_is_multi=0
	if [[ \
		$TERM == rxvt-unicode* \
		|| $TERM == xterm* \
		|| ! -z $TMUX \
	]] then
		term_is_known=1
	fi
	if [[ ! -z $TMUX ]] then
		term_is_multi=1
	fi
	if [[ $term_is_known -ne 1 ]] then
		return
	fi
	printf '\033]0;%s\007' ${1//[^[:print:]]/}
	if [[ \
		$TERM_TITLE_SET_MULTIPLEXER -eq 1 \
		&& $term_is_multi -eq 1 \
	]] then
		printf '\033k%s\033\\' ${1//[^[:print:]]/}
	fi
}

function __term_title_get_command() {
	emulate -L zsh
	local job_text job_key
	typeset -g RETURN_COMMAND
	RETURN_COMMAND=$1
	# Since ~4.3.5, patch:
	# "users/11818: allow non-numeric keys for job status parameters"
	# it is possible to use the `fg ...` or `%...` description as a key
	# in $jobtexts.
	case $1 in
		%*) job_key=$1 ;;
		fg) job_key=%+ ;;
		fg*) job_key=${(Q)${(z)1}[2,-1]} ;;
		*) job_key='' ;;
	esac
	if [[ -z $job_key ]] then
		# not a "job to foreground" command - use it as is
		return
	fi
	job_text=${jobtexts[$job_key]} 2> /dev/null
	if [[ -z $job_text ]] then
		# job lookup failed - use the original command
		return
	fi
	RETURN_COMMAND=$job_text
}

# SSH indicator
function __titlebar_ssh_indicator() {
	if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT ]]; then
		echo "🔒"
	fi
}

function __term_title_precmd() {
	emulate -L zsh
	local shell_name="${SHELL:t}"
	local dir="${PWD/#$HOME/~}"
	# local host="${HOST:-$(hostname -s)}"  # not needed for local
	local user="${USER:-$(whoami)}"
	local title=""
	local ssh_status="$(__titlebar_ssh_indicator)"
	if __is_remote_session; then
		local host="${HOST:-$(hostname -s)}"
		title="${ssh_status} ${user}@${host} / ${shell_name}"
	else
		title="${ssh_status} 💻 ${shell_name}"
	fi
	__term_set_title "${title}"
}

function __term_title_preexec() {
	emulate -L zsh
	__term_title_get_command $1
	local cmd=$RETURN_COMMAND
	local dir="${PWD/#$HOME/~}"
	# local host="${HOST:-$(hostname -s)}"  # not needed for local
	local user="${USER:-$(whoami)}"
	local title=""
	local ssh_status="$(__titlebar_ssh_indicator)"
	if __is_remote_session; then
		local host="${HOST:-$(hostname -s)}"
		title="${ssh_status} ${user}@${host} / ${cmd}"
	else
		title="${ssh_status} 💻 ${SHELL:t} / ${cmd}"
	fi
	__term_set_title "${title}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __term_title_precmd
add-zsh-hook preexec __term_title_preexec
